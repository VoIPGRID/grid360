<?php

function confirmation()
{
    security_authorize();

    global $smarty;
    $smarty->assign('page_title', 'Reset database');

    return html($smarty->fetch('admin/confirmation.tpl'));
}

function fill_database()
{
    security_authorize();

    R::nuke();

    $message = 'Database reset!';

    $file = BASE_DIR . 'tests/testdata.php';
    if(file_exists($file))
    {
        include $file;
        $message .= '<br>Test data has been added to the database.';
    } else
    {
        $message .= '<br>No test data has been generated.';
    }

    return html($message);
}

function create_round()
{
    security_authorize();
//    global $smarty;
//
//    return html($smarty->fetch('admin/create_round.tpl'));
}

function start_round()
{
    security_authorize();
}
