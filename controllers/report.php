<?php

function report_overview()
{
    security_authorize();

    $rounds = R::findAll('round');

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
        $round = $current_round;

        // If there's no round in progress, get the latest round
        if($round->id == 0)
        {
            $round = R::findOne('round', '1 ORDER BY id desc'); // The '1' is needed because RedBean starts with WHERE, so the '1' makes sure the query is valid

            if($round->id == 0)
            {
                return html(NO_REPORTS_FOUND);
            }
        }
    }

    $reviews = R::find('review', 'reviewee_id = ? AND round_id = ?', array($user->id, $round->id));
    R::preload($reviews, array('reviewer' => 'user'));

    $roundinfo = R::find('roundinfo', 'reviewee_id = ? AND status = ? AND round_id = ?', array($user->id, REVIEW_COMPLETED, $round->id));
    R::preload($roundinfo, array('reviewer' => 'user'));

    $total_review_count = R::count('roundinfo', 'reviewee_id = ? AND status != ? AND round_id = ?', array($user->id, REVIEW_SKIPPED,$round->id));

    $own_roundinfo = R::find('roundinfo', 'reviewer_id = ? AND status = ? AND round_id = ?', array($user->id, REVIEW_COMPLETED, $round->id));
    $total_own_review_count = R::count('roundinfo', 'reviewer_id = ? AND status != ? AND round_id = ?', array($user->id, REVIEW_SKIPPED,$round->id));

    if((count($roundinfo) - 1) < 4)
    {
        return html(sprintf(REPORT_INSUFFICIENT_DATA, (count($roundinfo) - 1), $total_review_count));
    }

    if((count($own_roundinfo) - 1) < 5)
    {
        return html(sprintf(REPORT_INSUFFICIENT_REVIEWED, count($own_roundinfo), $total_own_review_count));
    }

    $ratings = array();
    $own_ratings = array();
    $positive_ratings = array();
    $negative_ratings = array();

    $comment_counts = array();
    foreach($reviews as $review)
    {
        if($review->reviewer->id != $user->id)
        {
            if($review->is_positive == 1)
            {
                $positive_ratings[$review->competency->id][] = $review->rating->id;
            }
            elseif($review->is_positive == 0)
            {
                $negative_ratings[$review->competency->id][] = $review->rating->id;
            }

            $ratings[$review->competency->id][] = $review->rating->id;
        }
        else
        {
            $own_ratings[$review->competency->id] = $review->rating->id;
        }

        if($review->comment != '')
        {
            if(array_key_exists($review->competency->id, $comment_counts))
            {
                $comment_counts[$review->competency->id] += 1;
            }
            else
            {
                $comment_counts[$review->competency->id] = 1;
            }
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
        $average_ratings[$competency_id]['count_reviews'] = count($rating);
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
    $header = sprintf(REPORT_PAGE_HEADER, $user->firstname, $user->lastname, $round->description);
    $smarty->assign('page_header', $header);
    $smarty->assign('page_header_size', 'h2');
    $smarty->assign('has_own_ratings', $has_own_ratings);
    $smarty->assign('user', $user);
    $smarty->assign('comment_counts', $comment_counts);

    if($current_round->id == 0)
    {
        $current_round = R::findOne('round', '1 ORDER BY id desc');
        $smarty->assign('current_round_id', $current_round->id); // The '1' is needed because RedBean starts with WHERE, so the '1' makes sure the query is valid
    }
    else
    {
        $smarty->assign('current_round_id', $current_round->id);
    }

    $smarty->assign('previous_round', R::load('round', $current_round->id - 1));

    set('title', $header);

    return html($smarty->fetch('report/report.tpl'));
}
