<?php
/**
 * @author epasagic
 * @date 22-3-13
 */

function create_competency()
{
    $competencyGroups = R::$adapter->getAssoc('select id, name from competencygroup');

    global $smarty;
    $smarty->assign('groupOptions', $competencyGroups);
    $smarty->display('competencies/new_competency.tpl');
}

function create_competencygroup()
{
    $roles = R::$adapter->getAssoc('select id, name from role');

    global $smarty;
    $smarty->assign('roleOptions', $roles);
    $smarty->display('competencies/new_competencygroup.tpl');
}

function view_competencies()
{
    $competencies = R::findAll('competency');
    $competencyGroups = R::findAll('competencygroup');

    global $smarty;
    $smarty->assign('competencies', $competencies);
    $smarty->assign('competencygroups', $competencyGroups);
    $smarty->display('competencies/competencies.tpl');
}

function edit_competency()
{
    $competency = R::load('competency', params('id'));

    $competencyGroups = R::$adapter->getAssoc('select id, name from competencygroup');

    global $smarty;
    $smarty->assign('groupOptions', $competencyGroups);
    $smarty->assign('competency', $competency);
    $smarty->display('competencies/edit_competency.tpl');
}


function edit_competencygroup()
{
    $competencyGroup = R::load('competencygroup', params('id'));
    $roles = R::$adapter->getAssoc('select id, name from role');

    global $smarty;
    $smarty->assign('competencygroup', $competencyGroup);
    $smarty->assign('roleOptions', $roles);
    $smarty->display('competencies/edit_competencygroup.tpl');
}

function delete_competency()
{
    $competency = R::load('competency', params('id'));

    R::trash($competency);
}

function delete_competencygroup()
{
    $competencygroup = R::load('competencygroup', params('id'));

    R::trash($competencygroup);
}


function create_competencygroup_post()
{
    if(isset($_POST['name']) && !empty($_POST['name']))
    {
        $index = 0;
        foreach($_POST['ownCompetencies'] as $competency)
        {
            if(empty($competency['name']))
            {
                unset($_POST['ownCompetencies'][$index]);
            }

            $index++;
        }
        $group = R::graph($_POST);
        R::store($group);
        global $smarty;
    }
    else
    {
        echo 'No competency group name given';
    }
}

function create_competency_post()
{
    if(isset($_POST['name']) && !empty($_POST['name']))
    {
        $user = R::graph($_POST);
        R::store($user);
    }
    else
    {
        echo 'No competency name given';
    }
}