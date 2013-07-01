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
    $smarty->assign('page_header', _('Report overview for ') . $user->firstname . ' ' . $user->lastname);

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

    // If there's no round in progress, get the latest round
    if($round->id == 0 || $current_round->id == 0)
    {
        $round = R::findOne('round', '1 ORDER BY id desc'); // The '1' is needed because RedBean starts with WHERE, so the '1' makes sure the query is valid

        if($round->id == 0)
        {
            return html(NO_REPORTS_FOUND);
        }
    }

    $reviews = R::find('review', 'reviewee_id = ? AND round_id = ?', array($user->id, $round->id));
    R::preload($reviews, array('reviewer' => 'user'));

    $roundinfo = R::find('roundinfo', 'reviewee_id = ? AND status = ? AND round_id = ?', array($user->id, REVIEW_COMPLETED, $round->id));
    R::preload($roundinfo, array('reviewer' => 'user'));

    // Count the amount of people that have reviewed the user
    $count_reviewed_by = count($roundinfo);

    // Count the total amount of people that have to review the user
    $total_review_count = R::count('roundinfo', 'reviewer_id != ? AND reviewee_id = ? AND status != ? AND round_id = ?', array($user->id, $user->id, REVIEW_SKIPPED,$round->id));

    // Count the amount of people the user has reviewed
    $own_review_completed_count = R::count('roundinfo', 'reviewer_id = ? AND reviewee_id != ? AND status = ? AND round_id = ?', array($user->id, $user->id, REVIEW_COMPLETED, $round->id));

    // Count the total amount of people the user has to review
    $total_own_review_count = R::count('roundinfo', 'reviewer_id = ? AND reviewee_id != ? AND status != ? AND round_id = ?', array($user->id, $user->id, REVIEW_SKIPPED,$round->id));

    // Check if roundinfo contains own review, if so, deduct 1 from the amount reviewed by
    foreach($roundinfo as $info)
    {
        if($info->reviewer_id == $user->id)
        {
            $count_reviewed_by -= 1;
            break;
        }
    }

    if($round->status == 1)
    {
        if($count_reviewed_by < 5)
        {
            $message = _('Insufficient data available to generate a report.') . '<br />' . _('%d of %d people have reviewed you.') . '<br />' . _('A minimum of 5 people is needed to generate a report.'); // TODO: Make this prettier
            return html(sprintf($message, $count_reviewed_by, $total_review_count));
        }

        if($own_review_completed_count < 5)
        {
            $message = _('You haven\'t reviewed enough people.') . '<br />' . _('You need to review at least 5 people.') . '<br />' . _('You have reviewed %d of %d people.'); // TODO: Make this prettier
            return html(sprintf($message, $own_review_completed_count, $total_own_review_count));
        }
    }

    $ratings = array();
    $own_ratings = array();
    $positive_ratings = array();
    $negative_ratings = array();
    $comment_counts = array();

    foreach($reviews as $review)
    {
        if($review->reviewer_id != $user->id)
        {
            if($review->is_positive == 1)
            {
                $positive_ratings[$review->competency_id][] = $review->rating_id;
            }
            elseif($review->is_positive == 0)
            {
                $negative_ratings[$review->competency_id][] = $review->rating_id;
            }

            $ratings[$review->competency_id][] = $review->rating_id;
        }
        else
        {
            $own_ratings[$review->competency_id] = $review->rating_id;
        }

        if($review->comment != '')
        {
            if(array_key_exists($review->competency_id, $comment_counts))
            {
                $comment_counts[$review->competency_id] += 1;
            }
            else
            {
                $comment_counts[$review->competency_id] = 1;
            }
        }
    }

    $average_positive_ratings = array();

    foreach($positive_ratings as $competency_id => $rating)
    {
        $average_positive_ratings[$competency_id]['average'] = round(array_sum($rating) / count($rating), 2);
        $average_positive_ratings[$competency_id]['count_reviews'] = count($rating);
        $average_positive_ratings[$competency_id]['own_rating'] = $own_ratings[$competency_id];
        $average_positive_ratings[$competency_id]['name'] = R::load('competency', $competency_id)->name;
    }

    $average_negative_ratings = array();

    foreach($negative_ratings as $competency_id => $rating)
    {
        $average_negative_ratings[$competency_id]['average'] = round(array_sum($rating) / count($rating), 2);
        $average_negative_ratings[$competency_id]['count_reviews'] = count($rating);
        $average_negative_ratings[$competency_id]['own_rating'] = $own_ratings[$competency_id];
        $average_negative_ratings[$competency_id]['name'] = R::load('competency', $competency_id)->name;
    }

    $average_ratings = array();

    // Calculate the averages
    foreach($ratings as $competency_id => $rating)
    {
        $average_ratings[$competency_id]['average'] = round((array_sum($rating) / count($rating)), 2);
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

    global $smarty;
    $smarty->assign('reviews', $reviews);
    $smarty->assign('averages', $average_ratings);
    $smarty->assign('positive_averages', $average_positive_ratings);
    $smarty->assign('negative_averages', $average_negative_ratings);
    $smarty->assign('roundinfo', $roundinfo);
    $smarty->assign('round', $round);

    // Set the page headers
    $header = sprintf(_('Report for %s %s of %s'), $user->firstname, $user->lastname, $round->description);
    $header_subtext =  sprintf(_('You have been reviewed by %d of %d people'), $count_reviewed_by, $total_review_count);
    $smarty->assign('page_header', $header);
    $smarty->assign('page_header_subtext', $header_subtext);
    $smarty->assign('page_header_size', 'h2');

    $smarty->assign('has_own_ratings', !empty($own_ratings));
    $smarty->assign('user', $user);
    $smarty->assign('comment_counts', $comment_counts);

    if($current_round->id == 0)
    {
        $current_round = R::findOne('round', '1 ORDER BY id desc'); // The '1' is needed because RedBean starts with WHERE, so the '1' makes sure the query is valid
    }

    $smarty->assign('current_round_id', $current_round->id);
    $smarty->assign('previous_round', R::load('round', $current_round->id - 1));

    set('title', $header);

    return html($smarty->fetch('report/report.tpl'));
}