<?php

const MINUTES = 60;
const HOURS = 3600;

function edit_feedback()
{
    security_authorize();

    $roundinfo = R::findOne('roundinfo', 'reviewer_id = ? AND reviewee_id = ? AND round_id = ? AND status = ?', array($_SESSION['current_user']->id, params('id'), get_current_round()->id, REVIEW_COMPLETED));

    if($roundinfo->id == 0)
    {
        halt(NOT_FOUND);
    }

    $reviews = R::find('review', 'reviewer_id = ? AND reviewee_id = ? AND round_id = ?', array($_SESSION['current_user']->id, params('id'), get_current_round()->id));

    global $smarty;
    $smarty->assign('roundinfo', $roundinfo);
    $smarty->assign('reviews', $reviews);
    $smarty->assign('reviewee', R::load('user', params('id')));

    return html($smarty->fetch('feedback/edit_feedback.tpl'));
}

function edit_feedback_post()
{
    security_authorize();

    $reviewee = R::load('user', params('id'));
    $current_round = get_current_round();

    $roundinfo = R::findOne('roundinfo', 'reviewer_id = ? AND reviewee_id = ? AND round_id = ? AND status = ?', array($_SESSION['current_user']->id, $reviewee->id, $current_round->id, REVIEW_COMPLETED));

    if($roundinfo->id == 0)
    {
        $message = _('Can\'t edit this feedback! Error loading the round info!');
        flash('error', $message);
        redirect_to('feedback/edit/' . params('id'));
    }

    // The standard nl2br function of PHP isn't working like it should (it's still leaving in the newlines), so that's why I'm using a custom function.
    $roundinfo->answer = nl2br_fixed($_POST['roundinfo']['answer']);

    $reviews = array();

    foreach($_POST['reviews'] as $review_row)
    {
        $review = R::findOne('review', 'id = ? AND reviewer_id = ? AND reviewee_id = ? AND round_id = ?', array($review_row['id'], $_SESSION['current_user']->id, $reviewee->id, $current_round->id));

        if($review->id == 0)
        {
            $message = _('Can\'t edit this feedback! Error loading the reviews!');
            flash('error', $message);
            redirect_to('feedback/edit/' . params('id'));
        }

        // The standard nl2br function of PHP isn't working like it should (it's still leaving in the newlines), so that's why I'm using a custom function.
        $review->comment = nl2br_fixed($review_row['comment']);
        $reviews[] = $review;
    }

    R::storeAll($reviews);
    R::store($roundinfo);

    $message = sprintf(_('Your review for %s %s has been edited'), $reviewee->firstname, $reviewee->lastname);
    flash('success', $message);
    redirect_to('feedback');
}

function view_feedback_overview()
{
    security_authorize();

    $round = get_current_round();

    $roundinfo = R::find('roundinfo', 'reviewer_id = ? AND round_id = ? AND status != ?', array($_SESSION['current_user']->id, $round->id, REVIEW_SKIPPED));
    R::preload($roundinfo, array('reviewee' => 'user'));

    foreach($roundinfo as $id => $info)
    {
        if($info->reviewee->status == 0)
        {
            // Remove a user from the list if they shouldn't be reviewed (status = paused)
            unset($roundinfo[$id]);
        }
    }

    global $smarty;

    if(count($roundinfo) < $round->total_to_review)
    {
        $skipped_roundinfo = R::find('roundinfo', 'reviewer_id = ? AND round_id = ? AND status = ?', array($_SESSION['current_user']->id, $round->id, REVIEW_SKIPPED));
        R::preload($skipped_roundinfo, array('reviewee' => 'user'));

        $smarty->assign('skipped_roundinfo', $skipped_roundinfo);
    }

    $smarty->assign('current_round', $round);
    $smarty->assign('roundinfo', $roundinfo);

    return html($smarty->fetch('feedback/feedback_overview.tpl'));
}

