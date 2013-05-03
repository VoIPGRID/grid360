<?php

function dashboard()
{
    security_authorize();

    $rounds = R::findAll('round');
    $roundinfo = R::find('roundinfo', ' reviewer_id = ? && round_id = ?', array($_SESSION['current_user']->id, 4)); // TODO: Change to currentRound->id
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
