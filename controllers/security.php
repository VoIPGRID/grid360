<?php

require_once LIB_DIR . 'LightOpenID/openid.php';

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

function register()
{
    if(isset($_SESSION['current_user']))
    {
        return html('Can\'t register new organisation when logged in, please log out first!', 'layout/basic.php');
    }

    global $smarty;
    $smarty->assign('page_header', 'Register');
    $smarty->assign('page_header_size', 'h2');

    return html($smarty->fetch('security/register.tpl'), 'layout/basic.php');
}

function register_post()
{
    $form_values = validate_register_form();

    foreach($form_values as $form_value)
    {
        if(isset($form_value['error']) || strlen($form_value['error']) > 0)
        {
            global $smarty;

            $smarty->assign('form_values', $form_values);

            return register();
        }
    }

    $user = R::findOne('user', 'email = ?', array($_POST['email']));

    if($user->id != 0)
    {
        global $smarty;

        $form_values['email']['error'] = EMAIL_EXISTS;
        $smarty->assign('form_values', $form_values);

        return register();
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

//    send_mail('New tenant registration', 'admin@grid360.nl', $user->email, 'Tenant name: ' . $tenant->name);

    header('Location: ' . BASE_URI . 'login?success=' . _('You have successfully registered a new organisation.'));
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
            header('Location: ' . BASE_URI . 'login?error=Wrong email/password combo!');
        }
    }
    else if(empty($_POST['email']) && !empty($_POST['password']))
    {
        header('Location: ' . BASE_URI . 'login?error=Email can\'t be empty!');
    }
    else if(!empty($_POST['email']) && empty($_POST['password']))
    {
        header('Location: ' . BASE_URI . 'login?error=Password can\'t be empty!');
    }
    else
    {
        header('Location: ' . BASE_URI . 'login?error=Email and password can\'t be empty!');
    }
}

function logout()
{
    security_logout();

    header('Location: ' . BASE_URI . 'login');
}

function reset_password()
{
    global $smarty;

    set('title', 'Reset password');
    $smarty->assign('page_header', 'Reset password');
    $smarty->assign('page_header_size', 'h2');

    if(isset($_GET['uuid']))
    {
        $user = R::findOne('user', 'email = ? AND reset_password_id = ?', array($_GET['email'], $_GET['uuid']));

        if($user->id == 0)
        {
            header('Location: ' . BASE_URI . 'login?error=' . _('The given ID doesn\'t seem to match the one in the database.'));
        }

        if(is_valid($_GET['uuid']))
        {
            $_SESSION['reset_password_id'] = $_GET['uuid'];

            $form_values = flash_now('form_values');
            if(isset($form_values) && $form_values != null)
            {
                $smarty->assign('form_values', $form_values);
            }

            return html($smarty->fetch('security/new_password.tpl'), 'layout/basic.php');
        }

        header('Location: ' . BASE_URI . 'login?error=' . _('The given ID seems to be invalid, please check the link you received in your email or contact the administrator.'));
    }
    else
    {
        return html($smarty->fetch('security/reset_password.tpl'), 'layout/basic.php');
    }
}