function feedback_step_1()
{
    security_authorize();

    $round = get_current_round();
    if($round->id == 0)
    {
        $message = _('No round in progress!');
        flash('error', $message);
        redirect_to('feedback');
    }

    $reviewee = R::load('user', params('id'));

    if($reviewee->id == 0)
    {
        $message = sprintf(BEAN_NOT_FOUND, ('user'));
        flash('error', $message);
        redirect_to('feedback');
    }

    // We don't want the competencies we selected for the last person to be set for the next one, so clear them
    if($_SESSION['current_reviewee_id'] != $reviewee->id)
    {
        unset($_SESSION['competencies']);
        unset($_SESSION['no_competencies_comment']);
        unset($_SESSION['agreements']);
        $_SESSION['current_reviewee_id'] = $reviewee->id;
    }

    $roundinfo = R::findOne('roundinfo', 'reviewee_id = ? AND reviewer_id = ? AND round_id = ? AND status = ?', array($reviewee->id, $_SESSION['current_user']->id, get_current_round()->id, REVIEW_IN_PROGRESS));

    if($roundinfo->id == 0)
    {
        $message = _('You can\'t review this person!');
        flash('error', $message);
        redirect_to('feedback');
    }

    if($roundinfo->status == 1)
    {
        $message = _('Already reviewed this person!');
        flash('error', $message);
        redirect_to('feedback');
    }

    $competencygroup = get_general_competencies();

    global $smarty;
    $smarty->assign('reviewee', $reviewee);
    $smarty->assign('competencygroup', $competencygroup);
    $smarty->assign('step', 1);
    $smarty->assign('step_text', sprintf(_('Step %d of 3'), 1));

    $feedback_header = _('Select 2 positive competencies and 1 points of improvement for ');

    if($reviewee->id == $_SESSION['current_user']->id)
    {
        $feedback_header .= _('yourself');
    }
    else
    {
        $feedback_header .=  $reviewee->firstname . ' ' . $reviewee->lastname;
    }

    // Make sure you divide by the right constant (either MINUTES OR HOURS) depending on what you want to display
    $smarty->assign('session_lifetime', ini_get('session.gc_maxlifetime') / MINUTES);

    // Make sure you edit this text to match the session_lifetime Smarty variable
    $smarty->assign('time_text', _('minutes'));

    $smarty->assign('feedback_header', $feedback_header);
    $smarty->assign('form_action_url', '/' . $reviewee->id);

    return html($smarty->fetch('feedback/feedback.tpl'));
}

function feedback_step_1_post()
{
    security_authorize();

    $count_positive = 0;
    $count_negative = 0;
    $count_comments = 0;
    $competencies = array();

    foreach($_POST['competencies'] as $competency_id => $competency)
    {
        if($competency['value'] == 1)
        {
            $count_positive += 1;
            $competencies[$competency_id] = $competency;
        }
        else if($competency['value'] == 2)
        {
            $count_negative += 1;
            $competencies[$competency_id] = $competency;
        }

        $competency_comment = trim($competency['comment']);

        if(!empty($competency_comment))
        {
            $count_comments += 1;
        }
    }

    $_SESSION['competencies'][1] = $competencies;

    if($count_positive == 2 && $count_negative == 1 && $count_comments == 3)
    {
        redirect_to('feedback/' . params('id') . '/2');
    }
    else
    {
        $message = _('Must select 3 competencies and provide a comment for each competency.');
        flash('error', $message);
        redirect_to('feedback/' . params('id'));
    }
}

function feedback_step_2()
{
    security_authorize();

    if(empty($_SESSION['competencies'][1]))
    {
        $message = _('Step 1 has to be completed first!');
        flash('error', $message);
        redirect_to('feedback/' . params('id'));
    }

    $reviewee = R::load('user', params('id'));

    if($reviewee->id == 0)
    {
        $message = sprintf(BEAN_NOT_FOUND, _('user'));
        flash('error', $message);
        redirect_to('feedback');
    }

    $roundinfo = R::findOne('roundinfo', 'reviewee_id = ? AND reviewer_id = ? AND round_id = ? AND status = ?', array($reviewee->id, $_SESSION['current_user']->id, get_current_round()->id, REVIEW_IN_PROGRESS));

    if($roundinfo->id == 0)
    {
        $message = _('You can\'t review this person!');
        flash('error', $message);
        redirect_to('feedback');
    }

    $competencygroup = $reviewee->role->competencygroup;
    $agreements = R::findOne('agreements', 'user_id = ?', array($reviewee->id));

    global $smarty;
    $smarty->assign('reviewee', $reviewee);

    if($reviewee->department_id == $_SESSION['current_user']->department_id)
    {
        $smarty->assign('competencygroup',  $competencygroup);
    }

    $smarty->assign('agreements',  $agreements);
    $smarty->assign('step', 2);
    $smarty->assign('step_text', sprintf(_('Step %d of 3'), 2));

    $feedback_header = _('Select 2 positive competencies and 1 points of improvement for ');

    if($reviewee->id == $_SESSION['current_user']->id)
    {
        $feedback_header .= _('yourself');
    }
    else
    {
        $feedback_header .=  $reviewee->firstname . ' ' . $reviewee->lastname;
    }

    $smarty->assign('feedback_header', $feedback_header);
    $smarty->assign('form_action_url', '/' . $reviewee->id . '/2');

    set('title', _('Feedback step 2'));

    return html($smarty->fetch('feedback/feedback.tpl'));
}

