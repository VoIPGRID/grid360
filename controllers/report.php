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

    $averages = array();

    foreach($reviews as $review)
    {
        $averages[$review->competency->id][] = $review->rating->id;
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
        $averageRatings[$key]['name'] = R::load('competency', $key)->name;
    }

    global $smarty;
    $smarty->assign('reviews', $reviews);
    $smarty->assign('averages', $averageRatings);
    $smarty->assign('roundinfo', $roundInfo);
    $smarty->assign('round', $round);
    $smarty->display('reports/report.tpl');
}