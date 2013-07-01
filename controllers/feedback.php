<?php

const MINUTES = 60;
const HOURS = 3600;

function edit_feedback()
{
    security_authorize();

    $roundinfo = R::findOne('roundinfo', 'reviewer_id = ? AND reviewee_id = ? AND round_id = ? AND status = ?', array($_SESSION['current_user']->id, params('id'), get_current_round()->id, REVIEW_COMPLETED));

    if($roundinfo->id == 0)
    {
        $message = _('Can\'t view this person');
        flash('error', $message);
        redirect_to('feedback');
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
        $message = _('Can\'t edit this feedback! Error with round info!');
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
            $message = _('Can\'t edit this feedback! Error with reviews!');
            flash('error', $message);
            redirect_to('feedback/edit/' . params('id'));
        }

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

    $roundinfo = R::find('roundinfo', 'reviewer_id = ? AND round_id = ?', array($_SESSION['current_user']->id, get_current_round()->id));
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
    $smarty->assign('roundinfo', $roundinfo);

    return html($smarty->fetch('feedback/feedback_overview.tpl'));
}

function feedback_step_1()
{
    security_authorize();

    if(get_current_round()->id == 0)
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
        unset($_SESSION['positive_competencies']);
        unset($_SESSION['negative_competencies']);
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

    $competencygroups = array();
    $competencygroups[] = get_general_competencies();
    $competencygroups[] = $reviewee->role->competencygroup;

    foreach($competencygroups as $competencygroup)
    {
        foreach($competencygroup->ownCompetency as $competency)
        {
            if(in_array($competency->id, $_SESSION['positive_competencies']))
            {
                $competency->in_session = true;
            }
        }
    }

    global $smarty;
    $smarty->assign('reviewee', $reviewee);
    $smarty->assign('competencygroups', $competencygroups);
    $smarty->assign('step', 1);
    set('title', _('Feedback step 1'));

    return html($smarty->fetch('feedback/feedback.tpl'));
}

function feedback_step_1_post()
{
    security_authorize();

    if(isset($_POST['competencies']) && count($_POST['competencies']) == 3)
    {
        $_SESSION['positive_competencies'] = $_POST['competencies'];
        redirect_to('feedback/' . params('id') . '/2');
    }
    else
    {
        $message = _('Error! Must select 3 competencies.');
        flash('error', $message);
        redirect_to('feedback/' . params('id'));
    }
}

function feedback_step_2()
{
    security_authorize();

    if(!isset($_SESSION['positive_competencies']))
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

    $competencygroups = array();
    $competencygroups[] = get_general_competencies();
    $competencygroups[] = $reviewee->role->competencygroup;

    $positive_competencies = $_SESSION['positive_competencies'];

    foreach($competencygroups as $competencygroup)
    {
        foreach($competencygroup->ownCompetency as $competency)
        {
            if(in_array($competency->id, $positive_competencies))
            {
                unset($competencygroup->ownCompetency[$competency->id]);
            }
            else if(in_array($competency->id, $_SESSION['negative_competencies']))
            {
                $competency->in_session = true;
            }
        }
    }

    global $smarty;
    $smarty->assign('reviewee', $reviewee);
    $smarty->assign('competencygroups',  $competencygroups);
    $smarty->assign('step', 2);
    set('title', _('Feedback step 2'));

    return html($smarty->fetch('feedback/feedback.tpl'));
}

function feedback_step_2_post()
{
    security_authorize();

    if(isset($_POST['competencies']) && count($_POST['competencies']) == 2)
    {
        $_SESSION['negative_competencies'] = $_POST['competencies'];
        redirect_to('feedback/' . params('id') . '/3');
    }
    else
    {
        $message = _('Error! Must select 2 competencies.');
        flash('error', $message);
        redirect_to('feedback/' . params('id') . '/2');
    }
}

