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

    if(!isset($_POST['type']) || $_POST['type'] != 'role')
    {
        return html('Error creating role!');
    }

    if(isset($_POST['name']) && strlen(trim($_POST['name'])) > 0)
    {
        $role = R::graph($_POST);

        R::store($role);

        global $smarty;

        if(isset($_POST['id']))
        {
            return html('Role with id ' . $_POST['id'] . ' updated! <a href="' . MANAGER_URI . 'roles">Return to roles</a>');
        }

        return html('Role created! <a href="' . MANAGER_URI . 'roles">Return to roles</a>');
    }
    else
    {
        $form_values = array();
        $form_values['name']['error'] = 'Name is required';

        global $smarty;
        $smarty->assign('form_values', $form_values);

        $id = params('id');

        if(isset($id) && !empty($id))
        {
            $smarty->assign('role', R::load('role', params('id')));
            $smarty->assign('update', true);
        }

        return create_role();
    }
}

function view_roles()
{
    security_authorize(MANAGER);

    global $smarty;

    if($_SESSION['current_user']->userlevel->level == ADMIN)
    {
        $roles = R::findAll('role');
    }
    else
    {
        $roles = R::find('role', 'department_id = ?', array($_SESSION['current_user']->department->id));
    }
    $smarty->assign('roles', $roles);
    $smarty->assign('page_header', 'Roles');

    return html($smarty->fetch('role/roles.tpl'));
}

function edit_role()
{
    security_authorize(MANAGER);

    if($_SESSION['current_user']->userlevel->level == ADMIN)
    {
        $role = R::load('role', params('id'));
    }
    else
    {
        $role = R::findOne('role', 'department_id = ? AND id = ?', array($_SESSION['current_user']->department->id, params('id')));
    }

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

function delete_role_confirmation()
{
    security_authorize(MANAGER);

    if($_SESSION['current_user']->userlevel->level == ADMIN)
    {
        $role = R::load('role', params('id'));
    }
    else
    {
        $role = R::findOne('role', 'department_id = ? AND id = ?', array($_SESSION['current_user']->department->id, params('id')));
    }

    if($role->id == 0)
    {
        return html('Role not found!');
    }

    global $smarty;
    $smarty->assign('type', 'role');
    $smarty->assign('role', $role);
    $smarty->assign('level_uri', MANAGER_URI);

    return html($smarty->fetch('common/delete_confirmation.tpl'));
}

function delete_role()
{
    security_authorize(MANAGER);

    if($_SESSION['current_user']->userlevel->level == ADMIN)
    {
        $role = R::load('role', params('id'));
    }
    else
    {
        $role = R::findOne('role', 'department_id = ? AND id = ?', array($_SESSION['current_user']->department->id, params('id')));
    }

    if($role->id == 0)
    {
        return html('Role not found!');
    }

    R::trash($role);

    return html('Role deleted! <a href="' . MANAGER_URI . 'roles">Return to roles</a>');
}
