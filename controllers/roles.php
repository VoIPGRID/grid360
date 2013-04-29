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

    return html($smarty->fetch('roles/role.tpl'));
}

function create_role_post()
{
    $role = R::graph($_POST);
    R::store($role);

    global $smarty;
}

function view_roles()
{
    global $smarty;
    $roles = R::findAll('role');
    $smarty->assign('roles', $roles);
    $smarty->assign('pageTitle', 'Roles');
    $smarty->assign('pageTitleSize', 'h1');

    return html($smarty->fetch('roles/roles.tpl'));
}

function edit_role()
{
    $role = R::load('role', params('id'));

    if($role->id == 0)
        return html('Role not found!');

    $departments = R::$adapter->getAssoc('select id, name from department');

    global $smarty;
    $smarty->assign('departmentOptions', $departments);
    $smarty->assign('role', $role);

    return html($smarty->fetch('roles/role.tpl'));
}

function delete_role()
{
    $role = R::load('role', params('id'));

    if($role->id == 0)
        return html('Role not found!');

    R::trash($role);
}
