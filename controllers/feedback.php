<?php

const MINUTES = 60;
const HOURS = 3600;

function edit_feedback()
{
    security_authorize();

    $roundinfo = R::findOne('roundinfo', 'reviewer_id = ? AND round_id = ? AND reviewee_id = ? AND status = ?', array($_SESSION['current_user']->id, get_current_round()->id, params('id'), REVIEW_COMPLETED));

    if($roundinfo->id == 0)
    {
        return html('Can\'t view this person!');
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
        return html('Can\'t edit this feedback! Error with round info!');
    }

    $roundinfo->answer = $_POST['roundinfo']['answer'];

    $reviews = array();

    foreach($_POST['reviews'] as $review_row)
    {
        $review = R::findOne('review', 'id = ? AND reviewer_id = ? AND reviewee_id = ? AND round_id = ?', array($review_row['id'], $_SESSION['current_user']->id, $reviewee->id, $current_round->id));

        if($review->id == 0)
        {
            return html('Can\'t edit this feedback! Error with reviews!');
        }

        $review->comment = $review_row['comment'];

        $reviews[] = $review;
    }

    R::storeAll($reviews);
    R::store($roundinfo);

    header('Location: ' . BASE_URI . 'feedback?success=' . sprintf(MESSAGE_REVIEW_SUCCESS, $reviewee->firstname, $reviewee->lastname));
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
            // Remove a user from the list if they should be reviewed (status = paused)
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
        return html('No round in progress!');
    }

    $reviewee = R::load('user', params('id'));

    if($reviewee->id == 0)
    {
        return html('User not found!');
    }

    $roundinfo = R::findOne('roundinfo', 'reviewee_id = ? AND reviewer_id = ? AND round_id = ?', array($reviewee->id, $_SESSION['current_user']->id, get_current_round()->id));

    if($roundinfo->id == 0)
    {
        return html('You can\'t review this person!');
    }

    if($roundinfo->status == 1)
    {
        return html('Already reviewed this person!');
    }

    $competencygroups = array();
    $competencygroups[] = get_general_competencies();
    $competencygroups[] = $reviewee->role->competencygroup;

    global $smarty;
    $smarty->assign('reviewee', $reviewee);
    $smarty->assign('competencygroups', $competencygroups);
    $smarty->assign('step', 1);
    set('title', 'Feedback step 1');

    return html($smarty->fetch('feedback/feedback.tpl'));
}

function feedback_step_1_post()
{
    security_authorize();

    if(isset($_POST['competencies']) && count($_POST['competencies']) == 3)
    {
        $_SESSION['positive_competencies'] = $_POST['competencies'];
        header('Location: ' . BASE_URI . 'feedback/' . params('id') . '/2');
    }
    else
    {
        return html('Error! Must select 3 competencies.');
    }
}

function feedback_step_2()
{
    security_authorize();

    if(!isset($_SESSION['positive_competencies']))
    {
        return html('Step 1 has to be completed first!');
    }

    $reviewee = R::load('user', params('id'));

    if($reviewee->id == 0)
    {
        return html('User not found!');
    }

    $competencygroups = array();
    $competencygroups[] = get_general_competencies();
    $competencygroups[] = $reviewee->role->competencygroup;

    $positive_competencies = $_SESSION['positive_competencies'];

    foreach($competencygroups as $competencygroup)
    {
        foreach($competencygroup->ownCompetency as $id => $competency)
        {
            if(in_array($id, $positive_competencies))
            {
                unset($competencygroup->ownCompetency[$id]);
            }
        }
    }

    global $smarty;
    $smarty->assign('reviewee', $reviewee);
    $smarty->assign('competencygroups',  $competencygroups);
    $smarty->assign('step', 2);
    set('title', 'Feedback step 2');

    return html($smarty->fetch('feedback/feedback.tpl'));
}

function feedback_step_2_post()
{
    security_authorize();

    if(isset($_POST['competencies']) && count($_POST['competencies']) == 2)
    {
        $_SESSION['negative_competencies'] = $_POST['competencies'];
        header('Location:  ' . BASE_URI . 'feedback/' . params('id') . '/3');
    }
    else
    {
        return html('Error! Must select 2 competencies.');
    }
}

