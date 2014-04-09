<?php

function dashboard()
{
    security_authorize();

    $rounds = R::findAll('round');
    $roundinfo = R::find('roundinfo', 'reviewer_id = ? AND round_id = ? AND status != ?', array($_SESSION['current_user']->id, get_current_round()->id, REVIEW_SKIPPED));

    R::preload($roundinfo, array('reviewee' => 'user'));

    foreach($roundinfo as $roundinfo_id => $info)
    {
        if($info->reviewee->status == PAUSE_USER_REVIEWS)
        {
            // Remove a user from the list if they should be reviewed (status = paused)
            unset($roundinfo[$roundinfo_id]);
        }
    }

    global $smarty;
    $smarty->assign('rounds', $rounds);
    $smarty->assign('roundinfo', $roundinfo);
    $smarty->assign('page_header', _('Dashboard'));

    return html($smarty->fetch('common/dashboard.tpl'));
}

function info_message()
{
    security_authorize();

    global $smarty;

    $info_message = R::findOne('infomessage');

    if($info_message->id == 0)
    {
        redirect_to('/');
    }

    $smarty->assign('info_message', $info_message);

    return html($smarty->fetch('common/info_message.tpl'));
}

function info_message_read()
{
    security_authorize();

    $user = R::load('user', $_SESSION['current_user']->id);
    $user->info_message_read = 1;

    R::store($user);

    $_SESSION['current_user'] = $user;

    redirect_to('profile');
}