function feedback_step_2_post()
{
    security_authorize();

    $reviewee = R::load('user', params('id'));

    $count_positive = 0;
    $count_negative = 0;
    $count_comments = 0;
    $competencies = array();
    $agreement_error = false;

    if($reviewee->department_id == $_SESSION['current_user']->department_id)
    {
        foreach($_POST['competencies'] as $competency_id => $competency)
        {
            if($competency['value'] == 1)
            {
                $count_positive += 1;
                $competencies[$competency_id] = $competency;
            }
            else if($competency['value'] == 2)
            {
                $count_negative += 1;
                $competencies[$competency_id] = $competency;
            }

            $competency_comment = trim($competency['comment']);

            if(!empty($competency_comment))
            {
                $count_comments += 1;
            }
        }

        $_SESSION['competencies'][2] = $competencies;

        if($count_positive != 2 || $count_negative != 1 || $count_comments != 3)
        {
            $message = _('Must select 3 competencies and provide a comment');
            flash('error', $message);
            redirect_to('feedback/' . params('id') . '/2');
        }
    }

    $agreements = $_POST['agreements'];
    $_SESSION['agreements'] = $agreements;

    foreach($agreements as $agreement)
    {
        if($agreement['value'] != 0 && empty($agreement['comment']))
        {
            $agreement_error = true;
        }
    }

    if($agreement_error)
    {
        $message = _('Must provide a comment when reviewing agreements');
        flash('error', $message);
        redirect_to('feedback/' . params('id') . '/2');
    }

    redirect_to('feedback/' . $reviewee->id . '/3');
}

function feedback_step_3()
{
    security_authorize();

    $reviewee = R::load('user', params('id'));

    if($reviewee->id == 0)
    {
        $message = sprintf(BEAN_NOT_FOUND, ('user'));
        flash('error', $message);
        redirect_to('feedback');
    }

    if($reviewee->department_id == $_SESSION['current_user']->department_id)
    {
        if(count($_SESSION['competencies'][1]) + count($_SESSION['competencies'][2]) != 6)
        {
            $message = _('Step 1 and 2 have to be completed first!');
            flash('error', $message);
            redirect_to('feedback/' . params('id') . '/2');
        }
    }
    else
    {
        if(empty($_SESSION['competencies'][1]) || count($_SESSION['competencies'][1]) != 3)
        {
            $message = _('Step 1 has to be completed first!');
            flash('error', $message);
            redirect_to('feedback/' . params('id'));
        }
    }

    $roundinfo = R::findOne('roundinfo', 'reviewee_id = ? AND reviewer_id = ? AND round_id = ? AND status = ?', array($reviewee->id, $_SESSION['current_user']->id, get_current_round()->id, REVIEW_IN_PROGRESS));

    if($roundinfo->id == 0)
    {
        halt(NOT_FOUND);
    }

    global $smarty;
    $smarty->assign('reviewee', $reviewee);
    $smarty->assign('step', 3);
    $smarty->assign('step_text', sprintf(_('Step %d of 3'), 3));

    set('title', 'Feedback step 3');

    return html($smarty->fetch('feedback/feedback_form.tpl'));
}

