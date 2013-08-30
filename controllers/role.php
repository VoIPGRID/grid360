<?php

function create_role()
{
    security_authorize(MANAGER);

    $departments = get_departments_assoc();
    $competencygroups = get_competencygroups_assoc();

    global $smarty;
    $smarty->assign('department_options', $departments);
    $smarty->assign('competencygroup_options', $competencygroups);

    return html($smarty->fetch('role/role.tpl'));
}

function create_role_post()
{
    security_authorize(MANAGER);

    $keys_to_check = array
    (
        'name' => $_POST['name'],
        'department' => array
        (
            'load_bean' => true,
            'id' => $_POST['department']['id'],
            'type' => 'department'
        ),
        'competencygroup' => array
        (
            'load_bean' => true,
            'id' => $_POST['competencygroup']['id'],
            'type' => 'competencygroup'
        )
    );

    $id = params('id');

    if(!empty($id))
    {
        $_POST['id'] = $id;
        $keys_to_check['id'] = array
        (
            'load_bean' => true,
            'id' => $_POST['id'],
            'type' => 'role'
        );
    }

    $form_values = validate_form($keys_to_check);

    $form_values['description']['value'] = $_POST['description'];

    global $smarty;

    $has_errors = false;
    foreach($form_values as $form_value)
    {
        if(isset($form_value['error']))
        {
            $has_errors = true;
            break;
        }
    }

    // Set the form values so they can be used again in the form
    if($has_errors || isset($form_values['error']))
    {
        $smarty->assign('form_values', $form_values);

        if(isset($_POST['id']))
        {
            return edit_role();
        }

        return create_role();
    }

    $role = R::graph($_POST);

    // Check if the role is a new role
    if($role->id != 0)
    {
        $message = sprintf(UPDATE_SUCCESS, _('role'), $role->name);
    }
    else
    {
        $message = sprintf(CREATE_SUCCESS, _('role'), $role->name);
    }

    R::store($role);

    flash('success', $message);
    redirect_to(MANAGER_URI . 'roles');
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
        $roles = R::find('role', 'department_id = ?', array($_SESSION['current_user']->department_id));
    }

    $smarty->assign('roles', $roles);
    $smarty->assign('page_header', _('Roles'));

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
        $role = R::findOne('role', 'department_id = ? AND id = ?', array($_SESSION['current_user']->department_id, params('id')));
    }

    if($role->id == 0)
    {
        $message = sprintf(BEAN_NOT_FOUND, _('role'));
        flash('error', $message);
        redirect_to(MANAGER_URI . 'roles');
    }

    $departments = get_departments_assoc();
    $competencygroups = get_competencygroups_assoc();

    global $smarty;

    if(!$smarty->getTemplateVars('form_values'))
    {
        $form_values = array();
        $form_values['id']['value'] = $role->id;
        $form_values['name']['value'] = $role->name;
        $form_values['description']['value'] = $role->description;
        $form_values['department']['value'] = $role->department_id;
        $form_values['competencygroup']['value'] = $role->competencygroup_id;

        $smarty->assign('form_values', $form_values);
    }

    $smarty->assign('role_name', $role->name);
    $smarty->assign('department_options', $departments);
    $smarty->assign('competencygroup_options', $competencygroups);
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
        $role = R::findOne('role', 'department_id = ? AND id = ?', array($_SESSION['current_user']->department_id, params('id')));
    }

    if($role->id == 0)
    {
        $message = sprintf(BEAN_NOT_FOUND, _('role'));
        flash('error', $message);
        redirect_to(MANAGER_URI . 'roles');
    }

    global $smarty;
    $smarty->assign('type', _('role'));
    $smarty->assign('type_var', 'role');
    $smarty->assign('role', $role);
    $smarty->assign('level_uri', MANAGER_URI);
    $smarty->assign('delete_uri', BASE_URI . MANAGER_URI . 'roles');

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
        $role = R::findOne('role', 'department_id = ? AND id = ?', array($_SESSION['current_user']->department_id, params('id')));
    }

    if($role->id == 0)
    {
        $message = sprintf(BEAN_NOT_FOUND, _('role'));
        flash('error', $message);
        redirect_to(MANAGER_URI . 'roles');
    }

    R::trash($role);

    $message = sprintf(DELETE_SUCCESS, _('role'), $role->name);
    flash('success', $message);
    redirect_to(MANAGER_URI . 'roles');
}

function get_departments_assoc()
{
    $departments = R::$adapter->getAssoc('SELECT id, name FROM department WHERE tenant_id = ?', array($_SESSION['current_user']->tenant_id));

    return $departments;
}

function get_competencygroups_assoc()
{
    $competencygroups = R::$adapter->getAssoc('SELECT id, name FROM competencygroup WHERE general != 1 AND tenant_id = ?', array($_SESSION['current_user']->tenant_id));

    return $competencygroups;
}
