<?php

function dashboard()
{
    security_authorize();

    $rounds = R::findAll('round');
    $roundinfo = R::find('roundinfo', 'reviewer_id = ? AND round_id = ? AND status != ?', array($_SESSION['current_user']->id, get_current_round()->id, REVIEW_SKIPPED));
    $own_review = null;

    R::preload($roundinfo, array('reviewee' => 'user'));

    foreach($roundinfo as $roundinfo_id => $info)
    {
        if($info->reviewee->status == PAUSE_USER_REVIEWS)
        {
            // Remove a user from the list if they should be reviewed (status = paused)
            unset($roundinfo[$roundinfo_id]);
        }

        if($info->reviewee_id == $_SESSION['current_user']->id)
        {
            $own_review = $info;
        }
    }

    global $smarty;
    $smarty->assign('rounds', $rounds);
    $smarty->assign('roundinfo', $roundinfo);
    $smarty->assign('own_review', $own_review);
    $smarty->assign('page_header', _('Dashboard'));

    if(!empty($own_review) && $own_review->status == REVIEW_IN_PROGRESS)
    {
        $change_agreements_text = _('Make sure you edit your profile if there are changes to your agreements');
        $smarty->assign('change_agreements_text', $change_agreements_text);
    }

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
