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
