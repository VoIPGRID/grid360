<?php

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
    set('title', 'Feedback step 3');

    return html($smarty->fetch('feedback/feedback_form.tpl'));
}

function feedback_step_3_post()
{
    security_authorize();

    $count = 0;
    foreach($_POST['competencies'] as $competency)
    {
        if(isset($competency['rating']) && !empty($competency['rating']))
        {
            $count++;
        }
    }

    // Total of 5 competencies (3 positive, 2 points of improvement) have to be selected
    if($count != 5)
    {
        return html('You haven\'t completely filled in the feedback form!');
    }

    $reviews = R::dispense('review', count($_POST['competencies']));

    $current_user = $_SESSION['current_user'];
    $reviewee = R::load('user', params('id'));
    $round = R::load('round', get_current_round()->id);

    $index = 0;
    foreach($_POST['competencies'] as $competency)
    {
        if($competency['rating'] < 1 or $competency['rating'] > 5)
        {
            $values = array();
            $values[''];
            return html('Ratings must be higher than 1 and lower than 5!');
        }

        $reviews[$index]->reviewer = $current_user;
        $reviews[$index]->reviewee = $reviewee;
        $reviews[$index]->competency = R::load('competency', $competency['id']);
        $reviews[$index]->rating = R::load('rating', $competency['rating']);
        $reviews[$index]->comment = $competency['comment'];
        $reviews[$index]->round = $round;
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

    return html('Review saved!');
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
    $smarty->assign('page_header', 'Skip person');
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

    $reviewees = R::find('user', 'department_id != ?', array($_SESSION['current_user']->department->id));

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
