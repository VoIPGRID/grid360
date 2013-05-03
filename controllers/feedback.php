<?php

function view_feedback_overview()
{
    security_authorize();

    $roundinfo = R::find('roundinfo', ' reviewer_id = ? AND round_id = ?', array($_SESSION['current_user']->id, 4)); // TODO: Change to currentRound->id
    R::preload($roundinfo, array('reviewee' => 'user'));

    foreach($roundinfo as $key => $info)
    {
        if($info->reviewee->status == 0)
        {
            unset($roundinfo[$key]);
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

    $roundinfo = R::findOne('roundinfo', ' reviewee_id = ? AND reviewer_id = ?', array($reviewee->id, $_SESSION['current_user']->id));

    if($roundinfo->status == 1)
    {
        return html('Already reviewed this person!');
    }

    $generalCompetencies = R::find('competency', ' competencygroup_id = 5');

    $competencies = R::find('competency', ' competencygroup_id = ?', array($reviewee->role->competencygroup->id));
    global $smarty;
    $smarty->assign('reviewee', $reviewee);
    $smarty->assign('competencies', $competencies);
    $smarty->assign('general_competencies', $generalCompetencies);
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

    $reviewee = R::load('user', params('id'));

    if($reviewee->id == 0)
    {
        return html('User not found!');
    }

    $positive_competencies = $_SESSION['positive_competencies'];

    $general_competencies = R::find('competency', ' competencygroup_id = 5
    AND id NOT IN (' . R::genSlots($positive_competencies) . ')', $positive_competencies);

    $competencies = R::find('competency', ' competencygroup_id = ?
    AND id NOT IN (' . R::genSlots($positive_competencies) . ')', array_merge(array($reviewee->role->competencygroup->id), $positive_competencies));

    global $smarty;
    $smarty->assign('reviewee', $reviewee);
    $smarty->assign('competencies', $competencies);
    $smarty->assign('general_competencies', $general_competencies);
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

    $reviews = R::dispense('review', count($_POST['competencies']));

    $current_user = R::load('user', 1);
    $reviewee = R::load('user', params('id'));
    $round = R::load('round', 4); // TODO: Change to current round

    $index = 0;
    foreach($_POST['competencies'] as $competency)
    {
        $reviews[$index]->reviewer = $current_user;
        $reviews[$index]->reviewee = $reviewee;
        $reviews[$index]->competency = R::load('competency', $competency['id']);
        $reviews[$index]->rating = R::load('rating', $competency['rating']);
        $reviews[$index]->comment = $competency['comment'];
        $reviews[$index]->round = $round;
        $index++;
    }

    $roundinfo = R::findOne('roundinfo', ' reviewer_id = ? AND reviewee_id = ?', array($current_user->id, $reviewee->id));
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