function feedback_step_3()
{
    security_authorize();

    if(!isset($_SESSION['positive_competencies']) || !isset($_SESSION['negative_competencies']))
    {
        $message = _('Step 1 and 2 have to be completed first!');
        flash('error', $message);
        redirect_to('feedback' . params('id') . '/2');
    }

    $reviewee = R::load('user', params('id'));

    if($reviewee->id == 0)
    {
        $message = sprintf(BEAN_NOT_FOUND, ('user'));
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

    $positive_competencies = R::batch('competency', $_SESSION['positive_competencies']);
    $negative_competencies = R::batch('competency', $_SESSION['negative_competencies']);

    global $smarty;
    $smarty->assign('reviewee', $reviewee);
    $smarty->assign('positive_competencies', $positive_competencies);
    $smarty->assign('negative_competencies', $negative_competencies);
    $smarty->assign('step', 3);

    // Make sure you divide by the right constant (either MINUTES OR HOURS) depending on what you want to display
    $smarty->assign('session_lifetime', ini_get('session.gc_maxlifetime') / MINUTES);

    // Make sure you edit this text to match the session_lifetime Smarty variable
    $smarty->assign('time_text', _('minutes'));

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

    $count = 0;

    foreach($_POST['positive_competencies'] as $form_competency)
    {
        if(!empty($form_competency['rating']))
        {
            if($form_competency['rating'] >= 3 && $form_competency['rating'] <= 5 && $form_competency['is_positive'] == 1)
            {
                $count++;
            }
        }
    }

    $has_errors = false;
    global $smarty;

    // If there aren't 3 positive competencies, return an error
    if($count != 3)
    {
        $smarty->assign('error_positive_competencies', _('Positive competencies error!'));

        $has_errors = true;
    }

    $count = 0;

    foreach($_POST['negative_competencies'] as $form_competency)
    {
        if(!empty($form_competency['rating']))
        {
            if($form_competency['rating'] >= 1 && $form_competency['rating'] <= 3 && $form_competency['is_positive'] == 0)
            {
                $count++;
            }
        }
    }

    // If there aren't 2 points of improvement, return an error
    if($count != 2)
    {
        $smarty->assign('error_negative_competencies', _('Points of improvement error!'));

        $has_errors = true;
    }

    if($has_errors)
    {
        return feedback_step_3();
    }

    $reviews = R::dispense('review', 5);
    $round = R::load('round', get_current_round()->id);

    $competencies = array_merge($_POST['positive_competencies'], $_POST['negative_competencies']);

    $index = 0;
    foreach($competencies as $form_competency)
    {
        if($form_competency['rating'] < 1 or $form_competency['rating'] > 5)
        {
            $message = _('Ratings must be higher than 1 and lower than 5!');
            flash('error', $message);
            redirect_to('feedback/' . params('id') . '/3');
        }

        $competency = R::findOne('competency', 'id = ? AND (competencygroup_id = ? OR competencygroup_id = ?)', array($form_competency['id'], $reviewee->role->competencygroup_id, get_general_competencies()->id));

        if($competency->id == 0)
        {
            $message = _('An error has occurred regarding competencies!');
            flash('error', $message);
            redirect_to('feedback/' . params('id') . '/3');
        }

        $rating = R::load('rating', $form_competency['rating']);

        if($rating->id == 0)
        {
            $message = _('An error has occurred regarding ratings!');
            flash('error', $message);
            redirect_to('feedback/' . params('id') . '/3');
        }

        $reviews[$index]->reviewer = $current_user;
        $reviews[$index]->reviewee = $reviewee;
        $reviews[$index]->competency = $competency;
        $reviews[$index]->rating = $rating;
        $reviews[$index]->comment = nl2br_fixed($form_competency['comment']);
        $reviews[$index]->round = $round;
        $reviews[$index]->is_positive = $form_competency['is_positive'];
        $index++;
    }

    $roundinfo->status = 1;
    $roundinfo->answer = nl2br_fixed($_POST['extra_question']);

    R::store($roundinfo);
    R::storeAll($reviews);

    $message = sprintf(MESSAGE_REVIEW_SUCCESS, $reviewee->firstname, $reviewee->lastname);
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
        redirect_to('feedback/' . params('id'));
    }
    else if($reviewee->department_id == $_SESSION['current_user']->id)
    {
        $message = _('Can\'t skip someone of your own department');
        flash('error', $message);
        redirect_to('feedback/' . params('id'));
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

    $roundinfo = R::dispense('roundinfo');
    $roundinfo->status = 0;
    $roundinfo->answer = '';
    $roundinfo->round = get_current_round();
    $roundinfo->reviewer = $_SESSION['current_user'];
    $roundinfo->reviewee = R::load('user', array_rand($reviewees));

    R::store($roundinfo);

    redirect_to('feedback');
}

function nl2br_fixed($string)
{
    $string = str_replace(array("\r\n", "\r", "\n"), "<br />", $string);
    return $string;
}