function feedback_step_3()
{
    security_authorize();

    if(!isset($_SESSION['positive_competencies']) || !isset($_SESSION['negative_competencies']))
    {
        return html('Step 1 and 2 have to be completed first!');
    }

    $reviewee = R::load('user', params('id'));

    if($reviewee->id == 0)
    {
        return html('User not found!');
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
    set('title', 'Feedback step 3');

    return html($smarty->fetch('feedback/feedback_form.tpl'));
}

function feedback_step_3_post()
{
    security_authorize();

    $count = 0;
    foreach($_POST['positive_competencies'] as $form_competency)
    {
        if(isset($form_competency['rating']) && !empty($form_competency['rating']))
        {
            if($form_competency['rating'] >= 3 && $form_competency['rating'] <= 5 && $form_competency['is_positive'] == 1)
            {
                $count++;
            }
        }
    }

    $has_errors = false;

    if($count != 3)
    {
        global $smarty;
        $smarty->assign('error_positive_competencies', 'Positive competencies error!');

        $has_errors = true;
    }

    $count = 0;
    foreach($_POST['negative_competencies'] as $form_competency)
    {
        if(isset($form_competency['rating']) && !empty($form_competency['rating']))
        {
            if($form_competency['rating'] >= 1 && $form_competency['rating'] <= 3 && $form_competency['is_positive'] == 0)
            {
                $count++;
            }
        }
    }

    if($count != 2)
    {
        global $smarty;
        $smarty->assign('error_negative_competencies', 'Points of improvement error!');

        $has_errors = true;
    }

    if($has_errors)
    {
        return feedback_step_3();
    }

    $reviews = R::dispense('review', 5);

    $current_user = $_SESSION['current_user'];
    $reviewee = R::load('user', params('id'));
    $round = R::load('round', get_current_round()->id);

    $competencies = array_merge($_POST['positive_competencies'], $_POST['negative_competencies']);

    $index = 0;
    foreach($competencies as $form_competency)
    {
        if($form_competency['rating'] < 1 or $form_competency['rating'] > 5)
        {
            return html('Ratings must be higher than 1 and lower than 5! <a href="javascript:history.go(-1);">Click here to go back</a>');
        }

        $competency = R::load('competency', $form_competency['id']);

        if($competency->id == 0)
        {
            return html('An error has occurred regarding competencies! <a href="javascript:history.go(-1);">Click here to go back</a>');
        }

        $rating = R::load('rating', $form_competency['rating']);

        if($rating->id == 0)
        {
            return html('An error has occurred regarding ratings! <a href="javascript:history.go(-1);">Click here to go back</a>');
        }

        $reviews[$index]->reviewer = $current_user;
        $reviews[$index]->reviewee = $reviewee;
        $reviews[$index]->competency = $competency;
        $reviews[$index]->rating = $rating;
        $reviews[$index]->comment = $form_competency['comment'];
        $reviews[$index]->round = $round;
        $reviews[$index]->is_positive = $form_competency['is_positive'];
        $index++;
    }

    $roundinfo = R::findOne('roundinfo', 'reviewer_id = ? AND reviewee_id = ? AND round_id = ?', array($current_user->id, $reviewee->id, get_current_round()->id));
    if(!isset($roundinfo))
    {
        $roundinfo = R::dispense('roundinfo');
        $roundinfo->reviewee = $reviewee;
        $roundinfo->reviewer = $current_user;
        $roundinfo->round = $round;
    }

    $roundinfo->status = 1;
    $roundinfo->answer = $_POST['extra_question'];

    R::store($roundinfo);
    R::storeAll($reviews);

    header('Location: ' . BASE_URI . 'feedback?success=' . sprintf(MESSAGE_REVIEW_SUCCESS, $reviewee->firstname, $reviewee->lastname));
}

function skip_confirmation()
{
    security_authorize();

    $reviewee = R::load('user', params('id'));

    if($reviewee->id == 0)
    {
        return html('User not found');
    }
    else if($reviewee->id == $_SESSION['current_user']->id)
    {
        return html('Can\'t skip yourself!');
    }
    else if($reviewee->department->id == $_SESSION['current_user']->department->id)
    {
        return html('Can\'t skip someone of your own department');
    }

    global $smarty;
    $smarty->assign('page_header', FEEDBACK_SKIP_HEADER);
    $smarty->assign('reviewee', $reviewee);

    return html($smarty->fetch('feedback/skip_confirmation.tpl'));
}

function skip_person()
{
    if(!isset($_POST['reviewee_id']))
    {
        return html('No user was given');
    }

    $reviewee = R::load('user', $_POST['reviewee_id']);

    if($reviewee->id == 0)
    {
        return html('User not found');
    }

    if($reviewee->department->id == $_SESSION['current_user']->department->id)
    {
        return html('This user can\'t be skipped');
    }

    $roundinfo = R::findOne('roundinfo', 'reviewer_id = ? AND reviewee_id = ? AND round_id = ?', array($_SESSION['current_user']->id, $reviewee->id, get_current_round()->id));

    if($roundinfo->id == 0)
    {
        return html('Invalid input');
    }

    // Set status to skipped, but keep in database
    $roundinfo->status = REVIEW_SKIPPED;

    R::store($roundinfo);

    $reviewees = R::find('user', 'department_id != ? AND status != ?', array($_SESSION['current_user']->department->id, PAUSE_USER_REVIEWS));

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

    header('Location:  ' . BASE_URI . 'feedback');
}
