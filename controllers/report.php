<?php
/**
 * @author epasagic
 * @date 12-4-13
 */

function view_report()
{
    $id = 1;
    $roundId = params('id');

    if($roundId == null || empty($roundId))
    {
        $roundId = 4; // TODO: Set to current round
    }

    $reviews = R::find('review', ' reviewee_id = ? AND round_id = ?', array($id, $roundId));
    $roundInfo = R::find('roundinfo', ' reviewee_id = ? AND status = 1 AND round_id = ?', array($id, $roundId));
    $round = R::load('round', $roundId);
    R::preload($reviews, array('reviewer'=>'user'));

    $averages = array();
    $self = array();

    foreach($reviews as $review)
    {
        if($review->reviewer->id != $id)
        {
            $averages[$review->competency->id][] = $review->rating->id;
        }
        else
        {
            $self[$review->competency->id] = $review->rating->id;
        }
    }

    $averageRatings = array();

    foreach($averages as $key => $average)
    {
        $total = 0;
        foreach($average as $value)
        {
            $total += $value;
        }

        $averageRatings[$key]['average'] = round($total / count($average), 2);
        $averageRatings[$key]['self'] = $self[$key];
        $averageRatings[$key]['name'] = R::load('competency', $key)->name;
    }

    global $smarty;
    $smarty->assign('reviews', $reviews);
    $smarty->assign('averages', $averageRatings);
    $smarty->assign('roundinfo', $roundInfo);
    $smarty->assign('round', $round);
    $smarty->assign('pageTitle', 'Report');
    $smarty->assign('pageTitleSize', 'h2');
    set('title', 'Report');

    return html($smarty->fetch('reports/report.tpl'));
}
