<?php

function report_overview()
{
    security_authorize();

    $rounds = R::findAll('round'); // TODO: Add tenant id

    $user_id = params('user_id');

    if(isset($user_id) && $_SESSION['current_user']->userlevel->level != ADMIN)
    {
        $user = $_SESSION['current_user'];
    }
    else if(isset($user_id) && $_SESSION['current_user']->userlevel->level == ADMIN)
    {
        $user = R::load('user', $user_id);
    }
    else
    {
        $user = $_SESSION['current_user'];
    }

    global $smarty;
    $smarty->assign('rounds', $rounds);
    $smarty->assign('user', $user);
    $smarty->assign('page_header', 'Report overview for ' . $user->firstname . ' ' . $user->lastname);

    return html($smarty->fetch('report/report_overview.tpl'));
}

function view_report()
{
    security_authorize();

    $round = R::load('round', params('round_id'));
    $current_round = get_current_round();
    $user_id = params('user_id');

    if(isset($user_id) && $_SESSION['current_user']->userlevel->level != ADMIN)
    {
        $user = $_SESSION['current_user'];
    }
    else if(isset($user_id) && $_SESSION['current_user']->userlevel->level == ADMIN)
    {
        $user = R::load('user', $user_id);
    }
    else
    {
        $user = $_SESSION['current_user'];
    }

    if($round->id == 0)
    {
        $round = R::load('round', $current_round->id);

        // If there's no round in progress, get the latest round
        if($round->id == 0)
        {
            $round = R::findOne('round', '1 ORDER BY id desc'); // The '1' is needed because RedBean starts with WHERE, so the '1' makes sure the query is valid
        }
    }

    $reviews = R::find('review', 'reviewee_id = ? AND round_id = ?', array($user->id, $round->id));
    $roundinfo = R::find('roundinfo', 'reviewee_id = ? AND status = 1 AND round_id = ?', array($user->id, $round->id));
    R::preload($reviews, array('reviewer'=>'user'));

    $ratings = array();
    $own_ratings = array();

    foreach($reviews as $review)
    {
        if($review->reviewer->id != $user->id)
        {
            $ratings[$review->competency->id][] = $review->rating->id;
        }
        else
        {
            $own_ratings[$review->competency->id] = $review->rating->id;
        }
    }

    $average_ratings = array();

    foreach($ratings as $competency_id => $rating)
    {
        $total = 0;
        foreach($rating as $value)
        {
            $total += $value;
        }

        $average_ratings[$competency_id]['average'] = round($total / count($rating), 2);
        $average_ratings[$competency_id]['own_rating'] = $own_ratings[$competency_id];
        $average_ratings[$competency_id]['name'] = R::load('competency', $competency_id)->name;
    }

    foreach($own_ratings as $competency_id => $own_rating)
    {
        if(!array_key_exists($competency_id, $ratings))
        {
            $average_ratings[$competency_id]['average'] = null;
            $average_ratings[$competency_id]['own_rating'] = $own_ratings[$competency_id];
            $average_ratings[$competency_id]['name'] = R::load('competency', $competency_id)->name;
        }
    }

    ksort($average_ratings);

    $has_own_ratings = false;

    if(!empty($own_ratings))
    {
        $has_own_ratings = true;
    }

    global $smarty;
    $smarty->assign('reviews', $reviews);
    $smarty->assign('averages', $average_ratings);
    $smarty->assign('roundinfo', $roundinfo);
    $smarty->assign('round', $round);
    $header = 'Report for ' . $user->firstname . ' ' . $user->lastname . ' of ' . $round->description;
    $smarty->assign('page_header', $header);
    $smarty->assign('page_header_size', 'h2');
    $smarty->assign('has_own_ratings', $has_own_ratings);
    $smarty->assign('user', $user);

    if($current_round->id == 0)
    {
        $smarty->assign('current_round_id', R::findOne('round', '1 ORDER BY id desc')->id); // The '1' is needed because RedBean starts with WHERE, so the '1' makes sure the query is valid
    }
    else
    {
        $smarty->assign('current_round_id', $current_round->id);
    }

    set('title', $header);

    return html($smarty->fetch('report/report.tpl'));
}
