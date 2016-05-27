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

    $round = get_current_round();
    if(isset($round) && $round->id > 0)
    {
        $message =  _('A round is already in progress!');
        flash('error', $message);
        redirect_to(ADMIN_URI . 'round');
    }

    $users = R::find('user', 'status != ?', array(PAUSE_USER_REVIEWS));

    // Minus 1 because you need to exclude the reviewer
    $count_users = count($users) - 1;

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

    $round = get_current_round();
    if(isset($round) && $round->id > 0)
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

    // Check if a round is active
    $round = get_current_round();
    if(isset($round) && $round->id > 0)
    {
        $message = _('A round is already in progress!');
        flash('error', $message);
        redirect_to(ADMIN_URI . 'round');
    }

    // Find active users that need to be reviewed this round
    $users = R::find('user', 'status != ?', array(PAUSE_USER_REVIEWS));

    // Stop creating a new round when there aren't enough users to be reviewed
    if(count($users) < 2)
    {
        $message = _('Not enough people in your organisation to start a round. You need at least 4 people that are included in the feedback round.');
        flash('error', $message);
        redirect_to(ADMIN_URI . 'round');
    }

    // Validate create round form
    $form_values = validate_round_form(count($users));
    foreach($form_values as $form_value)
    {
        if(isset($form_value['error']))
        {
            // Show create round form with existing data and errors
            global $smarty;
            $smarty->assign('form_values', $form_values);
            return create_round();
        }
    }

    // No errors, so create new round
    $round = R::dispense('round');

    // Get round parameters from $_POST
    // Number of reviewees per user (excluding self)
    $total_amount_to_review = $_POST['total_amount_to_review'];

    // Number of reviewees per user within user's department (including self)
    $own_amount_to_review = $_POST['own_amount_to_review'];

    // Array with user ids of reviewees in other departments than the user's
    $other_to_review = array();

    // Array with user ids of reviewees within user's department
    $own_to_review = array();

    foreach($users as $reviewer)
    {
        $other_to_review[$reviewer->id] = array();
        $own_to_review[$reviewer->id] = array();
    }

    $departments = R::findAll('department');

    // Generate reviewees per department
    foreach($departments as $department)
    {
        // Get all users in the department
        $department_users = R::find('user', 'department_id = ? AND status != ?', array($department->id, PAUSE_USER_REVIEWS));
        shuffle($department_users);

        $other_department_users = R::find('user', 'department_id != ? AND status != ?', array($department->id, PAUSE_USER_REVIEWS));
        shuffle($other_department_users);

        for($i = 0; $i < count($department_users); $i++)
        {
            $user = $department_users[$i];

            if (count($department_users) > $own_amount_to_review) {
                $user_index = $i;

                // Keep getting the next person in the list while there are not enough reviewees
                while (count($own_to_review[$user->id]) < $own_amount_to_review) {
                    $user_index++;

                    // We've reached the end, so reset the index
                    if ($user_index >= count($department_users)) {
                        $user_index = 0;
                    }

                    $own_to_review[$user->id][] = $department_users[$user_index];
                }
            }
            else {
                // Not enough reviewees available in own department, so just add everyone
                foreach ($department_users as $department_user) {
                    if ($department_user->id != $user->id) {
                        $own_to_review[$user->id][] = $department_user;
                    }
                }
            }

            // Get random reviewees from other departments
            while (count($other_to_review[$user->id]) < $total_amount_to_review - $own_amount_to_review) {
                $other_user_index++;

                // We've reached the end, so reset the index
                if ($other_user_index >= count($other_department_users)) {
                    $other_user_index = 0;
                }

                $other_to_review[$user->id][] = $other_department_users[$other_user_index];
            }
        }
    }

    $reviewee_count = 0;

    foreach($users as $reviewer)
    {
        $to_review = array_merge($own_to_review[$reviewer->id], $other_to_review[$reviewer->id]);

        // You always have to review yourself, so add $reviewer to $to_review
        $to_review = array_merge($to_review, array($reviewer->id => $reviewer));

        if(count($to_review) > 0) {
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

            if(count($to_review) > 1) {
                R::storeAll($roundinfo);
            } else {
                R::store($roundinfo);
            }
        }
    }

    // Only create a round if there are reviewees
    if($reviewee_count > 0)
    {
        $round->description = $_POST['description'];

        if(!empty($_POST['closing_date']))
        {
            $closing_date = new DateTime(englishify_date($_POST['closing_date']), new DateTimeZone(date_default_timezone_get()));
            $round->closing_date = $closing_date->format('Y-m-d H:00:00');
        }
        else
        {
            $round->closing_date = null;
        }

        $round->status = 1;
        $round->created = R::isoDateTime();
        $round->total_to_review = $total_amount_to_review;
        $round->min_reviewed_by = $_POST['min_reviewed_by'];
        $round->min_to_review = $_POST['min_to_review'];

        R::store($round);

        global $mailer;
        // Use AntiFlood to re-connect after 100 emails
        $mailer->registerPlugin(new Swift_Plugins_AntiFloodPlugin(10));

        // And specify a time in seconds to pause for (30 secs)
        $mailer->registerPlugin(new Swift_Plugins_AntiFloodPlugin(10, 5));

        global $smarty;

        foreach($users as $user)
        {
            // Setup the email
            $smarty->assign('user', $user);
            $body = $smarty->fetch('email/start_round.tpl');
            send_mail(_('Feedback round started'), ADMIN_EMAIL, $user->email, $body, true);
        }

        $message =  _('Round created');
        flash('success', $message);
        redirect_to(ADMIN_URI . 'round');
    }
}

