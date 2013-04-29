<?php
/**
 * @author epasagic
 * @date 27-3-13
 */

function view_feedback_overview()
{
    $roundInfo = R::find('roundinfo', ' reviewer_id = ? AND round_id = ?', array(1, 4)); // TODO: Change to currentUser->id and currentRound->id
    R::preload($roundInfo, array('reviewee' => 'user'));

    foreach($roundInfo as $key => $info)
    {
        if($info->reviewee->status == 0)
        {
            unset($roundInfo[$key]);
        }
    }

    global $smarty;
    $smarty->assign('roundinfo', $roundInfo);

    return html($smarty->fetch('feedback/feedback_overview.tpl'));
}

function feedback_step_1()
{
    $reviewee = R::load('user', params('id'));

    if($reviewee->id == 0)
        return html('User not found!');

    $roundInfo = R::findOne('roundinfo', ' reviewee_id = ? AND reviewer_id = ?', array($reviewee->id, 1)); // TODO: Change to currentUser->id

    if($roundInfo->status == 1)
    {
        return html('Already reviewed this person!');
    }

    $generalCompetencies = R::find('competency', ' competencygroup_id = 5');

    $competencies = R::find('competency', ' competencygroup_id = ?', array($reviewee->role->competencygroup->id));
    global $smarty;
    $smarty->assign('reviewee', $reviewee);
    $smarty->assign('competencies', $competencies);
    $smarty->assign('generalCompetencies', $generalCompetencies);
    $smarty->assign('step', 1);
    set('title', 'Feedback step 1');

    return html($smarty->fetch('feedback/feedback.tpl'));
}

function feedback_step_1_post()
{
    if(isset($_POST['competencies']) && count($_POST['competencies']) == 3)
    {
        $_SESSION['positiveCompetencies'] = $_POST['competencies'];
        header('Location: ' . BASE_URI . 'feedback/' . params('id') . '/2');
    }
    else
    {
        return html('Error!');
    }
}

function feedback_step_2()
{
    $reviewee = R::load('user', params('id'));

    if($reviewee->id == 0)
        return html('User not found!');

    $positiveCompetencies = $_SESSION['positiveCompetencies'];

    $generalCompetencies = R::find('competency', ' competencygroup_id = 5
    AND id NOT IN (' . R::genSlots($positiveCompetencies) . ')', $positiveCompetencies);

    $competencies = R::find('competency', ' competencygroup_id = ?
    AND id NOT IN (' . R::genSlots($positiveCompetencies) . ')', array_merge(array($reviewee->role->competencygroup->id), $positiveCompetencies));

    global $smarty;
    $smarty->assign('reviewee', $reviewee);
    $smarty->assign('competencies', $competencies);
    $smarty->assign('generalCompetencies', $generalCompetencies);
    $smarty->assign('step', 2);
    set('title', 'Feedback step 2');

    return html($smarty->fetch('feedback/feedback.tpl'));
}

function feedback_step_2_post()
{
    if(isset($_POST['competencies']) && count($_POST['competencies']) == 2)
    {
        $_SESSION['negativeCompetencies'] = $_POST['competencies'];
        header('Location:  ' . BASE_URI . 'feedback/' . params('id') . '/3');
    }
    else
    {
        return html('Error!');
    }
}

function feedback_step_3()
{
    $reviewee = R::load('user', params('id'));

    if($reviewee->id == 0)
        return html('User not found!');

    $positiveCompetencies = R::batch('competency', $_SESSION['positiveCompetencies']);
    $negativeCompetencies = R::batch('competency', $_SESSION['negativeCompetencies']);

    global $smarty;
    $smarty->assign('reviewee', $reviewee);
    $smarty->assign('positiveCompetencies', $positiveCompetencies);
    $smarty->assign('negativeCompetencies', $negativeCompetencies);
    set('title', 'Feedback step 3');

    return html($smarty->fetch('feedback/feedback_form.tpl'));
}

function feedback_step_3_post()
{
    $reviews = R::dispense('review', count($_POST['competencies']));

    $currentUser = R::load('user', 1);
    $reviewee = R::load('user', params('id'));
    $round = R::load('round', 4); // TODO: Change to current round

    $index = 0;
    foreach($_POST['competencies'] as $competency)
    {
        $reviews[$index]->reviewer = $currentUser;
        $reviews[$index]->reviewee = $reviewee;
        $reviews[$index]->competency = R::load('competency', $competency['id']);
        $reviews[$index]->rating = R::load('rating', $competency['rating']);
        $reviews[$index]->comment = $competency['comment'];
        $reviews[$index]->round = $round;
        $index++;
    }

    $roundInfo = R::findOne('roundinfo', ' reviewer_id = ? AND reviewee_id = ?', array($currentUser->id, $reviewee->id));
    if(!isset($roundInfo))
    {
        $roundInfo = R::dispense('roundinfo');
        $roundInfo->reviewee = $reviewee;
        $roundInfo->reviewer = $currentUser;
        $roundInfo->round = $round;
    }

    $roundInfo->status = 1;
    $roundInfo->answer = $_POST['openQuestion'];

    R::store($roundInfo);
    R::storeAll($reviews);

    return html('Review saved!');
}
