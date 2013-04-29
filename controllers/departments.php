<?php
/**
 * @author epasagic
 * @date 22-3-13
 */

function create_department()
{
    global $smarty;
    $smarty->assign('managerOptions', get_managers());

    return html($smarty->fetch('departments/department.tpl'));
}

function create_department_post()
{
    if(isset($_POST['name']) && !empty($_POST['name']))
    {
        foreach($_POST['ownRoles'] as $key => $role)
        {
            if(empty($role['name']))
            {
                unset($_POST['ownRoles'][$key]);
            }
        }

        $department = R::graph($_POST); // TODO: Check if user is not empty

        if($department->user->id == 0)
        {
            unset($department->user);
        }

        R::store($department);
        global $smarty; // TODO: Add submit page

        if(isset($_POST['id']))
        {
            return html('Department with id ' . $_POST['id'] . ' updated');
        }

        return html('Department created!');
    }
    else
    {
        return html('No department name given');
    }
}

function view_departments()
{
    global $smarty;
    $departments = R::findAll('department');
    $smarty->assign('departments', $departments);
    $smarty->assign('pageTitle', 'Departments');
    $smarty->assign('pageTitleSize', 'h1');
    set('title', 'Departments');

    return html($smarty->fetch('departments/departments.tpl'));
}

function edit_department()
{
    $department = R::load('department', params('id'));

    if($department->id == 0)
        return html('Department not found!');

    global $smarty;
    $smarty->assign('department', $department);
    $smarty->assign('managerOptions', get_managers());
    $smarty->assign('update', 1);

    return html($smarty->fetch('departments/department.tpl'));
}

function delete_department()
{
    $department = R::load('department', params('id'));

    if($department->id == 0)
        return 'Department not found!';

    R::trash($department);
}

function get_managers()
{
    $userLevels = array(1, 2);  // TODO: Name these userlevels and make 'em constants or w/e
    $managers = R::$adapter->getAssoc('select id, CONCAT( firstname, " ", lastname ) as name
                                       from user where userlevel_id IN (' . R::genSlots($userLevels) . ')', $userLevels);

    return $managers;
}
