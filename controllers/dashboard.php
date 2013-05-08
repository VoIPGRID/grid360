<?php

function dashboard()
{
    security_authorize();

    $rounds = R::findAll('round'); // TODO: Add tenant id
    $roundinfo = R::find('roundinfo', 'reviewer_id = ? AND round_id = ? AND status != ?', array($_SESSION['current_user']->id, get_current_round()->id, REVIEW_SKIPPED));
    R::preload($roundinfo, array('reviewee' => 'user'));

    foreach($roundinfo as $key => $info)
    {
        if($info->reviewee->status == 0)
        {
            unset($roundinfo[$key]);
        }
    }

    global $smarty;
    $smarty->assign('rounds', $rounds);
    $smarty->assign('roundinfo', $roundinfo);
    $smarty->assign('page_title', 'Dashboard');

    return html($smarty->fetch('common/dashboard.tpl'));
}
