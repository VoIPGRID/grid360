<?php

function create_role()
{
    security_authorize();

    $departments = R::$adapter->getAssoc('select id, name from department');

    global $smarty;
    $smarty->assign('department_options', $departments);

    return html($smarty->fetch('roles/role.tpl'));
}

function create_role_post()
{
    security_authorize();

    $role = R::graph($_POST);
    R::store($role);

    global $smarty;
}

function view_roles()
{
    security_authorize();

    global $smarty;
    $roles = R::findAll('role');
    $smarty->assign('roles', $roles);
    $smarty->assign('page_title', 'Roles');

    return html($smarty->fetch('roles/roles.tpl'));
}

function edit_role()
{
    security_authorize();

    $role = R::load('role', params('id'));

    if($role->id == 0)
    {
        return html('Role not found!');
    }

    $departments = R::$adapter->getAssoc('select id, name from department');

    global $smarty;
    $smarty->assign('department_options', $departments);
    $smarty->assign('role', $role);

    return html($smarty->fetch('roles/role.tpl'));
}

function delete_role()
{
    security_authorize();

    $role = R::load('role', params('id'));

    if($role->id == 0)
    {
        return html('Role not found!');
    }

    R::trash($role);

    return html('Role deleted! <a href="' . MANAGER_URI . 'roles">Return to roles</a>');
}
