<?php

include_once('./lib/functions.php');
include_once('./lib/security.php');
include_once('./lib/Swift-5.0.0/lib/swift_required.php');

try
{
    try
    {
        if(!@include_once('configs/local.php'))
        {
            throw new Exception('Unable to load this website\'s local configuration file.');
        }
    } catch(Exception $e)
    {
        if(!include_once('configs/production.php'))
        {
            throw new Exception('Unable to load this website\'s production configuration file.');
        }
    }

    define('BASE_DIR', $_SERVER['DOCUMENT_ROOT'] . SUB_DIR);
    define('LIB_DIR', BASE_DIR . 'lib/');
    define('VIEWS_DIR', BASE_DIR . 'views/');

    define('BASE_URI', SUB_DIR);
    define('ASSETS_URI', BASE_URI . 'assets/');
    define('ADMIN_URI', BASE_URI . 'admin/');
    define('MANAGER_URI', BASE_URI . 'manager/');

} catch(Exception $e)
{
    show_error($e->getMessage(), 1);
}
