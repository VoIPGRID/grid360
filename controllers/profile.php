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

    if(strlen($new_password) > 0)
    {
        if(strlen($new_password_confirm) == 0 || $new_password != $new_password_confirm)
        {
            $form_values['new_password']['error'] = _('Passwords do not match!');
            $error = true;
        }
    }

    $agreements = R::findOne('agreements', 'user_id = ?', array($user->id));

    if($agreements->id == 0)
    {
        $agreements = R::dispense('agreements');
    }

    $agreements->work = trim($_POST['work']);
    $agreements->training = trim($_POST['training']);
    $agreements->other = trim($_POST['other']);
    $agreements->goals = trim($_POST['goals']);

    if(empty($agreements->work) || empty($agreements->training) || empty($agreements->other) || empty($agreements->goals))
    {
        $form_values['agreements']['error'] = _('One or more fields was not filled in');
        $error = true;
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

    $agreements->user = R::load('user', $user->id);

    R::store($agreements);

    $message = _('Profile updated');
    flash('success', $message);
    redirect_to('/');
}