function reset_password_post()
{
    if(isset($_SESSION['current_user']))
    {
        return html(_('Can\'t reset your password logged in, please log out first!'), 'layout/basic.php');
    }

    if(isset($_POST['uuid']))
    {
        $user = R::findOne('user', 'email = ? AND reset_password_id = ?', array($_POST['email'], $_POST['uuid']));

        if($user->id == 0)
        {
            return html('User not found', 'layout/basic.php');
        }

        $form_values = validate_reset_password_form();

        if(isset($form_values['error']))
        {
            flash('form_values', $form_values);
            header('Location: ' . BASE_URI . 'reset?uuid=' . $_POST['uuid'] . '&email=' . $_POST['email']);
            exit;
        }

        foreach($form_values as $form_value)
        {
            if(isset($form_value['error']))
            {
                flash('form_values', $form_values);
                header('Location: ' . BASE_URI . 'reset?uuid=' . $_POST['uuid'] . '&email=' . $_POST['email']);
                exit;
            }
        }

        $hasher = new PasswordHash(8, false);

        $user->password = $hasher->HashPassword($_POST['password']);
        $user->reset_password_id = null;

        R::store($user);

        header('Location: ' . BASE_URI . 'login?success=' . _('Your password has been reset!'));
    }
    else
    {
        $user = R::findOne('user', 'email = ?', array($_POST['email']));

        if(!filter_var($_POST['email'], FILTER_VALIDATE_EMAIL))
        {
            $form_values['email']['value'] = $_POST['email'];
            $form_values['email']['error'] = INVALID_EMAIL_FORMAT;

            global $smarty;
            $smarty->assign('form_values', $form_values);

            return reset_password();
        }

        if($user->id == 0)
        {
            $form_values['email']['value'] = $_POST['email'];
            $form_values['email']['error'] = _('Email not found!');

            global $smarty;
            $smarty->assign('form_values', $form_values);

            return reset_password();
        }

        $reset_password_id = random_uuid();

        // TODO: Enable this
//        send_mail('Password reset request', 'admin@grid360.nl',
//            $user->email,
//            'Dear ' . $user->firstname . ' ' . $user->lastname . ",\n\n" . "<a href=http://localhost" . BASE_URI . "reset?uuid=" . $reset_password_id . "&email=" . $user->email . ">Click here to reset password</a>");

        $user->reset_password_id = $reset_password_id;

        R::store($user);
        header('Location: ' . BASE_URI . 'login?success=' . _('A confirmation link has been sent to your email'));
    }
}

function validate_reset_password_form()
{
    $form_values = array();

    if($_SESSION['reset_password_id'] != $_POST['uuid'])
    {
        $form_values['error'] = _('Error with UUID!');
    }
    if(strlen($_POST['password']) == 0)
    {
        $form_values['password']['error'] = sprintf(FIELD_REQUIRED, _('Password'));
    }
    if(strlen($_POST['password_confirm']) == 0)
    {
        $form_values['password_confirm']['error'] = sprintf(FIELD_REQUIRED, _('Password'));
    }
    if($_POST['password'] != $_POST['password_confirm'])
    {
        $form_values['error'] = _('Passwords do not match!');
    }

    return $form_values;
}

function validate_register_form()
{
    $form_values = array();
    $form_values['organisation_name']['value'] = $_POST['organisation_name'];
    $form_values['firstname']['value'] = $_POST['firstname'];
    $form_values['lastname']['value'] = $_POST['lastname'];
    $form_values['email']['value'] = $_POST['email'];
    $form_values['password']['value'] = $_POST['password'];

    if(!isset($form_values['organisation_name']['value']) || strlen($form_values['organisation_name']['value']) == 0)
    {
        $form_values['organisation_name']['error'] = sprintf(FIELD_REQUIRED, _('Organisation name'));
    }
    if(!isset($form_values['firstname']['value']) || strlen($form_values['firstname']['value']) == 0)
    {
        $form_values['firstname']['error'] = sprintf(FIELD_REQUIRED, _('First name'));
    }
    if(!isset($form_values['lastname']['value']) || strlen($form_values['lastname']['value']) == 0)
    {
        $form_values['lastname']['error'] = sprintf(FIELD_REQUIRED, _('Last name'));
    }
    if(!isset($form_values['email']['value']) || strlen($form_values['email']['value']) == 0)
    {
        $form_values['email']['error'] = sprintf(FIELD_REQUIRED, 'Email');
    }
    else if(!filter_var($form_values['email']['value'], FILTER_VALIDATE_EMAIL))
    {
        $form_values['email']['error'] = INVALID_EMAIL_FORMAT;
    }
    if(!isset($form_values['password']['value']) || strlen($form_values['password']['value']) == 0)
    {
        $form_values['password']['error'] = sprintf(FIELD_REQUIRED, _('Password'));
    }

    return $form_values;
}
