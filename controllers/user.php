<?php

const INVALID_DEPARTMENT = 'Invalid department given!';
const ROLE_DEPARTMENT_MISMATCH = 'Chosen role does not belong to the chosen department!';

function create_user()
{
    security_authorize(ADMIN);

    global $smarty;
    $smarty->assign('departments', R::findAll('department'));
    $smarty->assign('roles', R::findAll('role'));
    $smarty->assign('userlevel_options', get_userlevels());
    set('title', 'Create user');

    return html($smarty->fetch('user/user.tpl'));
}

function create_user_post()
{
    security_authorize(ADMIN);

    $keys_to_check = array
    (
        'firstname' => $_POST['firstname'],
        'lastname' => $_POST['lastname'],
        'email' => $_POST['email'],
        'department' => array
        (
            'load_bean' => true,
            'id' => $_POST['department']['id'],
            'type' => 'department'
        ),
        'role' => array
        (
            'load_bean' => true,
            'id' => $_POST['role']['id'],
            'type' => 'role'
        ),
        'userlevel' => array
        (
            'load_bean' => true,
            'id' => $_POST['userlevel']['id'],
            'type' => 'userlevel'
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
            'type' => 'user'
        );
    }

    $form_values = validate_form($keys_to_check);

    global $smarty;

    foreach($form_values as $form_value)
    {
        if(isset($form_value['error']))
        {
            $smarty->assign('form_values', $form_values);

            if(isset($_POST['id']))
            {
                return edit_user();
            }

            return create_user();
        }
    }

    $user = R::graph($_POST);

    if($user->department->id == 0)
    {
        unset($user->department);
    }

    if($user->role->id == 0)
    {
        unset($user->role);
    }

    // Check if it's a new user
    if($user->id == 0)
    {
        $hasher = new PasswordHash(8, false);
        $random_password = rand_string(10);

        $user->password = $hasher->HashPassword($random_password);
        $user->status = 0;
        $user->created = R::isoDateTime();
        $message = sprintf(CREATE_SUCCESS, 'user', $user->firstname . ' ' . $user->lastname);

//        send_mail('Your ' . APP_NAME . ' account' , 'admin@grid360.nl', $user->email,
//            'Dear ' . $user->firstname . ' ' . $user->lastname . ", \n\n" .  ' you can now log in with: ' . "\nEmail: " . $user->email . "\nPassword: " . $random_password);
    }
    else
    {
        $message = sprintf(UPDATE_SUCCESS, 'user', $user->firstname . ' ' . $user->lastname);
    }

    R::store($user);

    flash('success', $message);
    redirect_to(ADMIN_URI . 'users');
}

function view_users()
{
    security_authorize(ADMIN);

    global $smarty;
    $users = R::findAll('user', 'ORDER BY department_id');
    $smarty->assign('users', $users);
    $smarty->assign('page_header', _('Users'));
    set('title', _('Users'));

    return html($smarty->fetch('user/users.tpl'));
}

function edit_user()
{
    security_authorize(ADMIN);

    $user = R::load('user', params('id'));

    if($user->id == 0)
    {
        $message = sprintf(BEAN_NOT_FOUND, _('user'));
        flash('error', $message);
        redirect_to(ADMIN_URI . 'users');
    }

    global $smarty;

    if(!$smarty->getTemplateVars('form_values'))
    {
        $form_values = array();
        $form_values['id']['value'] = $user->id;
        $form_values['firstname']['value'] = $user->firstname;
        $form_values['lastname']['value'] = $user->lastname;
        $form_values['email']['value'] = $user->email;
        $form_values['department']['value'] = $user->department_id;
        $form_values['role']['value'] = $user->role_id;
        $form_values['userlevel']['value'] = $user->userlevel->level;

        $smarty->assign('form_values', $form_values);
    }

    $smarty->assign('user_name', $user->firstname . ' ' . $user->lastname);
    $smarty->assign('departments', R::findAll('department'));
    $smarty->assign('roles', R::findAll('role'));
    $smarty->assign('userlevel_options', get_userlevels());
    $smarty->assign('update', true);
    set('title', _('Edit user'));

    return html($smarty->fetch('user/user.tpl'));
}

function edit_status()
{
    security_authorize(ADMIN);

    $user = R::load('user', $_POST['id']);

    if($user->id == 0)
    {
        $message = sprintf(BEAN_NOT_FOUND, _('user'));
        flash('error', $message);
        redirect_to(ADMIN_URI . 'users');
    }

    $user->status = $_POST['status'];

    R::store($user);
}

function delete_user_confirmation()
{
    security_authorize(ADMIN);

    $user = R::load('user', params('id'));

    if($user->id == 0)
    {
        $message = sprintf(BEAN_NOT_FOUND, _('user'));
        flash('error', $message);
        redirect_to(ADMIN_URI . 'users');
    }

    global $smarty;
    $smarty->assign('type', _('user'));
    $smarty->assign('type_var', 'user');
    $smarty->assign('user', $user);
    $smarty->assign('level_uri', ADMIN_URI);

    return html($smarty->fetch('common/delete_confirmation.tpl'));
}

function delete_user()
{
    security_authorize(ADMIN);

    $user = R::load('user', params('id'));

    if($user->id == 0)
    {
        $message = sprintf(BEAN_NOT_FOUND, _('user'));
        flash('error', $message);
        redirect_to(ADMIN_URI . 'users');
    }

    R::trash($user);

    $message = sprintf(DELETE_SUCCESS, 'user', $user->firstname . ' ' . $user->lastname);
    flash('success', $message);
    redirect_to(ADMIN_URI . 'users');
}
