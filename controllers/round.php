<?php

function round_overview()
{
    security_authorize(ADMIN);
    $round = get_current_round();

    global $smarty;

    if($round->id != 0)
    {
        $smarty->assign('round', $round);

        $completed_reviews = R::count('roundinfo', 'round_id = ? AND status = ?', array($round->id, REVIEW_COMPLETED));
        $total_reviews = R::count('roundinfo', 'round_id = ? AND status != ?', array($round->id, REVIEW_SKIPPED));

        $smarty->assign('completed_reviews', $completed_reviews);
        $smarty->assign('total_reviews', $total_reviews);
    }

    $users = R::findAll('user');

    $smarty->assign('users', $users);
    $smarty->assign('page_header', _('Round overview'));
    $smarty->assign('general_competencies', get_general_competencies()->name);

    return html($smarty->fetch('round/round_overview.tpl'));
}

function create_round()
{
    security_authorize(ADMIN);

    if(get_current_round()->id != 0)
    {
        $message =  _('A round is already in progress!');
        flash('error', $message);
        redirect_to(ADMIN_URI . 'round');
    }

    // Minus 1 because you need to exclude the reviewer
    $count_users = R::count('user', 'status != ?', array(PAUSE_USER_REVIEWS)) - 1;

    if($count_users < 2)
    {
        $message = _('Not enough people in your organisation to start a round. You need at least 4 people that are included in the feedback round.');
        flash('error', $message);
        redirect_to(ADMIN_URI . 'round');
    }

    global $smarty;

    $smarty->assign('count_users', $count_users);

    return html($smarty->fetch('round/round.tpl'));
}

function start_round_confirmation()
{
    security_authorize(ADMIN);

    if(get_current_round()->id != 0)
    {
        $message =  _('A round is already in progress!');
        flash('error', $message);
        redirect_to(ADMIN_URI . 'round/create');
    }

    // Minus 1 because you need to exclude the reviewer
    $count_users = R::count('user', 'status != ?', array(PAUSE_USER_REVIEWS)) - 1;

    if($count_users < 2)
    {
        $message = _('Not enough people in your organisation to start a round. You need at least 4 people that are included in the feedback round.');
        flash('error', $message);
        redirect_to(ADMIN_URI . 'round');
    }

    $form_values = validate_round_form($count_users);

    global $smarty;
    $smarty->assign('form_values', $form_values);

    foreach($form_values as $form_value)
    {
        if(isset($form_value['error']))
        {
            return create_round();
        }
    }

    $smarty->assign('count_users', $count_users);

    return html($smarty->fetch('round/start_round_confirmation.tpl'));
}


