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
    R::nuke();

    $file = BASE_DIR . 'tests/testdata.php';
    if(file_exists($file))
    {
        include $file;
    }

    return '<div class="container">Database reset!</div>';
}

function create_round()
{
//    global $smarty;
//
//    $smarty->display('admin/create_round.tpl');
}

function start_round()
{

}