function feedback_step_3_post()
{
    security_authorize();

    $current_user = $_SESSION['current_user'];
    $reviewee = R::load('user', params('id'));
    $roundinfo = R::findOne('roundinfo', 'reviewer_id = ? AND reviewee_id = ? AND round_id = ?', array($current_user->id, $reviewee->id, get_current_round()->id));

    if($roundinfo->id == 0)
    {
        return feedback_step_3();
    }

    if($reviewee->department_id == $_SESSION['current_user']->department_id)
    {
        if(empty($_SESSION['competencies'][2]) && !empty($_SESSION['no_competencies_comment']))
        {
            $reviews = R::dispense('review', 3);
        }
        else
        {
            $reviews = R::dispense('review', 6);
        }
    }
    else
    {
        $reviews = R::dispense('review', 3);
    }

    $index = 0;
    $round = get_current_round();

    $competencies_step_1 = $_SESSION['competencies'][1];
    $competencies_step_2 = $_SESSION['competencies'][2];
    $competencies = $competencies_step_1;

    if(is_array($competencies_step_2))
    {
        $competencies += $competencies_step_2;
    }

    foreach($competencies as $key => $form_competency)
    {
        $competency = R::findOne('competency', 'id = ? AND (competencygroup_id = ? OR competencygroup_id = ?)', array($key, $reviewee->role->competencygroup_id, get_general_competencies()->id));

        if($competency->id == 0)
        {
            halt(SERVER_ERROR);
        }

        $reviews[$index]->reviewer = $current_user;
        $reviews[$index]->reviewee = $reviewee;
        $reviews[$index]->competency = $competency;
        $reviews[$index]->selection = $form_competency['value'];
        // The standard nl2br function of PHP isn't working like it should (it's still leaving in the newlines), so that's why I'm using a custom function.
        $reviews[$index]->comment = nl2br_fixed($form_competency['comment']);
        $reviews[$index]->round = $round;
        $index++;
    }

    $roundinfo->status = 1;
    // The standard nl2br function of PHP isn't working like it should (it's still leaving in the newlines), so that's why I'm using a custom function.
    $roundinfo->answer = nl2br_fixed($_POST['extra_question']);

    $agreements = $_SESSION['agreements'];
    $agreement_reviews = array();

    foreach($agreements as $agreement_type => $agreement)
    {
        if($agreement['value'] == 1 || $agreement['value'] == 2)
        {
            $agreement_review = R::dispense('agreementreview');

            $agreement_review->type = $agreement_type;
            $agreement_review->selection = $agreement['value'];
            $agreement_review->comment = $agreement['comment'];
            $agreement_review->reviewee = $reviewee;
            $agreement_review->reviewer = $current_user;

            $agreement_reviews[] = $agreement_review;
        }
    }

    R::store($roundinfo);
    R::storeAll($reviews);
    R::storeAll($agreement_reviews);

    // Clear form session
    unset($_SESSION['competencies']);
    unset($_SESSION['no_competencies_comment']);
    unset($_SESSION['agreements']);

    if($reviewee->id == $current_user->id)
    {
        redirect_to('feedback/meeting');
    }
    else
    {
        $message = sprintf(_('Your review for %s %s has been saved'), $reviewee->firstname, $reviewee->lastname);
        flash('success', $message);

        redirect_to('feedback');
    }
}

function feedback_meeting()
{
    security_authorize();

    $current_user = $_SESSION['current_user'];

    if($current_user->id == 0)
    {
        redirect_to('feedback');
    }

    $meeting = R::findOne('meeting', 'user_id = ?', array($current_user->id));

    global $smarty;

    $smarty->assign('meeting', $meeting);

    return html($smarty->fetch('feedback/feedback_meeting.tpl'));
}

function feedback_meeting_post()
{
    security_authorize();

    $current_user = $_SESSION['current_user'];

    if($current_user->id == 0)
    {
        redirect_to('feedback');
    }

    $choice = $_POST['meeting_choice'];

    if($choice == 1)
    {
        $meeting = R::findOne('meeting', 'user_id = ?', array($current_user->id));

        if($meeting->id == 0)
        {
            $meeting = R::dispense('meeting');
        }

        $meeting->name = $_POST['name'];
        $meeting->subject = $_POST['subject'];
        $meeting->user = $current_user;

        R::store($meeting);
    }
    elseif($choice == 0)
    {
        $meeting = R::findOne('meeting', 'user_id = ?', array($current_user->id));

        if($meeting->id != 0)
        {
            R::trash($meeting);
        }
    }

    $message = _('Your choice has been saved.');
    flash('success', $message);
    redirect_to('feedback');
}

