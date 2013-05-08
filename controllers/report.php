<?php

function view_report()
{
    security_authorize();

    $round = R::load('round', params('id'));

    if($round->id == 0)
    {
        $round = R::load('round', get_current_round()->id);
    }

    $reviews = R::find('review', 'reviewee_id = ? AND round_id = ?', array($_SESSION['current_user']->id, $round->id));
    $roundinfo = R::find('roundinfo', 'reviewee_id = ? AND status = 1 AND round_id = ?', array($_SESSION['current_user']->id, $round->id));
    R::preload($reviews, array('reviewer'=>'user'));

    $averages = array();
    $self = array();

    foreach($reviews as $review)
    {
        if($review->reviewer->id != $_SESSION['current_user']->id)
        {
            $averages[$review->competency->id][] = $review->rating->id;
        }
        else
        {
            $self[$review->competency->id] = $review->rating->id;
        }
    }

    $average_ratings = array();

    foreach($averages as $key => $average)
    {
        $total = 0;
        foreach($average as $value)
        {
            $total += $value;
        }

        $average_ratings[$key]['average'] = round($total / count($average), 2);
        $average_ratings[$key]['self'] = $self[$key];
        $average_ratings[$key]['name'] = R::load('competency', $key)->name;
    }

    foreach($self as $key => $self_row)
    {
        if(!array_key_exists($key, $averages))
        {
            $average_ratings[$key]['average'] = null;
            $average_ratings[$key]['self'] = $self[$key];
            $average_ratings[$key]['name'] = R::load('competency', $key)->name;
        }
    }

    ksort($average_ratings);

    $has_self = false;

    if(count($self) >= 1)
    {
        $has_self = true;
    }

    global $smarty;
    $smarty->assign('reviews', $reviews);
    $smarty->assign('averages', $average_ratings);
    $smarty->assign('roundinfo', $roundinfo);
    $smarty->assign('round', $round);
    $smarty->assign('page_title', 'Report');
    $smarty->assign('page_title_size', 'h2');
    $smarty->assign('has_self', $has_self);
    set('title', 'Report');

    return html($smarty->fetch('report/report.tpl'));
}
