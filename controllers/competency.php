<?php

function create_competency()
{
    security_authorize(MANAGER);

    $competencygroups = R::$adapter->getAssoc('select id, name from competencygroup');

    global $smarty;
    $smarty->assign('group_options', $competencygroups);

    return html($smarty->fetch('competency/competency.tpl'));
}

function create_competency_post()
{
    security_authorize(MANAGER);

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
    security_authorize(MANAGER);

    $roles = R::$adapter->getAssoc('select id, name from role');

    global $smarty;
    $smarty->assign('role_options', $roles);

    return html($smarty->fetch('competency/competencygroup.tpl'));
}

function create_competencygroup_post()
{
    security_authorize(MANAGER);

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
        if($_POST['general'])
        {
            $group->general = true;
        }
        else
        {
            $group->general = false;
        }

        R::store($group);
        global $smarty;

        return html('Competencygroup created! <a href="' . MANAGER_URI . 'competencies">Return to competencies</a>');
    }
    else
    {
        return html('No competency group name given');
    }
}

function view_competencies()
{
    security_authorize(MANAGER);

    $competencies = R::findAll('competency');
    $competencygroups = R::findAll('competencygroup');

    global $smarty;
    $smarty->assign('competencies', $competencies);
    $smarty->assign('competencygroups', $competencygroups);

    return html($smarty->fetch('competency/competencies.tpl'));
}

function edit_competency()
{
    security_authorize(MANAGER);

    $competency = R::load('competency', params('id'));

    if($competency->id == 0)
    {
        return html('Competency not found');
    }

    $competencygroups = R::$adapter->getAssoc('select id, name from competencygroup');

    global $smarty;
    $smarty->assign('group_options', $competencygroups);
    $smarty->assign('competency', $competency);

    return html($smarty->fetch('competency/competency.tpl'));
}

function edit_competencygroup()
{
    security_authorize(MANAGER);

    $competencygroup = R::load('competencygroup', params('id'));

    if($competencygroup->id == 0)
    {
        return html('Competency not found');
    }

    $roles = R::$adapter->getAssoc('select id, name from role');

    global $smarty;
    $smarty->assign('competencygroup', $competencygroup);
    $smarty->assign('role_options', $roles);
    $smarty->assign('update', true);

    return html($smarty->fetch('competency/competencygroup.tpl'));
}

function delete_competency()
{
    security_authorize(MANAGER);

    $competency = R::load('competency', params('id'));

    if($competency->id == 0)
    {
        return html('Competency not found');
    }

    R::trash($competency);

    return html('Competency deleted! <a href="' . MANAGER_URI . 'competencies">Return to competencies</a>');
}

function delete_competencygroup()
{
    security_authorize(MANAGER);

    $competencygroup = R::load('competencygroup', params('id'));

    if($competencygroup->id == 0)
    {
        return html('Competency not found');
    }

    R::trash($competencygroup);

    return html('Competency group deleted <a href="' . MANAGER_URI . 'competencies">Return to competencies</a>');
}
