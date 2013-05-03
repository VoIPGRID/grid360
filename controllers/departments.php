<?php

function create_department()
{
    security_authorize();

    global $smarty;
    $smarty->assign('manager_options', get_managers());

    return html($smarty->fetch('departments/department.tpl'));
}

function create_department_post()
{
    security_authorize();

    if(isset($_POST['name']) && !empty($_POST['name']))
    {
        foreach($_POST['ownRoles'] as $key => $role)
        {
            if(empty($role['name']))
            {
                unset($_POST['ownRoles'][$key]);
            }
        }

        $department = R::graph($_POST);

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
    security_authorize();

    global $smarty;
    $departments = R::findAll('department');
    $smarty->assign('departments', $departments);
    $smarty->assign('page_title', 'Departments');
    set('title', 'Departments');

    return html($smarty->fetch('departments/departments.tpl'));
}

function edit_department()
{
    security_authorize();

    $department = R::load('department', params('id'));

    if($department->id == 0)
    {
        return html('Department not found!');
    }

    global $smarty;
    $smarty->assign('department', $department);
    $smarty->assign('manager_options', get_managers());
    $smarty->assign('update', 1);

    return html($smarty->fetch('departments/department.tpl'));
}

function delete_department()
{
    security_authorize();

    $department = R::load('department', params('id'));

    if($department->id == 0)
    {
        return 'Department not found!';
    }

    R::trash($department);

    return html('Department deleted! <a href="' . ADMIN_URI . 'departments">Return to departments</a>');
}

function get_managers()
{
    security_authorize();

    $userlevels = array(ADMIN, MANAGER);
    $managers = R::$adapter->getAssoc('select id, CONCAT( firstname, " ", lastname ) as name
                                       from user where userlevel_id IN (' . R::genSlots($userlevels) . ')', $userlevels);

    return $managers;
}
