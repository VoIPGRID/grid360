<?php
/**
 * @author epasagic
 * @date 26-3-13
 */

function confirmation()
{
    global $smarty;
    $smarty->display('admin/confirmation.tpl');
}

function fill_database()
{
    R::setup(CONNECTION, USERNAME, PASSWORD);

    R::nuke();

    $file = BASE_DIR . 'tests/testdata.php';
    if(file_exists($file))
    {
        include $file;
    }
}