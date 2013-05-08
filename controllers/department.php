<?php

function create_department()
{
    security_authorize(ADMIN);

    global $smarty;
    $smarty->assign('manager_options', get_managers());

    return html($smarty->fetch('department/department.tpl'));
}

function create_department_post()
{
    security_authorize(ADMIN);

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
    security_authorize(ADMIN);

    global $smarty;
    $departments = R::findAll('department');
    $smarty->assign('departments', $departments);
    $smarty->assign('page_title', 'Departments');
    set('title', 'Departments');

    return html($smarty->fetch('department/departments.tpl'));
}

function edit_department()
{
    security_authorize(ADMIN);

    $department = R::load('department', params('id'));

    if($department->id == 0)
    {
        return html('Department not found!');
    }

    global $smarty;
    $smarty->assign('department', $department);
    $smarty->assign('manager_options', get_managers());
    $smarty->assign('update', true);

    return html($smarty->fetch('department/department.tpl'));
}

function delete_department()
{
    security_authorize(ADMIN);

    $department = R::load('department', params('id'));

    if($department->id == 0)
    {
        return html('Department not found!');
    }

    R::trash($department);

    return html('Department deleted! <a href="' . ADMIN_URI . 'departments">Return to departments</a>');
}

function get_managers()
{
    $levels = array(ADMIN, MANAGER);

    $managers = R::$adapter->getAssoc('select user.id, CONCAT(firstname, " ", lastname) as name
                                       from user
                                       left join userlevel
                                       on userlevel.id = user.userlevel_id
                                       where userlevel.level IN (' . R::genSlots($levels) . ')', $levels);

    return $managers;
}
