<?php

function create_competency()
{
    $competencygroups = R::$adapter->getAssoc('select id, name from competencygroup');

    global $smarty;
    $smarty->assign('group_options', $competencygroups);

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
        return html('No competency name given');
    }
}

function create_competencygroup()
{
    $roles = R::$adapter->getAssoc('select id, name from role');

    global $smarty;
    $smarty->assign('role_options', $roles);

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
        return html('No competency group name given');
    }
}

function view_competencies()
{
    $competencies = R::findAll('competency');
    $competencygroups = R::findAll('competencygroup');

    global $smarty;
    $smarty->assign('competencies', $competencies);
    $smarty->assign('competencygroups', $competencygroups);

    return html($smarty->fetch('competencies/competencies.tpl'));
}

function edit_competency()
{
    $competency = R::load('competency', params('id'));

    $competencygroups = R::$adapter->getAssoc('select id, name from competencygroup');

    global $smarty;
    $smarty->assign('group_options', $competencygroups);
    $smarty->assign('competency', $competency);

    return html($smarty->fetch('competencies/competency.tpl'));
}

function edit_competencygroup()
{
    $competencygroup = R::load('competencygroup', params('id'));
    $roles = R::$adapter->getAssoc('select id, name from role');

    global $smarty;
    $smarty->assign('competencygroup', $competencygroup);
    $smarty->assign('role_options', $roles);
    $smarty->assign('update', 1);

    return html($smarty->fetch('competencies/competencygroup.tpl'));
}

function delete_competency()
{
    $competency = R::load('competency', params('id'));

    R::trash($competency);

    return html('Competency deleted! <a href="' . MANAGER_URI . 'manager">Return to competencies</a>');
}

function delete_competencygroup()
{
    $competencygroup = R::load('competencygroup', params('id'));

    R::trash($competencygroup);

    return html('Competency group deleted <a href="' . MANAGER_URI . 'competencies">Return to competencies</a>');
}