function edit_round()
{
    security_authorize(ADMIN);

    $round = get_current_round();

    if($round->id == 0)
    {
        $message = _('No round in progress');
        flash('error', $message);
        redirect_to(ADMIN_URI . 'round');
    }

    global $smarty;

    if(!$smarty->getTemplateVars('form_values'))
    {
        $form_values = array();
        $form_values['id']['value'] = $round->id;
        $form_values['description']['value'] = $round->description;
        $form_values['closing_date']['value'] = $round->closing_date;
        $form_values['min_reviewed_by']['value'] = $round->min_reviewed_by;
        $form_values['min_to_review']['value'] = $round->min_to_review;

        $smarty->assign('form_values', $form_values);
    }

    // Minus 1 because you need to exclude the reviewer
    $count_users = R::count('user', 'status != ?', array(PAUSE_USER_REVIEWS)) - 1;

    $smarty->assign('count_users', $count_users);

    return html($smarty->fetch('round/edit_round.tpl'));
}

function edit_round_post()
{
    security_authorize(ADMIN);

    // Minus 1 because you need to exclude the reviewer
    $count_users = R::count('user', 'status != ?', array(PAUSE_USER_REVIEWS)) - 1;

    $round = R::load('round', $_POST['id']);

    $form_values = validate_edit_round_form($count_users, $round);

    if($round->id == 0)
    {
        $form_values['error'] = _('Error loading round');
    }

    global $smarty;

    $has_errors = false;
    foreach($form_values as $form_value)
    {
        if(isset($form_value['error']))
        {
            $has_errors = true;
            break;
        }
    }

    // Check if there are errors
    if($has_errors || isset($form_values['error']))
    {
        // Set the form values so they can be used again in the form
        $smarty->assign('form_values', $form_values);

        return edit_round();
    }

    $round->description = $_POST['description'];

    if(!empty($_POST['closing_date']))
    {
        $closing_date = new DateTime($form_values['closing_date']['value'], new DateTimeZone(date_default_timezone_get()));
        $round->closing_date = $closing_date->format('Y-m-d H:00:00');
    }
    else
    {
        $round->closing_date = null;
    }

    $round->min_reviewed_by = $_POST['min_reviewed_by'];
    $round->min_to_review = $_POST['min_to_review'];

    $message = sprintf(UPDATE_SUCCESS, _('round'), $round->description);

    R::store($round);

    flash('success', $message);
    redirect_to(ADMIN_URI . 'round');
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

function end_round($round=null)
{
    security_authorize(ADMIN);

    if (empty($round)) {
        $round = get_current_round();
    }

    if($round->id == 0)
    {
        $message =  _('Round not found');
        flash('error', $message);
        redirect_to(ADMIN_URI . 'round');
    }

    $round->status = ROUND_COMPLETED;

    R::store($round);

    $users = R::find('user', 'status != ?', array(PAUSE_USER_REVIEWS));

    global $mailer;
    // Use AntiFlood to re-connect after 100 emails
    $mailer->registerPlugin(new Swift_Plugins_AntiFloodPlugin(10));

    // And specify a time in seconds to pause for (30 secs)
    $mailer->registerPlugin(new Swift_Plugins_AntiFloodPlugin(10, 5));

    foreach($users as $user)
    {
        generate_report($user, $round);
        // Setup the email
        $smarty->assign('user', $user);
        $body = $smarty->fetch('email/end_round.tpl');
        send_mail(_('Feedback round ended'), ADMIN_EMAIL, $user->email, $body, true);
    }

    $message =  _('Round ended');
    flash('success', $message);
    redirect_to(ADMIN_URI . 'round');
}

function validate_round_form($count_users)
{
    if($_POST['total_amount_to_review'] == '')
    {
        // If total amount to review isn't set, take total amount of users in organisation
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
    $form_values['closing_date']['value'] = $_POST['closing_date'];
    $form_values['total_amount_to_review']['value'] = $total_amount_to_review;
    $form_values['own_amount_to_review']['value'] = $own_amount_to_review;
    $form_values['min_reviewed_by']['value'] = $min_reviewed_by;
    $form_values['min_to_review']['value'] = $min_to_review;

    if(empty($_POST['description']))
    {
        $form_values['description']['error'] = _('Round description can\'t be empty!');
    }

    if(!empty($_POST['closing_date']))
    {
        $current_datetime = new DateTime(null, new DateTimeZone(date_default_timezone_get()));
        $current_datetime = $current_datetime->format('Y-m-d H:i:s');

        $closing_date = new DateTime(englishify_date($form_values['closing_date']['value']), new DateTimeZone(date_default_timezone_get()));
        $closing_date = $closing_date->format('Y-m-d H:i:s');

        if($closing_date < $current_datetime)
        {
            $form_values['closing_date']['error'] = _('Closing date can\'t be in the past');
        }
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

function validate_edit_round_form($count_users, $round)
{
    if($_POST['min_reviewed_by'] == '')
    {
        // If minimum to be reviewed by isn't set, take 50% of total amount amount to review
        $min_reviewed_by = ceil($round->total_to_review * 0.50);
    }
    else
    {
        $min_reviewed_by = intval($_POST['min_reviewed_by']);
    }

    if($_POST['min_to_review'] == '')
    {
        // If minimum to review isn't set, take 50% of total amount to review
        $min_to_review = ceil($round->total_to_review  * 0.50);
    }
    else
    {
        $min_to_review = intval($_POST['min_to_review']);
    }

    $form_values = array();
    $form_values['description']['value'] = $_POST['description'];
    $form_values['closing_date']['value'] = englishify_date($_POST['closing_date']);
    $form_values['min_reviewed_by']['value'] = $min_reviewed_by;
    $form_values['min_to_review']['value'] = $min_to_review;

    if(empty($_POST['description']))
    {
        $form_values['description']['error'] = _('Round description can\'t be empty!');
    }

    if(!empty($_POST['closing_date']))
    {
        $current_datetime = new DateTime(null, new DateTimeZone(date_default_timezone_get()));
        $current_datetime = $current_datetime->format('Y-m-d H:00:00');

        $closing_date = new DateTime($form_values['closing_date']['value'], new DateTimeZone(date_default_timezone_get()));
        $closing_date = $closing_date->format('Y-m-d H:00:00');

        if($closing_date < $current_datetime)
        {
            $form_values['closing_date']['error'] = _('Closing date can\'t be in the past');
        }
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
