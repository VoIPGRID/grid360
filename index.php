<?php
/**
 * @author epasagic
 * @date 21-3-13
 */

require_once('config.php');
require_once(LIB_DIR . 'limonade/lib/limonade.php');
require_once(LIB_DIR . 'redbeanphp/rb.php');
require_once(LIB_DIR . 'smarty/libs/Smarty.class.php');
include_once(VIEWS_DIR . 'menu.php');

function configure()
{
    option('base_uri', '/grid360/');  # '/' or same as the RewriteBase or ENV:FRB in your .htaccess
    option('public_dir', 'public/');
    option('views_dir', 'views/');
    option('controllers_dir', 'controllers/');

    global $smarty;
    $smarty->assign('base_uri', option('base_uri'));
    $smarty->assign('admin_uri', option('base_uri') . "admin");
    $smarty->assign('manager_uri', option('base_uri') . "manager");
}

R::setup(CONNECTION, USERNAME, PASSWORD);

$smarty = new Smarty();
$smarty->setTemplateDir('views/');
$smarty->setCompileDir('views/templates_c');

$currentUser = R::load('user', 1);
$smarty->assign('currentUser', $currentUser);

session_start();

dispatch('/', 'dashboard');

dispatch_post('/admin/reset', 'fill_database');
dispatch('/admin/reset', 'confirmation');

dispatch('/admin/departments', 'view_departments');
dispatch('/admin/department/create', 'create_department');
dispatch_post('/admin/department/submit', 'create_department_post');
dispatch_delete('/admin/department/:id', 'delete_department');
dispatch('/admin/department/:id', 'edit_department');

dispatch('/admin/users', 'view_users');
dispatch('/admin/user/create', 'create_user');
dispatch_post('/admin/user/submit', 'create_user_post');
dispatch_delete('/admin/user/:id', 'delete_user');
dispatch('/admin/user/:id', 'edit_user');

dispatch('/manager/roles', 'view_roles');
dispatch('/manager/role/create', 'create_role');
dispatch_post('/manager/role/submit', 'create_role_post');
dispatch_delete('/manager/role/:id', 'delete_role');
dispatch('/manager/role/:id', 'edit_role');

dispatch('/manager/competencygroup/create', 'create_competencygroup');
dispatch_post('/manager/competencygroup/submit', 'create_competencygroup_post');
dispatch('/manager/competencygroup/:id', 'edit_competencygroup');
dispatch_delete('/manager/competencygroup/:id', 'delete_competencyGroup');

dispatch('/manager/competencies', 'view_competencies');
dispatch('/manager/competency/create', 'create_competency');
dispatch_post('/manager/competency/submit', 'create_competency_post');
dispatch_delete('/manager/competency/:id', 'delete_competency');
dispatch('/manager/competency/:id', 'edit_competency');

dispatch('/feedback', 'feedback_step_1');
dispatch_post('/feedback', 'feedback_step_1_post');
dispatch('/feedback/2', 'feedback_step_2');
dispatch_post('/feedback/2', 'feedback_step_2_post');
dispatch('/feedback/3', 'feedback_step_3');
dispatch_post('/feedback/3', 'feedback_step_3_post');
dispatch('/report', 'view_report');

function dashboard()
{
    $users = R::findAll('user');
    global $smarty;
    $smarty->assign('users', $users); // For now just display the users, will be changed to display round data
    $smarty->display('dashboard.tpl');
}

run();