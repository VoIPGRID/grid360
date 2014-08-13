<?php

function edit_profile()
{
    security_authorize();

    $user = R::load('user', $_SESSION['current_user']->id);

    if($user->id == 0)
    {
        $message = _('Error loading profile');
        flash('error', $message);
        redirect_to('/');
    }

    global $smarty;

    $agreements = R::findOne('agreements', 'user_id = ?', array($user->id));

    if(!$smarty->getTemplateVars('form_values'))
    {
        $form_values = array();
        $form_values['work']['value'] = $agreements->work;
        $form_values['training']['value'] = $agreements->training;
        $form_values['other']['value'] = $agreements->other;
        $form_values['goals']['value'] = $agreements->goals;

        $smarty->assign('form_values', $form_values);
    }

    $display_password_form = true;

    // Password form should be hidden when logging in with Google or when agreements should be filled in (to avoid confusion)
    if($_SESSION['google_login'] || $_SESSION['first_time_login'])
    {
        $display_password_form = false;
    }

    $smarty->assign('display_password_form', $display_password_form);
    $smarty->assign('agreements', $agreements);

    $display_has_agreements = true;

    if(!empty($agreements->work) && !empty($agreements->training) && !empty($agreements->goals))
    {
        $display_has_agreements = false;
    }

    $smarty->assign('display_has_agreements', $display_has_agreements);

    set('title', _('Edit profile'));

    return html($smarty->fetch('profile/profile.tpl'));
}

function edit_profile_post()
{
    security_authorize();

    $user = $_SESSION['current_user'];

    if($user->id == 0)
    {
        $message = _('Error loading profile');
        flash('error', $message);
        redirect_to('/');
    }

    $error = false;
    $form_values = array();

    $new_password = $_POST['new_password'];
    $new_password_confirm = $_POST['new_password_confirm'];
    $has_agreements = $_POST['has_agreements'];

    if(strlen($new_password) > 0)
    {
        if(strlen($new_password_confirm) == 0 || $new_password != $new_password_confirm)
        {
            $form_values['new_password']['error'] = _('Passwords do not match!');
            $error = true;
        }
        else
        {
            $hasher = new PasswordHash(8, false);
            $user->password = $hasher->HashPassword($new_password);
        }
    }

    $agreements = R::findOne('agreements', 'user_id = ?', array($user->id));

    if($agreements->id == 0)
    {
        $agreements = R::dispense('agreements');
    }
    else
    {
        if(isset($has_agreements) && !empty($agreements->work) && !empty($agreements->training) && !empty($agreements->goals))
        {
            $form_values['agreements']['error'] = _('There was an error processing the form');
            $error = true;
        }
    }

    if(!isset($has_agreements) || $has_agreements)
    {
        $agreements->work = trim($_POST['work']);
        $agreements->training = trim($_POST['training']);
        $agreements->other = trim($_POST['other']);
        $agreements->goals = trim($_POST['goals']);

        if(empty($agreements->work) || empty($agreements->training) || empty($agreements->goals))
        {
            $form_values['agreements']['error'] = _('One or more fields was not filled in');
            $error = true;
        }
    }

    if($error)
    {
        $form_values['work']['value'] = $agreements->work;
        $form_values['training']['value'] = $agreements->training;
        $form_values['other']['value'] = $agreements->other;
        $form_values['goals']['value'] = $agreements->goals;

        global $smarty;
        $smarty->assign('form_values', $form_values);

        return edit_profile();
    }

    $agreements->user = $user;

    if(!isset($has_agreements) && !empty($agreements->work) && !empty($agreements->training) && !empty($agreements->goals))
    {
        $has_agreements = true;
    }

    $agreements->has_agreements = $has_agreements;

    R::store($user);
    R::store($agreements);

    $message = _('Profile updated');
    flash('success', $message);
    redirect_to('/');
}
