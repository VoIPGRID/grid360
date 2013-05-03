<?php

function security_authorize()
{
    if($_SESSION['current_user'] == null)
    {
        layout('security/login.tpl');
        header('Location: ' . BASE_URI . 'login');
        exit;
    }
}

function security_login($email, $password, $remember_me = false)
{
    require(LIB_DIR . 'phpass-0.3/PasswordHash.php');

    $user = R::findOne('user', ' email = ?', array($email));
    $hasher = new PasswordHash(8, false);

    if($hasher->CheckPassword($password, $user->password))
    {
        $_SESSION['current_user'] = $user;

        if($remember_me)
        {
            setcookie('email', $user->email, time() + (60 * 60 * 24 * 7));
            setcookie('password', $user->password, time() + (60 * 60 * 24 * 7));
        }
        return true;
    }
    else
    {
        return false;
    }
}
