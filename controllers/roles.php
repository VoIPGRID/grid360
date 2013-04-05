<?php
/**
 * @author epasagic
 * @date 22-3-13
 */

function create_role()
{
    $departments = R::$adapter->getAssoc('select id, name from department');

    global $smarty;
    $smarty->assign('departmentOptions', $departments);
    $smarty->display('roles/new_role.tpl');
}

function view_roles()
{
    global $smarty;
    $roles = R::findAll('role');
    $smarty->assign('roles', $roles);
    $smarty->display('roles/roles.tpl');
}

function edit_role()
{
    $role = R::load('role', params('id'));

    if($role->id == 0)
        return 'Role not found!';

    $departments = R::$adapter->getAssoc('select id, name from department');

    global $smarty;
    $smarty->assign('departmentOptions', $departments);
    $smarty->assign('role', $role);
    $smarty->display('roles/edit_role.tpl');
}

function delete_role()
{
    $role = R::load('role', params('id'));

    if($role->id == 0)
        return 'Role not found!';

    R::trash($role);
}

function create_role_post()
{
    $role = R::graph($_POST);
    R::store($role);

    global $smarty;
}