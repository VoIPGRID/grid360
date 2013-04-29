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

    return html($smarty->fetch('competencies/competency.tpl'));
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

function create_competencygroup()
{
    $roles = R::$adapter->getAssoc('select id, name from role');

    global $smarty;
    $smarty->assign('roleOptions', $roles);

    return html($smarty->fetch('competencies/competencygroup.tpl'));
}

function create_competencygroup_post()
{
    if(isset($_POST['name']) && !empty($_POST['name']))
    {
        foreach($_POST['ownCompetencies'] as $key => $competency)
        {
            if(empty($competency['name']))
            {
                unset($_POST['ownCompetencies'][$key]);
            }
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

function view_competencies()
{
    $competencies = R::findAll('competency');
    $competencyGroups = R::findAll('competencygroup');

    global $smarty;
    $smarty->assign('competencies', $competencies);
    $smarty->assign('competencygroups', $competencyGroups);

    return html($smarty->fetch('competencies/competencies.tpl'));
}

function edit_competency()
{
    $competency = R::load('competency', params('id'));

    $competencyGroups = R::$adapter->getAssoc('select id, name from competencygroup');

    global $smarty;
    $smarty->assign('groupOptions', $competencyGroups);
    $smarty->assign('competency', $competency);

    return html($smarty->fetch('competencies/competency.tpl'));
}

function edit_competencygroup()
{
    $competencyGroup = R::load('competencygroup', params('id'));
    $roles = R::$adapter->getAssoc('select id, name from role');

    global $smarty;
    $smarty->assign('competencygroup', $competencyGroup);
    $smarty->assign('roleOptions', $roles);
    $smarty->assign('update', 1);

    return html($smarty->fetch('competencies/competencygroup.tpl'));
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

    return html('Competency group with id ' . params('id') . ' deleted');
}
