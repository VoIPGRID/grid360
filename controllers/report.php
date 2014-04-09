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

    // If there's no round given, get the latest round
    if($round->id == 0)
    {
        $round = R::findOne('round', '1 ORDER BY id desc'); // The '1' is needed because RedBean starts with WHERE, so the '1' makes sure the query is valid

        if($round->id == 0)
        {
            return html(_('No reports found'));
        }
    }

    global $smarty;

    // Set the round IDs which are used for the previous and next buttons
    $previous_round = R::findOne('round', 'id < ? ORDER BY id DESC', array($round->id));
    $smarty->assign('previous_round_id', $previous_round->id);

    $next_round = R::findOne('round', 'id > ? ORDER BY id ASC', array($round->id));
    $smarty->assign('next_round_id', $next_round->id);

    $smarty->assign('round', $round);

    // Generate the previous and next buttons
    $pager = $smarty->fetch('report/report_pager.tpl');

    if($round->status == 0)
    {
        // If the round is over there should be a report ready, so get that file
        $file_name = 'report_' . $round->id . '_' . $user->id . '_' . strtolower($user->firstname) . '_' . strtolower($user->lastname);
        $file = BASE_DIR . 'reports/' . $file_name;

        if(file_exists($file))
        {
            $report = file_get_contents($file);
        }
        else
        {
            // No generated report found, so just display the pager and a message
            return html($pager . _('No reviews found for the current round'));
        }
    }
    else
    {
        // If the round is still in progress, generate the report and show it
        $report = generate_report($user, $round);
    }

    $report = preg_replace('/##pager##/', $pager, $report, 1);

    return html($report);
}

