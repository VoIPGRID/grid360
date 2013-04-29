<?php
/**
 * @author epasagic
 * @date 21-3-13
 */

function create_user()
{
    $userLevels = R::$adapter->getAssoc('select id, name from userlevel');

    global $smarty;
    $smarty->assign('departments', R::findAll('department'));
    $smarty->assign('roles', R::findAll('role'));
    $smarty->assign('userLevelOptions', $userLevels);
    set('title', 'Create user');

    return html($smarty->fetch('users/user.tpl'));
}

function create_user_post()
{
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

    R::store($user);

    global $smarty;

    $smarty->assign('name', $user->firstname . ' ' . $user->lastname);
    $smarty->assign('email', $user->email);
    $smarty->assign('department', $user->department->name);
    $smarty->assign('role', $user->role->name);

    return html($smarty->fetch('users/submit.tpl'));
}

function view_users()
{
    global $smarty;
    $users = R::findAll('user');
    $smarty->assign('users', $users);
    $smarty->assign('pageTitle', 'Users');
    $smarty->assign('pageTitleSize', 'h1');
    set('title', 'Users');

    return html($smarty->fetch('users/users.tpl'));
}

function edit_user()
{
    $user = R::load('user', params('id'));

    if($user->id == 0)
        return html('User not found!');

    $userLevels = R::$adapter->getAssoc('select id, name from userlevel');

    global $smarty;
    $smarty->assign('departments', R::findAll('department'));
    $smarty->assign('roles', R::findAll('role'));
    $smarty->assign('userLevelOptions', $userLevels);
    $smarty->assign('user', $user);
    $smarty->assign('update', 1);
    set('title', 'Edit user');

    return html($smarty->fetch('users/user.tpl'));
}

function delete_user()
{
    $user = R::load('user', params('id'));

    if($user->id == 0)
        return html('User not found!');

    R::trash($user);

    return html('User deleted');
}

function edit_status()
{
    $user = R::load('user', $_POST['id']);
    $user->status = $_POST['status'];

    R::store($user);

    return 'Status updated!';
}
