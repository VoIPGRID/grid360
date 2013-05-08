<?php

function create_round()
{
    security_authorize(ADMIN);

    if(get_current_round()->id != 0)
    {
        return html('Round already in progress');
    }

    global $smarty;

    return html($smarty->fetch('round/round.tpl'));
}

function start_round()
{
    security_authorize(ADMIN);

    if(get_current_round()->id != 0)
    {
        return html('A round is already in progress!');
    }

    $round = R::graph($_POST);
    $round->status = 1;

    $users = R::findAll('user'); // TODO: Add tenant id

    $index = 0;

    foreach($users as $reviewer)
    {
        $own_department_users = R::find('user', 'department_id = ?', array($reviewer->department->id));
        $random_department_users = R::find('user', 'department_id != ?', array($reviewer->department->id));

        $number = rand(2, count($random_department_users)); // TODO: Add max/min, maybe editable?
        $keys = array_rand($random_department_users, $number);

        $random_users = array();
        for($i = 0; $i < count($keys); $i++)
        {
            $random_users[] = $random_department_users[$keys[$i]];
        }

        $all_users = array_merge($own_department_users, $random_users);

        $roundinfo = R::dispense('roundinfo', count($all_users));

        foreach($all_users as $key => $reviewee)
        {
            $roundinfo[$key]->status = 0;
            $roundinfo[$key]->answer = '';
            $roundinfo[$key]->round = $round;
            $roundinfo[$key]->reviewer = $reviewer;
            $roundinfo[$key]->reviewee = $reviewee;

            $index++;
        }

        R::storeAll($roundinfo);
    }

    R::store($round);


    return html('Round created!');
}

function round_overview()
{
    security_authorize(ADMIN);
    $round = get_current_round();

    global $smarty;
    $smarty->assign('round', $round);
    $smarty->assign('page_title', 'Round overview');

    return html($smarty->fetch('round/round_overview.tpl'));
}

function end_round()
{
    security_authorize(ADMIN);

    $round = get_current_round();

    if($round->id == 0)
    {
        return html('Round not found');
    }

    $round->status = ROUND_COMPLETED;

    R::store($round);

    return html('Round ended!');
}