function generate_report($user, $round)
{
    $reviews = R::find('review', 'reviewee_id = ? AND round_id = ?', array($user->id, $round->id));
    R::preload($reviews, array('reviewer' => 'user'));

    $roundinfo = R::find('roundinfo', 'reviewee_id = ? AND status = ? AND round_id = ?', array($user->id, REVIEW_COMPLETED, $round->id));
    R::preload($roundinfo, array('reviewer' => 'user'));

    $agreement_reviews = R::find('agreementreview', 'reviewee_id = ? AND round_id = ?', array($user->id, $round->id));
    R::preload($agreement_reviews, array('reviewer' => 'user'));

    // Count the amount of people that have reviewed the user
    $count_reviewed_by = count($roundinfo);

    // Count the total amount of people that have to review the user
    $total_review_count = R::count('roundinfo', 'reviewer_id != ? AND reviewee_id = ? AND status != ? AND round_id = ?', array($user->id, $user->id, REVIEW_SKIPPED, $round->id));

    // Count the amount of people the user has reviewed
    $own_review_completed_count = R::count('roundinfo', 'reviewer_id = ? AND reviewee_id != ? AND status = ? AND round_id = ?', array($user->id, $user->id, REVIEW_COMPLETED, $round->id));

    // Count the total amount of people the user has to review
    $total_own_review_count = R::count('roundinfo', 'reviewer_id = ? AND reviewee_id != ? AND status != ? AND round_id = ?', array($user->id, $user->id, REVIEW_SKIPPED, $round->id));

    // Check if roundinfo contains own review, if so, deduct 1 from the amount reviewed by
    foreach($roundinfo as $info)
    {
        if($info->reviewer_id == $user->id)
        {
            $count_reviewed_by -= 1;
            break;
        }
    }

    global $smarty;
    $generate_report = true;

    // Execute necessary check when a round is in progress
    if($round->status == 1)
    {
        // If someone hasn't been reviewed enough times, show error and don't show report
        if($count_reviewed_by < $round->min_reviewed_by)
        {
            $message = _('Insufficient data available to generate a report.') . '<br />';
            $message .= _('%d of %d people have reviewed you.') . '<br />';
            $message .= _('A minimum of %d people is needed to generate a report.');
            $smarty->assign('insufficient_data', true);
            $smarty->assign('insufficient_reviewed_by', sprintf($message, $count_reviewed_by, $total_review_count, $round->min_reviewed_by));
            $generate_report = false;
        }

        // If someone hasn't reviewed enough people, show error and don't show report
        if($own_review_completed_count < $round->min_to_review)
        {
            $message = _('You haven\'t reviewed enough people.') . '<br />';
            $message .= _('You need to review at least %d people.') . '<br />';
            $message .= _('You have reviewed %d of %d people.');
            $smarty->assign('insufficient_data', true);
            $smarty->assign('insufficient_reviewed', sprintf($message, $round->min_to_review, $own_review_completed_count, $total_own_review_count));
            $generate_report = false;
        }
    }

    // No need to calculate everything if we're not displaying the report
    if($generate_report)
    {
        $own_general_reviews = array();
        $own_role_reviews = array();
        $other_general_reviews = array();
        $other_role_reviews = array();
        $own_agreement_reviews = array();
        $other_agreement_reviews = array();

        $competencies = array();

        $general_competency_keys = array_keys(get_general_competencies()->ownCompetency);

        foreach($reviews as $review)
        {
            if($review->reviewer_id == $user->id)
            {
                $reviewer_type = 'own';
            }
            else
            {
                $reviewer_type = 'other';
            }

            if(in_array($review->competency->id, $general_competency_keys))
            {
                $type = 'general';
            }
            else
            {
                $type = 'role';
            }

            // Dynamically create the variable name and then store $review into that review array. Also seperate into arrays based on the selection so it's easier to read the array in the template
            ${$reviewer_type . '_' . $type . '_reviews'}[$review->selection][$review->competency_id][] = $review;

            if(!in_array($review->competency, $competencies) && $review->competency_id != 0)
            {
                $competencies[$review->competency_id] = $review->competency;
            }
        }

        foreach($agreement_reviews as $agreement_review)
        {
            if($agreement_review->reviewer_id == $user->id)
            {
                $own_agreement_reviews[$agreement_review->selection][$agreement_review->type][] = $agreement_review;
            }
            else
            {
                $other_agreement_reviews[$agreement_review->selection][$agreement_review->type][] = $agreement_review;
            }
        }

        $smarty->assign('review_count', count($reviews));
        $smarty->assign('own_general_reviews', $own_general_reviews);
        $smarty->assign('own_role_reviews', $own_role_reviews);
        $smarty->assign('other_general_reviews', $other_general_reviews);
        $smarty->assign('other_role_reviews', $other_role_reviews);
        $smarty->assign('own_agreement_reviews', $own_agreement_reviews);
        $smarty->assign('other_agreement_reviews', $other_agreement_reviews);
        $smarty->assign('competencies', $competencies);
        $smarty->assign('agreement_reviews', $agreement_reviews);
        $smarty->assign('agreements', get_agreements($user->id));
    }

    $smarty->assign('general_competencies', array_keys(get_general_competencies()->ownCompetency));
    $smarty->assign('roundinfo', $roundinfo);
    $smarty->assign('round', $round);
    $smarty->assign('user', $user);

    // Set the page headers
    $header = sprintf(_('Report for %s %s of %s'), $user->firstname, $user->lastname, $round->description);
    $subheader = sprintf(_('You have been reviewed by %d of %d people'), $count_reviewed_by, $total_review_count);
    $smarty->assign('page_header', $header);
    $smarty->assign('page_subheader', $subheader);
    $smarty->assign('page_header_size', 'h2');

    set('title', $header);

    // Generate the HTML
    $report = $smarty->fetch('report/report.tpl');

    $firstname = strtolower(iconv('utf8', 'ascii//TRANSLIT', $user->firstname));
    $lastname = strtolower(iconv('utf8', 'ascii//TRANSLIT', $user->lastname));

    // Store the report
    $file_name = 'report_' . $round->id . '_' . $user->id . '_' . $firstname . '_' . $lastname;

    $file = BASE_DIR . 'reports/' . $file_name;
    $fh = fopen($file, 'w') or die("can't open file");
    fwrite($fh, $report);

    fclose($fh);

    return $report;
}