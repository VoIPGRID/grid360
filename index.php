<?php

require_once('error.php');
require_once('config.php');
require_once(LIB_DIR . 'limonade/lib/limonade.php');
require_once(LIB_DIR . 'redbeanphp/rb.php');
require_once(LIB_DIR . 'multitenancy_writer.php');
require_once(LIB_DIR . 'phpass-0.3/PasswordHash.php');
include_once(LIB_DIR . 'sacy/sacy.php');
require_once('constants.php');

function configure()
{
    option('base_uri', BASE_URI);  # '/' or same as the RewriteBase or ENV:FRB in your .htaccess
    option('views_dir', BASE_DIR . 'views/');
    option('controllers_dir', BASE_DIR . 'controllers/');
    error_layout('layout/basic.php');

    RedBean_Plugin_Cooker::enableBeanLoading(true);
}

function before()
{
    global $smarty;
    $smarty->assign('current_user', $_SESSION['current_user']);
    $smarty->assign('locale', strtolower(substr(getenv('LANG'), 0, 2)));

    $info_message = R::findOne('infomessage');

    if(!empty($_SESSION['current_user']) && ($info_message->id == 0 || $_SESSION['current_user']->info_message_read))
    {
        layout('layout/layout.php');
    }
    // Check if the current url isn't infomessage so we don't get a redirect loop
    else if(!empty($_SESSION['current_user']) && $info_message->id != 0 && str_replace(BASE_URI, '', $_SERVER['REQUEST_URI']) != 'infomessage')
    {
        redirect_to('infomessage');
    }
    else
    {
        layout('layout/basic.php');
    }
}

R::setup(CONNECTION, DB_USERNAME, DB_PASSWORD);

$writer = new Multitenancy_QueryWriter_MySQL(R::$adapter);
R::configureFacadeWithToolbox(new RedBean_ToolBox(new RedBean_OODB($writer), R::$adapter, $writer));

R::freeze(true);
//R::debug(true);

dispatch('/', 'dashboard');
dispatch('/infomessage', 'info_message');
dispatch_post('/infomessage', 'info_message_read');
dispatch('/login', 'login');
dispatch('/login_google', 'login_google');
dispatch_post('/login', 'login_post');
dispatch('/logout', 'logout');
dispatch('/register', 'register');
dispatch_post('/register', 'register_post');
dispatch('/reset', 'reset_password');
dispatch_post('/reset', 'reset_password_post');

dispatch('/admin/infomessage/overview', 'info_message_overview');
dispatch('/admin/infomessage/create', 'create_info_message');
dispatch('/admin/infomessage/edit', 'edit_info_message');
dispatch_post('/admin/infomessage/create', 'info_message_post');

dispatch('/admin/round', 'round_overview');
dispatch('/admin/round/create', 'create_round');
dispatch_post('/admin/round/confirm', 'start_round_confirmation');
dispatch_post('/admin/round/start', 'start_round');
dispatch('/admin/round/edit', 'edit_round');
dispatch_post('/admin/round/edit', 'edit_round_post');
dispatch('/admin/round/end', 'end_round_confirmation');
dispatch_post('/admin/round/end', 'end_round');

dispatch('/admin/departments', 'view_departments');
dispatch('/admin/department/create', 'create_department');
dispatch_post('/admin/department/:id', 'create_department_post');
dispatch('/admin/department/delete/:id', 'delete_department_confirmation');
dispatch_delete('/admin/department/:id', 'delete_department');
dispatch('/admin/department/:id', 'edit_department');

dispatch('/admin/users', 'view_users');
dispatch('/admin/user/create', 'create_user');
dispatch_post('/admin/user/status', 'edit_status');
dispatch_post('/admin/user/:id', 'create_user_post');
dispatch('/admin/user/delete/:id', 'delete_user_confirmation');
dispatch_delete('/admin/user/:id', 'delete_user');
dispatch('/admin/user/:id', 'edit_user');

dispatch('/manager/roles', 'view_roles');
dispatch('/manager/role/create', 'create_role');
dispatch_post('/manager/role/:id', 'create_role_post');
dispatch('/manager/role/delete/:id', 'delete_role_confirmation');
dispatch_delete('/manager/role/:id', 'delete_role');
dispatch('/manager/role/:id', 'edit_role');

dispatch('/manager/competencygroup/create', 'create_competencygroup');
dispatch_post('/manager/competencygroup/:id', 'create_competencygroup_post');
dispatch('/manager/competencygroup/:id', 'edit_competencygroup');
dispatch('/manager/competencygroup/delete/:id', 'delete_competencygroup_confirmation');
dispatch_delete('/manager/competencygroup/:id', 'delete_competencygroup');

dispatch('/manager/competencies', 'view_competencies');
dispatch('/manager/competency/create', 'create_competency');
dispatch_post('/manager/competency/:id', 'create_competency_post');
dispatch('/manager/competency/delete/:id', 'delete_competency_confirmation');
dispatch_delete('/manager/competency/:id', 'delete_competency');
dispatch('/manager/competency/:id', 'edit_competency');

dispatch('/feedback', 'view_feedback_overview');
dispatch_post('/feedback/skip/add', 'add_to_reviewees');
dispatch('/feedback/skip/:id', 'skip_confirmation');
dispatch_post('/feedback/skip', 'skip_person');
dispatch('/feedback/edit/:id', 'edit_feedback');
dispatch_post('/feedback/edit/:id', 'edit_feedback_post');
dispatch('/feedback/:id', 'feedback_step_1');
dispatch_post('/feedback/:id', 'feedback_step_1_post');
dispatch('/feedback/:id/2', 'feedback_step_2');
dispatch_post('/feedback/:id/2', 'feedback_step_2_post');
dispatch('/feedback/:id/3', 'feedback_step_3');
dispatch_post('/feedback/:id/3', 'feedback_step_3_post');

dispatch('/report/overview/:user_id', 'report_overview');
dispatch('/report/:round_id/:user_id', 'view_report');

dispatch('/profile', 'edit_profile');
dispatch_post('/profile', 'edit_profile_post');

run();
R::close();

/* limonade error handling */
function not_found($errno, $errstr, $errfile=null, $errline=null, $errcontext=null) {
    global $smarty;

    if(has_error()) {
        return server_error($errno, $errstr, $errfile, $errline, $errcontext);
    }

    return html($smarty->fetch('error/404.tpl'), error_layout());
}
function server_error($errno, $errstr, $errfile=null, $errline=null, $errcontext=null) {
    global $smarty;

    mail_error();

    return html($smarty->fetch('error/500.tpl'), error_layout());
}
