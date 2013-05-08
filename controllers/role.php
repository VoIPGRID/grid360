<?php

function create_role()
{
    security_authorize(MANAGER);

    $departments = R::$adapter->getAssoc('select id, name from department');

    global $smarty;
    $smarty->assign('department_options', $departments);

    return html($smarty->fetch('role/role.tpl'));
}

function create_role_post()
{
    security_authorize(MANAGER);

    $role = R::graph($_POST);
    R::store($role);

    global $smarty;
}

function view_roles()
{
    security_authorize(MANAGER);

    global $smarty;
    $roles = R::findAll('role');
    $smarty->assign('roles', $roles);
    $smarty->assign('page_title', 'Roles');

    return html($smarty->fetch('role/roles.tpl'));
}

function edit_role()
{
    security_authorize(MANAGER);

    $role = R::load('role', params('id'));

    if($role->id == 0)
    {
        return html('Role not found!');
    }

    $departments = R::$adapter->getAssoc('select id, name from department');

    global $smarty;
    $smarty->assign('department_options', $departments);
    $smarty->assign('role', $role);

    return html($smarty->fetch('role/role.tpl'));
}

function delete_role()
{
    security_authorize(MANAGER);

    $role = R::load('role', params('id'));

    if($role->id == 0)
    {
        return html('Role not found!');
    }

    R::trash($role);

    return html('Role deleted! <a href="' . MANAGER_URI . 'roles">Return to roles</a>');
}
