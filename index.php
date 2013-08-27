<?php

require_once('config.php');
require_once(LIB_DIR . 'limonade/lib/limonade.php');
require_once(LIB_DIR . 'redbeanphp/rb.php');
require_once(LIB_DIR . 'smarty/libs/Smarty.class.php');
require_once(LIB_DIR . 'multitenancy_writer.php');
require_once(LIB_DIR . 'phpass-0.3/PasswordHash.php');
include_once(LIB_DIR . 'sacy/sacy.php');
require_once('constants.php');

function configure()
{
    option('base_uri', BASE_URI);  # '/' or same as the RewriteBase or ENV:FRB in your .htaccess
    option('views_dir', 'views/');
    option('controllers_dir', 'controllers/');
    error_layout('layout/basic.php');

    RedBean_Plugin_Cooker::enableBeanLoading(true);
}

function before()
{
    global $smarty;
    $smarty->assign('current_user', $_SESSION['current_user']);
    $smarty->assign('locale', strtolower(substr(getenv('LANG'), 0, 2)));

    layout('layout/layout.php');
}

R::setup(CONNECTION, DB_USERNAME, DB_PASSWORD);

$writer = new Multitenancy_QueryWriter_MySQL(R::$adapter);
R::configureFacadeWithToolbox(new RedBean_ToolBox(new RedBean_OODB($writer), R::$adapter, $writer));

R::freeze(true);
//R::debug(true);

$smarty = new Smarty();
$smarty->setTemplateDir('views/');
$smarty->setCompileDir('views/templates_c');
$smarty->escape_html = true;

dispatch('/', 'dashboard');
dispatch('/login', 'login');
dispatch('/login_google', 'login_google');
dispatch_post('/login', 'login_post');
dispatch('/logout', 'logout');
dispatch('/register', 'register');
dispatch_post('/register', 'register_post');
dispatch('/reset', 'reset_password');
dispatch_post('/reset', 'reset_password_post');

dispatch('/admin/round', 'round_overview');
dispatch('/admin/round/create', 'create_round');
dispatch_post('/admin/round/confirm', 'start_round_confirmation');
dispatch_post('/admin/round/start', 'start_round');
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

try
{
    run();
    R::close();
}
catch(Exception $e)
{
    R::close();

    // Passing the exception object to halt() because it only accepts 1 other parameter (besides the error code), so that the correct error file and line is used
    halt(SERVER_ERROR, $e);
}

function not_found()
{
    global $smarty;

    return html($smarty->fetch('error/404.tpl'), 'layout/basic.php');
}

function server_error($errno, $exception, $errfile, $errline)
{
    global $smarty;

    $smarty->assign('error_number', $errno);
    $smarty->assign('error_string', $exception->getTraceAsString());
    $smarty->assign('error_file', $exception->getFile());
    $smarty->assign('error_line', $exception->getLine());

    $subject = 'Server error in ' . $exception->getFile() . ' on line ' . $exception->getLine();
    $body = $smarty->fetch('email/server_error.tpl');

    send_mail($subject, ADMIN_EMAIL, ADMIN_EMAIL, $body);

    global $smarty;

    return html($smarty->fetch('error/500.tpl'), 'layout/basic.php');
}