function start_round()
{
    security_authorize(ADMIN);

    // check if a round is active
    if(get_current_round()->id > 0)
    {
        $message =  _('A round is already in progress!');
        flash('error', $message);
        redirect_to(ADMIN_URI . 'round');
    }

    // find active users that need to be reviewed this round
    $users = R::find('user', 'status != ?', array(PAUSE_USER_REVIEWS));

    // stop creating a new round when there aren't enough users to be reviewed
    if(count($users) < 2)
    {
        $message = _('Not enough people in your organisation to start a round. You need at least 4 people that are included in the feedback round.');
        flash('error', $message);
        redirect_to(ADMIN_URI . 'round');
    }

    // validate create round form
    $form_values = validate_round_form(count($users));
    foreach($form_values as $form_value)
    {
        if(isset($form_value['error']))
        {
            // show create round form with existing data and errors
            global $smarty;
            $smarty->assign('form_values', $form_values);
            return create_round();
        }
    }

    // no errors, so create new round
    $round = R::dispense('round');
    $round->description = $_POST['description'];

    // get round parameters from $_POST
    // number of reviewees per user (excluding self)
    $total_amount_to_review = $_POST['total_amount_to_review'];

    // number of reviewees per user within user's department (including self)
    $own_amount_to_review = $_POST['own_amount_to_review'];

    // array that keep track how many times someone has been reviewed
    $user_counts = array();

    // array with user ids of reviewees in other departments than the user's
    $other_to_review = array();

    // array with user ids of reviewees within user's department
    $own_to_review = array();

    $reviewed_by = array();

    foreach($users as $reviewer)
    {
        $user_counts[$reviewer->id] = 0;
    }

    // find reviewees for user within user's department
    foreach($users as $reviewer)
    {
        // get number of possible reviewees within user's department
        $own_department_users = R::find('user', 'department_id = ? AND id != ? AND status != ?', array($reviewer->department_id, $reviewer->id, PAUSE_USER_REVIEWS));
        $own_amount_available = count($own_department_users);

        // everybody has to review $user when the number of available reviewee's is less or the same as the minimum required to review
        if($own_amount_available <= $own_amount_to_review)
        {
            // let the user review everybody available
            foreach($own_department_users as $user)
            {
                $user_counts[$user->id] += 1;
                $own_to_review[$reviewer->id][] = $user;
                $reviewed_by[$user->id][$reviewer->id] = $reviewer;
            }
        }
        // continue if there are enough reviewees within user's department
        else if($own_amount_available > $own_amount_to_review)
        {
            // find max $own_amount_to_review number of reviewees
            while(count($own_to_review[$reviewer->id]) < $own_amount_to_review)
            {
                $available_reviewees = array();

                foreach($own_department_users as $user)
                {
                    if(in_array($user, $own_to_review[$reviewer->id]))
                    {
                        continue;
                    }

                    if($user_counts[$user->id] < $total_amount_to_review)
                    {
                        // still allowed to be reviewed by more users
                        $available_reviewees[] = $user;
                    }
                }

                // pick random reviewee
                $reviewee = $available_reviewees[array_rand($available_reviewees)];
                $user_counts[$reviewee->id] += 1;

                // add reviewee
                $own_to_review[$reviewer->id][] = $reviewee;

                $reviewed_by[$reviewee->id][$reviewer->id] = $reviewer;
            }
        }
    }

    // find reviewees for departments other than the user's
    foreach($users as $reviewer)
    {
        if(count($own_to_review[$reviewer->id]) != $total_amount_to_review)
        {
            // get number of possible reviewees for departments other than the user's
            $other_department_users = R::find('user', 'department_id != ? AND status != ?', array($reviewer->department_id, PAUSE_USER_REVIEWS));
            $other_amount_available = count($other_department_users);

            // add all users as reviewees when there are less than total minus already reviewed reviewees available
            if($other_amount_available <= ($total_amount_to_review - count($own_to_review[$reviewer->id])))
            {
                // let the user review everybody available
                foreach($other_department_users as $user)
                {
                    $user_counts[$user->id] += 1;
                    $other_to_review[$reviewer->id][] = $user;
                    $reviewed_by[$user->id][$reviewer->id] = $reviewer;
                }
            }
            // continue if there are enough reviewees in departments other than the user's
            else if($other_amount_available > ($total_amount_to_review - count($own_to_review[$reviewer->id])))
            {
                // find reviewees
                while(count($other_to_review[$reviewer->id]) < ($total_amount_to_review - count($own_to_review[$reviewer->id])))
                {
                    $available_reviewees = array();

                    foreach($other_department_users as $user)
                    {
                        if(in_array($user, $other_to_review[$reviewer->id]))
                        {
                            continue;
                        }

                        if($user_counts[$user->id] < $total_amount_to_review)
                        {
                            // still allowed to be reviewed by more users
                            $available_reviewees[] = $user;
                        }
                    }

                    shuffle($available_reviewees);

                    // pick random reviewee
                    $reviewee = $available_reviewees[array_rand($available_reviewees)];

                    $user_counts[$reviewee->id] += 1;

                    // add reviewee
                    $other_to_review[$reviewer->id][] = $reviewee;
                    $reviewed_by[$reviewee->id][$reviewer->id] = $reviewer;
                }
            }
        }
    }

    $insufficient_reviewers = array();

    // find out who hasn't been reviewed enough and add to $insufficient_reviewers array

    foreach($user_counts as $key => $count)
    {
        if(!empty($key) && $count < $total_amount_to_review)
        {
            $insufficient_reviewers[] = $users[$key];
        }
    }

    $insufficient_reviewees = array();

    // find out what arrays aren't actually full (check if all reviewee's are not empty) and add to $insufficient_reviewees array
    foreach($users as $user)
    {
        foreach($other_to_review[$user->id] as $key => $reviewee)
        {
            if(empty($reviewee))
            {
                unset($other_to_review[$user->id][$key]);

                if(!array_key_exists($user->id, $insufficient_reviewees))
                {
                    $insufficient_reviewees[$user->id] = $user;
                }
            }
        }
    }

    // loop through all users that haven't been reviewed enough
    foreach($insufficient_reviewers as $user)
    {
        // get all available users from other departments
        $other_department_users = R::find('user', 'id != ? AND status != ?', array($user->id, PAUSE_USER_REVIEWS));

        // keep adding $user to other people's $other_to_review while he doesn't have $total_amount_to_review amount of $reviewers
        while($user_counts[$user->id] < $total_amount_to_review)
        {
            $potential_reviewers = array();

            // get all potential reviewers
            foreach($other_department_users as $other_user)
            {
                if(in_array($user, $other_to_review[$other_user->id]))
                {
                    continue;
                }

                // only add a person to $available_reviewers if they have enough reviewers themselves
                if($user_counts[$other_user->id] == $total_amount_to_review)
                {
                    $potential_reviewers[] = $other_user;
                }
            }

            $reviewer = $potential_reviewers[array_rand($potential_reviewers)];
            $potential_reviewees = array();
            $insufficient_reviewees_reviewer = $insufficient_reviewees[array_rand($insufficient_reviewees)];

            // grab a random person from that persons $other_to_review and add that random person to someone who doesn't have $total_amount_to_review reviewees
            foreach($other_to_review[$reviewer->id] as $reviewee)
            {
                if($reviewee->id != $user->id)
                {
                    $potential_reviewees[] = $reviewee;
                }
            }

            $random_reviewee = $potential_reviewees[array_rand($potential_reviewees)];

            if($random_reviewee->department_id == $insufficient_reviewees_reviewer->department_id)
            {
                $potential_reviewees = array();

                foreach($potential_reviewees as $reviewee)
                {
                    if($reviewee->department_id != $insufficient_reviewees_reviewer->department_id)
                    {
                        $potential_reviewees[] = $reviewee;
                    }
                }

                $random_reviewee = $potential_reviewees[array_rand($potential_reviewees)];
            }


            if(count($own_to_review[$insufficient_reviewees_reviewer->id]) + count($other_to_review[$insufficient_reviewees_reviewer->id]) < $total_amount_to_review)
            {
                foreach($other_to_review[$reviewer->id] as $key => $reviewee)
                {
                    if($reviewee->id == $random_reviewee->id && $random_reviewee->id != $insufficient_reviewees_reviewer->id && !in_array($random_reviewee, $other_to_review[$insufficient_reviewees_reviewer->id]) && !in_array($random_reviewee, $own_to_review[$insufficient_reviewees_reviewer->id]))
                    {
                        unset($other_to_review[$reviewer->id][$key]);
                        $other_to_review[$insufficient_reviewees_reviewer->id][] = $random_reviewee;
                        $other_to_review[$reviewer->id][] = $user;
                        $user_counts[$user->id] += 1;

                        echo 'Moving ' . $random_reviewee->id . ' (' . $random_reviewee->department_id . ') to ' . $insufficient_reviewees_reviewer->id . ' (' . $insufficient_reviewees_reviewer->department_id . ') from ' . $reviewer->id . ' (' . $reviewer->department_id  . ') and adding user ' . $user->id . ' (' . $user->department_id . ') to ' . $reviewer->id . ' (' . $reviewer->department_id . ')<br>';
                    }
                }
            }
        }
    }

    $reviewee_count = 0;

    foreach($users as $reviewer)
    {
        if(count($own_to_review[$reviewer->id]) == $total_amount_to_review)
        {
            $to_review = $own_to_review[$reviewer->id];
        }
        else
        {
            $to_review = array_merge($own_to_review[$reviewer->id], $other_to_review[$reviewer->id]);
        }

        foreach($to_review as $reviewee_id)
        {
            $reviewees[] = R::load('user', $reviewee_id);
        }

        // You always have to review yourself, so add $reviewer to $reviewees
        $roundinfo = R::dispense('roundinfo', count($to_review));

        // Create the roundinfo
        foreach($to_review as $user_id => $reviewee)
        {
            $roundinfo[$user_id]->status = 0;
            $roundinfo[$user_id]->answer = '';
            $roundinfo[$user_id]->round = $round;
            $roundinfo[$user_id]->reviewer = $reviewer;
            $roundinfo[$user_id]->reviewee = $reviewee;

            // Count the total amount of reviewees
            $reviewee_count += 1;
        }

        R::storeAll($roundinfo);
    }

    // Only create a round if there are reviewees
    if($reviewee_count > 0)
    {
        $round->status = 1;
        $round->created = R::isoDateTime();
        $round->total_to_review = $total_amount_to_review;
        $round->min_reviewed_by = $_POST['min_reviewed_by'];
        $round->min_to_review = $_POST['min_to_review'];

        R::store($round);

        $message =  _('Round created');
        flash('success', $message);
        redirect_to(ADMIN_URI . 'round');
    }
}

