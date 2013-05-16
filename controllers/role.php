<?php

function create_role()
{
    security_authorize(MANAGER);

    $departments = R::$adapter->getAssoc('select id, name from department');
    $competencygroups = R::$adapter->getAssoc('select id, name from competencygroup where general != 1');

    global $smarty;
    $smarty->assign('department_options', $departments);
    $smarty->assign('competencygroup_options', $competencygroups);

    return html($smarty->fetch('role/role.tpl'));
}

function create_role_post()
{
    security_authorize(MANAGER);

    $role = R::graph($_POST);
    R::store($role);

    global $smarty;

    if(isset($_POST['id']))
    {
        return html('Role with id ' . $_POST['id'] . ' updated! <a href="' . MANAGER_URI . 'roles">Return to roles</a>');
    }

    return html('Role created! <a href="' . MANAGER_URI . 'roles">Return to roles</a>');
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
        return html('Role not found! <a href="' . MANAGER_URI . 'roles">Return to roles</a>');
    }

    $departments = R::$adapter->getAssoc('select id, name from department');
    $competencygroups = R::$adapter->getAssoc('select id, name from competencygroup where general != 1');

    global $smarty;
    $smarty->assign('department_options', $departments);
    $smarty->assign('competencygroup_options', $competencygroups);
    $smarty->assign('role', $role);
    $smarty->assign('update', true);

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
