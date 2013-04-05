<?php
/**
 * @author epasagic
 * @date 27-3-13
 */

function feedback_step_1()
{
    $generalCompetencies = R::find('competency', ' competencygroup_id = 5');

    $id = 1;
    $competencies = R::find('competency', ' competencygroup_id = ?', array($id));
    global $smarty;
    $smarty->assign('competencies', $competencies);
    $smarty->assign('generalCompetencies', $generalCompetencies);
    $smarty->assign('step', 1);
    $smarty->display('feedback/feedback.tpl');
}

function feedback_step_1_post()
{
    if(isset($_POST['competencies']) && count($_POST['competencies']) == 3)
    {
        $_SESSION['positiveCompetencies'] = $_POST['competencies'];
        header('Location: ' . BASE_URI . 'feedback/2');
    }
    else
    {
        echo 'Error!';
    }
}

function feedback_step_2()
{
    $positiveCompetencies = $_SESSION['positiveCompetencies'];

    $generalCompetencies = R::find('competency', ' competencygroup_id = 5
    AND id NOT IN (' . R::genSlots($positiveCompetencies) . ')', $positiveCompetencies);

    $id = 1; // Currently hardcoded, but will be changed to $currentLoggedInUser->role->competencygroup->id

    $competencies = R::find('competency', ' competencygroup_id = ?
     AND id NOT IN (' . R::genSlots($positiveCompetencies) . ')', array_merge(array($id), $positiveCompetencies));

    global $smarty;
    $smarty->assign('competencies', $competencies);
    $smarty->assign('generalCompetencies', $generalCompetencies);
    $smarty->assign('step', 2);
    $smarty->display('feedback/feedback.tpl');
}

function feedback_step_2_post()
{
    if(isset($_POST['competencies']) && count($_POST['competencies']) == 2)
    {
        $_SESSION['negativeCompetencies'] = $_POST['competencies'];
        header('Location:  ' . BASE_URI . 'feedback/3');
    }
    else
    {
        echo 'Error!';
    }
}

function feedback_step_3()
{
    $positiveCompetencies = R::batch('competency', $_SESSION['positiveCompetencies']);
    $negativeCompetencies = R::batch('competency', $_SESSION['negativeCompetencies']);

    global $smarty;
    $smarty->assign('positiveCompetencies', $positiveCompetencies);
    $smarty->assign('negativeCompetencies', $negativeCompetencies);
    $smarty->display('feedback/feedback_form.tpl');
}

function feedback_step_3_post()
{
}