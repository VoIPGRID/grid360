<?php

function create_department()
{
    security_authorize(ADMIN);

    global $smarty;
    $smarty->assign('manager_options', get_managers());

    return html($smarty->fetch('department/department.tpl'));
}

function create_department_post()
{
    security_authorize(ADMIN);

    foreach($_POST['ownRole'] as $id => $role)
    {
        // If the role name is empty, remove role from the list so you don't get an empty role in the database
        if(strlen(trim($role['name'])) == 0)
        {
            unset($_POST['ownRole'][$id]);
        }
    }

    $keys_to_check = array
    (
        'name' => $_POST['name'],
        'user' => array
        (
            'load_bean' => true,
            'id' => $_POST['user']['id'],
            'type' => 'user'
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
            'type' => 'department'
        );
    }

    $form_values = validate_form($keys_to_check);

    $form_values['roles']['value'] = $_POST['ownRole'];

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
            return edit_department();
        }

        return create_department();
    }

    $department = R::graph($_POST);

    // Check if the department is a new department
    if($department->id != 0)
    {
        $message = sprintf(UPDATE_SUCCESS, _('department'), $department->name);
    }
    else
    {
        $department->created = R::isoDateTime();
        $message = sprintf(CREATE_SUCCESS, _('department'), $department->name);
    }

    R::store($department);

    flash('success', $message);
    redirect_to(ADMIN_URI . 'departments');
}

function view_departments()
{
    security_authorize(ADMIN);

    global $smarty;
    $departments = R::findAll('department');
    $smarty->assign('departments', $departments);
    $smarty->assign('page_header', _('Departments'));
    set('title', _('Departments'));

    return html($smarty->fetch('department/departments.tpl'));
}

function edit_department()
{
    security_authorize(ADMIN);

    $department = R::load('department', params('id'));

    if($department->id == 0)
    {
        $message = sprintf(BEAN_NOT_FOUND, _('department'));
        flash('error', $message);
        redirect_to(ADMIN_URI . 'departments');
    }

    global $smarty;

    if(!$smarty->getTemplateVars('form_values'))
    {
        $form_values = array();
        $form_values['id']['value'] = $department->id;
        $form_values['name']['value'] = $department->name;
        $form_values['user']['value'] = $department->user_id;
        $form_values['roles']['value'] = $department->ownRole;

        $smarty->assign('form_values', $form_values);
    }

    $smarty->assign('department_name', $department->name);
    $smarty->assign('manager_options', get_managers());
    $smarty->assign('update', true);

    return html($smarty->fetch('department/department.tpl'));
}

function delete_department_confirmation()
{
    security_authorize(ADMIN);

    $department = R::load('department', params('id'));

    if($department->id == 0)
    {
        $message = sprintf(BEAN_NOT_FOUND, _('department'));
        flash('error', $message);
        redirect_to(ADMIN_URI . 'departments');
    }

    global $smarty;
    $smarty->assign('type', _('department'));
    $smarty->assign('type_var', 'department');
    $smarty->assign('department', $department);
    $smarty->assign('name', $department->name);
    $smarty->assign('level_uri', ADMIN_URI);

    return html($smarty->fetch('common/delete_confirmation.tpl'));
}

function delete_department()
{
    security_authorize(ADMIN);

    $department = R::load('department', params('id'));

    if($department->id == 0)
    {
        $message = sprintf(BEAN_NOT_FOUND, _('department'));
        flash('error', $message);
        redirect_to(ADMIN_URI . 'departments');
    }

    R::trash($department);

    $message = sprintf(DELETE_SUCCESS, _('department'), $department->name);
    flash('success', $message);
    redirect_to(ADMIN_URI . 'departments');
}

function get_managers()
{
    $levels = array(ADMIN, MANAGER);

    $managers = R::$adapter->getAssoc('SELECT user.id, CONCAT(firstname, " ", lastname) as name
                                       FROM user
                                       LEFT JOIN userlevel
                                       ON userlevel.id = user.userlevel_id
                                       WHERE userlevel.level IN (' . R::genSlots($levels) . ')
                                       AND user.tenant_id = ' . $_SESSION['current_user']->tenant_id, $levels);

    return $managers;
}