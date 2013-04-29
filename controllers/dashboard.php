<?php
/**
 * @author epasagic
 * @date 24-4-13
 */

function dashboard()
{
    $rounds = R::findAll('round');
    $roundInfo = R::find('roundinfo', ' reviewer_id = ? && round_id = ?', array(1, 4)); // TODO: Change to currentUser->id and currentRound->id
    R::preload($roundInfo, array('reviewee' => 'user'));

    foreach($roundInfo as $key => $info)
    {
        if($info->reviewee->status == 0)
        {
            unset($roundInfo[$key]);
        }
    }

    global $smarty;
    $smarty->assign('rounds', $rounds);
    $smarty->assign('roundinfo', $roundInfo);
    $smarty->assign('pageTitle', 'Dashboard');

    return html($smarty->fetch('dashboard.tpl'));
}

return 'iets';
