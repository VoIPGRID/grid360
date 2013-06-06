<?php

//require_once LIB_DIR . 'LightOpenID/openid.php';

function register()
{
    global $smarty;
    $smarty->assign('page_header', 'Register');
    $smarty->assign('page_header_size', 'h2');

    return html($smarty->fetch('security/register.tpl'), 'layout/basic.php');
}

const GOOGLE_OPENID_URL = 'https://www.google.com/accounts/o8/id?id=';

function login_google()
{
    $openid = new LightOpenID('localhost');
    if(!$openid->mode)
    {
        $openid->identity = GOOGLE_OPENID_URL;

        // Redirect to $openid->identity to get permission to use user's info
        redirect_to($openid->authUrl());
    }

    // Save new $openid->identity
    $identity_hash = '';
    $user = null;
    if($openid->validate())
    {
        $identity_hash = str_replace(GOOGLE_OPENID_URL, '', $openid->identity);

        // Query existing user
        $user = R::findOne('user', 'identity = ?', array($identity_hash));

        if($user->id == 0)
        {
            // Store identity hash
            $attributes = $openid->getAttributes();
            if(count($attributes) > 0)
            {
                $user = R::findOne('user', 'email = ?', array($attributes['contact/email']));
                $user->identity = $identity_hash;
                R::store($user);
            }
        }
        else
        {
            // Store user and redirect to frontpage
            $attributes = $openid->getAttributes();
            if(count($attributes) > 0)
            {
                $user->email = $attributes['contact/email'];
                R::store($user);
            }

            $_SESSION['current_user'] = $user;

            redirect_to('/');
        }

        // Redirect for OpenID incase info is missing
        if(!isset($user->email))
        {
            $openid = new LightOpenID('localhost');
            $openid->identity = GOOGLE_OPENID_URL . $identity_hash;
            $openid->required = array(
                'namePerson',
                'namePerson/friendly',
                'namePerson/first',
                'namePerson/last',
                'contact/email'
            );

            redirect_to($openid->authUrl());
        }
    }
}

function register_post()
{
    if(isset($_POST['organisation_name']))
    {
        $user = R::findOne('user', 'email = ?', array($_POST['email']));

        if(intval($user->id) != 0)
        {
            return html('Email already exists!', 'layout/basic.php');
        }

        $tenant = R::dispense('tenant');
        $tenant->name = $_POST['organisation_name'];

        R::store($tenant);

        unset($_POST['organisation_name']);

        $user = R::graph($_POST);

        $hasher = new PasswordHash(8, false);

        $user->password = $hasher->HashPassword($user->password);
        $user->userlevel = R::findOne('userlevel', 'level = ?', array(ADMIN));
        $user->tenant = $tenant;
        $user->status = 1;
        $user->created = R::isoDateTime();

        R::store($user);

        header('Location: ' . BASE_URI . 'login?success=Registration successful!');
    }
    else
    {
        return html('Organisation name can\'t be empty!', 'layout/basic.php');
    }
}

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