function skip_confirmation()
{
    security_authorize();

    $reviewee = R::load('user', params('id'));

    if($reviewee->id == 0)
    {
        $message = sprintf(BEAN_NOT_FOUND, _('user'));
        flash('error', $message);
        redirect_to('feedback');
    }
    else if($reviewee->id == $_SESSION['current_user']->id)
    {
        $message = _('Can\'t skip yourself!');
        flash('error', $message);
        redirect_to('feedback');
    }
    else if($reviewee->department_id == $_SESSION['current_user']->department_id)
    {
        $message = _('Can\'t skip someone of your own department');
        flash('error', $message);
        redirect_to('feedback');
    }

    global $smarty;
    $smarty->assign('page_header', _('Skip person'));
    $smarty->assign('reviewee', $reviewee);

    return html($smarty->fetch('feedback/skip_confirmation.tpl'));
}

function skip_person()
{
    if(!isset($_POST['reviewee_id']))
    {
        $message = _('No user was given');
        flash('error', $message);
        redirect_to('feedback');
    }

    $reviewee = R::load('user', $_POST['reviewee_id']);

    if($reviewee->id == 0)
    {
        $message = sprintf(BEAN_NOT_FOUND, _('user'));
        flash('error', $message);
        redirect_to('feedback');
    }

    if($reviewee->department->id == $_SESSION['current_user']->department->id)
    {
        $message = _('This user can\'t be skipped');
        flash('error', $message);
        redirect_to('feedback/' . params('id'));
    }

    $roundinfo = R::findOne('roundinfo', 'reviewer_id = ? AND reviewee_id = ? AND round_id = ?', array($_SESSION['current_user']->id, $reviewee->id, get_current_round()->id));

    if($roundinfo->id == 0)
    {
        $message = _('Invalid input');
        flash('error', $message);
        redirect_to('feedback');
    }

    // Set status to skipped, but keep in database
    $roundinfo->status = REVIEW_SKIPPED;

    R::store($roundinfo);

    $reviewees = R::find('user', 'department_id != ? AND status != ?', array($_SESSION['current_user']->department_id, PAUSE_USER_REVIEWS));

    foreach($reviewees as $id => $reviewee)
    {
        $roundinfo = R::find('roundinfo', 'reviewer_id = ? AND reviewee_id = ? AND round_id = ?', array($_SESSION['current_user']->id, $reviewee->id, get_current_round()->id));

        if($roundinfo->id != 0 || !empty($roundinfo))
        {
            // If roundinfo with $reviewer and $reviewee already exists, remove this person from the list of potential reviewees
            unset($reviewees[$id]);
        }
    }

    if(!empty($reviewees))
    {
        $roundinfo = R::dispense('roundinfo');
        $roundinfo->status = 0;
        $roundinfo->answer = '';
        $roundinfo->round = get_current_round();
        $roundinfo->reviewer = $_SESSION['current_user'];
        $roundinfo->reviewee = R::load('user', array_rand($reviewees));

        R::store($roundinfo);
    }

    redirect_to('feedback');
}

function add_to_reviewees()
{
    security_authorize();

    if(!empty($_POST['skipped']))
    {
        foreach($_POST['skipped'] as $skipped)
        {
            $roundinfo = R::findOne('roundinfo', 'reviewer_id = ? AND reviewee_id = ? AND round_id = ? AND status = ?', array($_SESSION['current_user']->id, $skipped, get_current_round()->id, REVIEW_SKIPPED));

            if($roundinfo != 0)
            {
                $roundinfo->status = REVIEW_IN_PROGRESS;

                R::store($roundinfo);
            }
        }
    }

    redirect_to('feedback');
}

function nl2br_fixed($string)
{
    $string = str_replace(array("\r\n", "\r", "\n"), "<br />", $string);
    return $string;
}
