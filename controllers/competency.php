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

    if(!isset($_POST['type']) || $_POST['type'] != 'competency')
    {
        return html('Error creating competency!');
    }

    if(isset($_POST['name']) && strlen(trim($_POST['name'])) > 0)
    {
        $competency = R::graph($_POST);

        R::store($competency);
    }
    else
    {
        $values = array();
        $values['error'] = 1;

        global $smarty;
        $smarty->assign('values', $values);

        return create_competency();
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

    if(!isset($_POST['type']) || $_POST['type'] != 'competencygroup')
    {
        return html('Error creating competency group!');
    }

    if(isset($_POST['name']) && strlen(trim($_POST['name'])) > 0)
    {
        foreach($_POST['ownCompetency'] as $competency_id => $competency)
        {
            if(strlen(trim($competency['name'])) == 0)
            {
                // If the name is empty, remove competency from the list so you don't get an empty competency in the database
                unset($_POST['ownCompetency'][$competency_id]);
            }
        }

        $competencygroup = R::graph($_POST);

        if($_POST['general'])
        {
            $competencygroup->general = true;
        }
        else
        {
            $competencygroup->general = false;
        }

        R::store($competencygroup);

        global $smarty;

        if(isset($_POST['id']))
        {
            return html('Competency group with id ' . $_POST['id'] . ' updated! <a href="' . MANAGER_URI . 'competencies">Return to competencies</a>');
        }

        return html('Competency group created! <a href="' . MANAGER_URI . 'competencies">Return to competencies</a>');
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

function delete_competency_confirmation()
{
    security_authorize(MANAGER);

    $competency = R::load('competency', params('id'));

    if($competency->id == 0)
    {
        return html('Competency not found!');
    }

    global $smarty;
    $smarty->assign('type', 'competency');
    $smarty->assign('competency', $competency);
    $smarty->assign('level_uri', MANAGER_URI);

    return html($smarty->fetch('common/delete_confirmation.tpl'));
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

function delete_competencygroup_confirmation()
{
    security_authorize(MANAGER);

    $competencygroup = R::load('competencygroup', params('id'));

    if($competencygroup->id == 0)
    {
        return html('Competency group not found!');
    }

    global $smarty;
    $smarty->assign('type', 'competencygroup');
    $smarty->assign('competencygroup', $competencygroup);
    $smarty->assign('level_uri', MANAGER_URI);

    return html($smarty->fetch('common/delete_confirmation.tpl'));
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
