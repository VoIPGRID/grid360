<?php

function security_authorize($required_level = EMPLOYEE)
{
    if($required_level !== ANONYMOUS)
    {
        if($_SESSION['current_user'] == null)
        {
            layout('security/login.tpl');
            header('Location: ' . BASE_URI . 'login');
            exit;
        }
        else if(isset($_SESSION['current_user']) && $_SESSION['current_user']->userlevel->level > $required_level)
        {
            halt(HTTP_FORBIDDEN, 'You are not authorized to view this page');
            exit;
        }
    }
}

function security_login($email, $password, $remember_me = false, $cookie_login = false)
{
    require(LIB_DIR . 'phpass-0.3/PasswordHash.php');

    $user = R::findOne('user', 'email = ?', array($email));

    if($user->id == 0)
    {
        return false;
    }

    $hasher = new PasswordHash(8, false);

    if($cookie_login)
    {
        if($password !== $user->password)
        {
            return false;
        }
    }
    else
    {
        if(!$hasher->CheckPassword($password, $user->password))
        {
            return false;
        }
    }

    $_SESSION['current_user'] = $user;

    if(!$cookie_login && $remember_me)
    {
        setcookie('email', $user->email, time() + (60 * 60 * 24 * 7), $_SERVER['HTTP_HOST']);
        setcookie('password', $user->password, time() + (60 * 60 * 24 * 7), $_SERVER['HTTP_HOST']);
    }

    return true;
}

function security_logout()
{
    session_destroy();

    setcookie('email', '', time() + (60 * 60));
    setcookie('password', '', time() + (60 * 60));
}
