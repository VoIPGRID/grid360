<?php
/**
 * @author epasagic
 * @date 21-3-13
 */

try
{
    if(!@include_once( 'configs/local.php' )):
        throw new Exception( "Unable to load this website's configuration file." );
    endif;

} catch(Exception $e)
{
    if(!include_once( 'configs/production.php' )):
        throw new Exception( "Unable to load this website's configuration file." );
    endif;
}

define('BASE_DIR', $_SERVER['DOCUMENT_ROOT'] . SUB_DIR);
define('LIB_DIR', BASE_DIR . 'lib/');
define('VIEWS_DIR', BASE_DIR . 'views/');

define('BASE_URI', SUB_DIR);
define('ASSETS_URI', BASE_URI . 'assets/');
define('ADMIN_URI', BASE_URI . 'admin/');
define('MANAGER_URI', BASE_URI . 'manager/');
