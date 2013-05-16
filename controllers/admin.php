<?php

function confirmation()
{
    security_authorize(ADMIN);

    global $smarty;
    $smarty->assign('page_title', 'Reset database');

    return html($smarty->fetch('admin/confirmation.tpl'));
}

function fill_database()
{
    security_authorize(ADMIN);

    R::nuke();

    $message = 'Database reset!';

    $file = BASE_DIR . 'tests/testdata.php';
    if(file_exists($file))
    {
        include $file;
        $message .= '<br>Test data has been added to the database.';
    }
    else
    {
        $message .= '<br>No test data generated.';
    }

    return html($message);
}
