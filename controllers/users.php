<?php
/**
 * @author epasagic
 * @date 21-3-13
 */

function create_user()
{
    $departments = array(0 => "----------");
    $departments += R::$adapter->getAssoc('select id, name from department');

    $roles = array(0 => "----------");
    $roles += R::$adapter->getAssoc('select id, name from role');

    $userLevels = R::$adapter->getAssoc('select id, name from userlevel');

    global $smarty;
    $smarty->assign('depOptions', $departments);
    $smarty->assign('roleOptions', $roles);
    $smarty->assign('userLevelOptions', $userLevels);

    $smarty->display('users/new_user.tpl');
}

function view_users()
{
    global $smarty;
    $users = R::findAll('user');
    $smarty->assign('users', $users);
    $smarty->display('users/users.tpl');
}

function edit_user()
{
    $user = R::load('user', params('id'));

    if($user->id == 0)
        return 'User not found!';

    $departments = array(0 => "----------");
    $departments += R::$adapter->getAssoc('select id, name from department');

    $roles = array(0 => "----------");
    $roles += R::$adapter->getAssoc('select id, name from role');

    $userLevels = R::$adapter->getAssoc('select id, name from userlevel');

    global $smarty;
    $smarty->assign('depOptions', $departments);
    $smarty->assign('roleOptions', $roles);
    $smarty->assign('userLevelOptions', $userLevels);
    $smarty->assign('user', $user);
    $smarty->display('users/edit_user.tpl');
}

function delete_user()
{
    $user = R::load('user', params('id'));

    if($user->id == 0)
        return 'User not found!';

    R::trash($user);
}

function create_user_post()
{
    $user = R::graph($_POST);
    R::store($user);

    global $smarty;

    $smarty->assign('name', $user->firstname . " " . $user->lastname);
    $smarty->assign('email', $user->email);
    $smarty->assign('department', $user->department->name);
    $smarty->assign('role', $user->role->name);

    $smarty->display('users/submit.tpl');
}