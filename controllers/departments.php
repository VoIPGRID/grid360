<?php
/**
 * @author epasagic
 * @date 22-3-13
 */

function create_department()
{
    $managers = R::find('user', 'userlevel_id = ? or userlevel_id = ?', array(2, 1));

    $managerOptions = array();
    foreach($managers as $manager)
    {
        $managerOptions[$manager->id] = $manager->firstname . " " . $manager->lastname;
    }

    global $smarty;
    $smarty->assign('managerOptions', $managerOptions);
    $smarty->display('departments/new_department.tpl');
}

function view_departments()
{
    global $smarty;
    $departments = R::findAll('department');
    $smarty->assign('departments', $departments);
    $smarty->display('departments/departments.tpl');
}

function edit_department()
{
    $department = R::load('department', params('id'));

    if($department->id == 0)
        return 'Department not found!';

    $managers = R::find('user', 'userlevel_id = ? or userlevel_id = ?', array(2, 1)); // Hardcoded userlevels for now

    $managerOptions = array();
    foreach($managers as $manager)
    {
        $managerOptions[$manager->id] = $manager->firstname . " " . $manager->lastname;
    }

    global $smarty;
    $smarty->assign('department', $department);
    $smarty->assign('managerOptions', $managerOptions);
    $smarty->display('departments/edit_department.tpl');
}

function delete_department()
{
    $department = R::load('department', params('id'));

    if($department->id == 0)
        return 'Department not found!';

    R::trash($department);
}

function create_department_post()
{
    if(isset($_POST['name']) && !empty($_POST['name']))
    {
        $index = 0;
        foreach($_POST['ownRoles'] as $role)
        {
            if(empty($role['name']))
            {
                unset($_POST['ownRoles'][$index]);
            }

            $index++;
        }
        print_r($_POST['ownRoles']);
        $department = R::graph($_POST);
        $user = trim($department->user_id);
        if(empty($user) === true)
        {
            $department->user_id = null;
        }
        R::store($department);
        global $smarty;
    }
    else
    {
        echo 'No department name given';
    }
}