function end_round_confirmation()
{
    security_authorize(ADMIN);

    $round = get_current_round();

    if($round->id == 0)
    {
        $message =  _('Round not found');
        flash('error', $message);
        redirect_to(ADMIN_URI . 'round');
    }

    global $smarty;

    return html($smarty->fetch('round/end_round_confirmation.tpl'));
}

function end_round()
{
    security_authorize(ADMIN);

    $round = get_current_round();

    if($round->id == 0)
    {
        $message =  _('Round not found');
        flash('error', $message);
        redirect_to(ADMIN_URI . 'round');
    }

    $round->status = ROUND_COMPLETED;

    R::store($round);

    $users = R::find('user', 'status != ?', array(PAUSE_USER_REVIEWS));

    foreach($users as $user)
    {
       // send_mail('Feedback round ended', ADMIN_EMAIL, $user->email, 'Round ended, you can now log in and view your report.'); // TODO: Enable this
    }

    $message =  _('Round ended');
    flash('success', $message);
    redirect_to(ADMIN_URI . 'round');
}

function validate_round_form($count_users)
{
    if($_POST['total_amount_to_review'] == '')
    {
        // If no total amount to review isn't set, take total amount of users in organisation
        $total_amount_to_review = $count_users;
    }
    else
    {
        $total_amount_to_review = intval($_POST['total_amount_to_review']);
    }

    if($_POST['own_amount_to_review'] == '')
    {
        // If amount to review from own department isn't set, take 66% of total amount to review
        $own_amount_to_review = ceil($total_amount_to_review * 0.66);
    }
    else
    {
        $own_amount_to_review = intval($_POST['own_amount_to_review']);
    }

    if($_POST['min_reviewed_by'] == '')
    {
        // If minimum to be reviewed by isn't set, take 50% of total amount amount to review
        $min_reviewed_by = ceil($total_amount_to_review * 0.50);
    }
    else
    {
        $min_reviewed_by = intval($_POST['min_reviewed_by']);
    }

    if($_POST['min_to_review'] == '')
    {
        // If minimum to review isn't set, take 50% of total amount to review
        $min_to_review = ceil($total_amount_to_review * 0.50);
    }
    else
    {
        $min_to_review = intval($_POST['min_to_review']);
    }

    $form_values = array();
    $form_values['description']['value'] = $_POST['description'];
    $form_values['total_amount_to_review']['value'] = $total_amount_to_review;
    $form_values['own_amount_to_review']['value'] = $own_amount_to_review;
    $form_values['min_reviewed_by']['value'] = $min_reviewed_by;
    $form_values['min_to_review']['value'] = $min_to_review;

    // Minus 1 because you need to exclude the reviewer
    $count_users = R::count('user', 'status != ?', array(PAUSE_USER_REVIEWS)) - 1;

    if(empty($_POST['description']))
    {
        $form_values['description']['error'] = _('Round description can\'t be empty!');
    }

    if($total_amount_to_review === 0)
    {
        $form_values['total_amount_to_review']['error'] = _('Total amount to review can\'t be 0');
    }

    if($own_amount_to_review === 0)
    {
        $form_values['own_amount_to_review']['error'] = _('Amount to review from own department can\'t be 0');
    }

    if($total_amount_to_review > $count_users)
    {
        $form_values['total_amount_to_review']['error'] = _('Total amount to review can\'t be higher than total users in organisation!');
    }

    if($own_amount_to_review > $count_users)
    {
        $form_values['own_amount_to_review']['error'] = _('Amount to review from own department can\'t be higher than total users in organisation!');
    }

    if($own_amount_to_review > $total_amount_to_review)
    {
        $form_values['own_amount_to_review']['error'] = _('Amount to review from own department can\'t be higher than total amount to review!');
    }

    if($min_reviewed_by > $count_users)
    {
        $form_values['min_reviewed_by']['error'] = _('Minimum to be reviewed by can\'t be higher than total users in organisation!');
    }

    if($min_to_review > $count_users)
    {
        $form_values['min_to_review']['error'] = _('Minimum to review by can\'t be higher than total users in organisation!');
    }

    return $form_values;
}
