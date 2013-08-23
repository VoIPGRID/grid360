<?php

function create_competencygroup()
{
    security_authorize(MANAGER);

    $roles = get_roles_assoc();

    global $smarty;
    $smarty->assign('role_options', $roles);

    return html($smarty->fetch('competency/competencygroup.tpl'));
}

function create_competencygroup_post()
{
    security_authorize(MANAGER);

    $keys_to_check = array
    (
        'name' => $_POST['name']
    );

    $id = params('id');

    if(!empty($id))
    {
        $_POST['id'] = $id;
        $keys_to_check['id'] = array
        (
            'load_bean' => true,
            'id' => $_POST['id'],
            'type' => 'competencygroup'
        );
    }

    $form_values = validate_form($keys_to_check);

    $has_errors = false;

    foreach($_POST['ownCompetency'] as $id => $competency_row)
    {
        // If the role name is empty, remove role from the list so you don't get an empty role in the database
        if(strlen(trim($competency_row['name'])) == 0)
        {
            unset($_POST['ownCompetency'][$id]);
        }
        else
        {
            if(isset($competency_row['id']))
            {
                $competency = R::load('competency', $competency_row['id']);

                if($competency->id == 0)
                {
                    $form_values['competencies']['error'] = sprintf(BEAN_NOT_FOUND, _('competency'));
                    $has_errors = true;
                }
            }
        }
    }

    if(count($_POST['ownCompetency']) < 3)
    {
        $form_values['competencies']['error'] = _('At least 3 competencies must be created');
        $has_errors = true;
    }

    // Make sure the non-required fields get stored in the form_values
    $form_values['general']['value'] = $_POST['general'];
    $form_values['description']['value'] = $_POST['description'];
    $form_values['competencies']['value'] = $_POST['ownCompetency'];

    global $smarty;

    foreach($form_values as $form_value)
    {
        if(isset($form_value['error']))
        {
            $has_errors = true;
            break;
        }
    }

    // Set the form values so they can be used again in the form
    if($has_errors || isset($form_values['error']))
    {
        $smarty->assign('form_values', $form_values);

        if(isset($_POST['id']))
        {
            return edit_competencygroup();
        }

        return create_competencygroup();
    }

    $competencygroup = R::graph($_POST);

    if($_POST['general'])
    {
        $competencygroup->general = true;

        $general_competencies = get_general_competencies();

        if(!empty($general_competencies))
        {
            $general_competencies->general = false;

            R::store($general_competencies);
        }
    }
    else
    {
        $competencygroup->general = false;
    }

    // Check if the department is a new department
    if($competencygroup->id != 0)
    {
        $message = sprintf(UPDATE_SUCCESS, _('competency group'), $competencygroup->name);
    }
    else
    {
        $message = sprintf(CREATE_SUCCESS, _('competency group'), $competencygroup->name);
    }

    R::store($competencygroup);

    flash('success', $message);
    redirect_to(MANAGER_URI . 'competencies');
}

function edit_competencygroup()
{
    security_authorize(MANAGER);

    $competencygroup = R::load('competencygroup', params('id'));

    if($competencygroup->id == 0)
    {
        $message = sprintf(BEAN_NOT_FOUND, _('competency group'));
        flash('error', $message);
        redirect_to(MANAGER_URI . 'competencies');
    }

    $roles = get_roles_assoc();

    global $smarty;

    if(!$smarty->getTemplateVars('form_values'))
    {
        $form_values = array();
        $form_values['id']['value'] = $competencygroup->id;
        $form_values['general']['value'] = $competencygroup->general;
        $form_values['name']['value'] = $competencygroup->name;
        $form_values['description']['value'] = $competencygroup->description;
        $form_values['competencies']['value'] = $competencygroup->ownCompetency;

        $smarty->assign('form_values', $form_values);
    }

    $smarty->assign('competencygroup_name', $competencygroup->name);
    $smarty->assign('role_options', $roles);
    $smarty->assign('update', true);

    return html($smarty->fetch('competency/competencygroup.tpl'));
}

function delete_competencygroup_confirmation()
{
    security_authorize(MANAGER);

    $competencygroup = R::load('competencygroup', params('id'));

    if($competencygroup->id == 0)
    {
        $message = sprintf(BEAN_NOT_FOUND, _('competency group'));
        flash('error', $message);
        redirect_to(MANAGER_URI . 'competencies');
    }

    global $smarty;
    $smarty->assign('type', _('competency group'));
    $smarty->assign('type_var', 'competencygroup');
    $smarty->assign('competencygroup', $competencygroup);
    $smarty->assign('level_uri', MANAGER_URI);
    $smarty->assign('delete_uri', BASE_URI . MANAGER_URI . 'competencies');

    return html($smarty->fetch('common/delete_confirmation.tpl'));
}

function delete_competencygroup()
{
    security_authorize(MANAGER);

    $competencygroup = R::load('competencygroup', params('id'));

    if($competencygroup->id == 0)
    {
        $message = sprintf(BEAN_NOT_FOUND, _('competency group'));
        flash('error', $message);
        redirect_to(MANAGER_URI . 'competencies');
    }

    R::trash($competencygroup);

    $message = sprintf(DELETE_SUCCESS, 'competency group', $competencygroup->name);
    flash('success', $message);
    redirect_to(MANAGER_URI . 'competencies');
}

function get_roles_assoc()
{
    $roles = R::$adapter->getAssoc('SELECT id, name FROM role WHERE tenant_id = ?', array($_SESSION['current_user']->tenant_id));

    return $roles;
}
