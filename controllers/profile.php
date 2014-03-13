<?php

function edit_profile()
{
    security_authorize();

    $user = $_SESSION['current_user'];

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
        $form_values['id']['value'] = $user->id;
        $form_values['firstname']['value'] = $user->firstname;
        $form_values['lastname']['value'] = $user->lastname;
        $form_values['email']['value'] = $user->email;
        $form_values['department']['value'] = $user->department->name;
        $form_values['role']['value'] = $user->role->name;
        $form_values['work']['value'] = $agreements->work;
        $form_values['training']['value'] = $agreements->training;
        $form_values['other']['value'] = $agreements->other;

        $smarty->assign('form_values', $form_values);
    }

    $smarty->assign('user_name', $user->firstname . ' ' . $user->lastname);
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

    $agreements = R::findOne('agreements', 'user_id = ?', array($user->id));

    if($agreements->id == 0)
    {
        $agreements = R::dispense('agreements');
    }

    $agreements->work = trim($_POST['work']);
    $agreements->training = trim($_POST['training']);
    $agreements->other = trim($_POST['other']);
    $agreements->user = R::load('user', $user->id);

    R::store($agreements);

    $message = _('Profile updated');
    flash('success', $message);
    redirect_to('/');
}