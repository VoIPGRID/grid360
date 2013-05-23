<?php

function login()
{
    if(isset($_COOKIE['email']) && isset($_COOKIE['password']))
    {
        if(security_login($_COOKIE['email'], $_COOKIE['password'], false, true))
        {
            header('Location: ' . BASE_URI);
            exit;
        }
    }

    global $smarty;
    $smarty->assign('page_header', APP_NAME);
    $smarty->assign('page_header_size', 'h2');

    if(isset($_GET['error']))
    {
        $smarty->assign('error_type', $_GET['error']);
    }

    return html($smarty->fetch('security/login.tpl'), 'layout/basic.php');
}

function login_post()
{
    if(!empty($_POST['email']) && !empty($_POST['password']))
    {
        if(security_login($_POST['email'], $_POST['password'], $_POST['remember_me'], false))
        {
            header('Location: ' . BASE_URI);
            exit;
        }
        else
        {
            header('Location: ' . BASE_URI . 'login?error=1');
        }
    }
    else if(empty($_POST['email']) && !empty($_POST['password']))
    {
        header('Location: ' . BASE_URI . 'login?error=2');
    }
    else if(!empty($_POST['email']) && empty($_POST['password']))
    {
        header('Location: ' . BASE_URI . 'login?error=3');
    }
    else
    {
        header('Location: ' . BASE_URI . 'login?error=4');
    }
}

function logout()
{
    security_logout();

    header('Location: ' . BASE_URI . 'login');
}
