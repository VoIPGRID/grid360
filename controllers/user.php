<?php

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

    if((!isset($_POST['firstname']) || empty($_POST['firstname'])) && (!isset($_POST['lastname']) || empty($_POST['lastname'])))
    {
        return html('Not all fields were filled in!');
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

    $user->status = 0;

    if($user->id == 0)
    {
        $user->created = R::isoDateTime();
    }

    R::store($user);

    global $smarty;

    $smarty->assign('name', $user->firstname . ' ' . $user->lastname);
    $smarty->assign('email', $user->email);
    $smarty->assign('department', $user->department->name);
    $smarty->assign('role', $user->role->name);

    return html($smarty->fetch('user/submit.tpl'));
}

function view_users()
{
    security_authorize(ADMIN);

    global $smarty;
    $users = R::findAll('user');
    $smarty->assign('users', $users);
    $smarty->assign('page_title', 'Users');
    set('title', 'Users');

    return html($smarty->fetch('user/users.tpl'));
}

function edit_user()
{
    security_authorize(ADMIN);

    $user = R::load('user', params('id'));

    if($user->id == 0)
    {
        return html('User not found!');
    }

    global $smarty;
    $smarty->assign('departments', R::findAll('department'));
    $smarty->assign('roles', R::findAll('role'));
    $smarty->assign('userlevel_options', get_userlevels());
    $smarty->assign('user', $user);
    $smarty->assign('update', true);
    set('title', 'Edit user');

    return html($smarty->fetch('user/user.tpl'));
}

function edit_status()
{
    security_authorize(ADMIN);

    $user = R::load('user', $_POST['id']);

    if($user->id == 0)
    {
        return html('User not found!');
    }

    $user->status = $_POST['status'];

    R::store($user);
}

function delete_user()
{
    security_authorize(ADMIN);

    $user = R::load('user', params('id'));

    if($user->id == 0)
    {
        return html('User not found!');
    }

    R::trash($user);

    return html('User deleted <a href="' . ADMIN_URI . 'users">Return to users</a>');
}
