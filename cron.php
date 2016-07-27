<?php

require_once('config.php');
require_once('constants.php');
require_once(dirname(__FILE__) . '/lib/redbeanphp/rb.php');
require_once(dirname(__FILE__) . '/lib/limonade/lib/limonade.php');
include_once(dirname(__FILE__) . '/lib/Swift-5.0.0/lib/swift_required.php');

register_shutdown_function('shutdown');

R::setup(CONNECTION, DB_USERNAME, DB_PASSWORD);

try
{
    $rounds = R::find('round', 'status = ?', array(ROUND_IN_PROGRESS));

    foreach($rounds as $round)
    {
        $current_datetime = new DateTime(null, new DateTimeZone(date_default_timezone_get()));
        $current_datetime = $current_datetime->format('Y-m-d H:00:00');

        $closing_date = new DateTime($round->closing_date, new DateTimeZone(date_default_timezone_get()));
        $closing_date = $closing_date->format('Y-m-d H:00:00');

        if($closing_date <= $current_datetime)
        {
            end_round($round, false);
        }
    }

    R::close();
}
catch(Exception $exception)
{
    R::close();

    halt(SERVER_ERROR, $exception);
}

function server_error($errno, $exception = null)
{
    if($exception == null)
    {
        $exception = new Exception();
    }

    global $smarty;

    $smarty->assign('error_number', $errno);
    $smarty->assign('error_string', debug_string_backtrace());
    $smarty->assign('error_file', $exception->getFile());
    $smarty->assign('error_line', $exception->getLine());
    $smarty->assign('error_message', $exception->getMessage());

    $subject = 'Error while running cron in ' . $exception->getFile() . ' on line ' . $exception->getLine();
    $body = $smarty->fetch(dirname(__FILE__) . '/views/email/server_error.tpl');

    send_mail($subject, ERROR_EMAIL, ERROR_EMAIL, $body);
}

function shutdown()
{
    $error = error_get_last();

    // Check if there is a fatal error
    if(!empty($error) && $error['type'] == 1)
    {
        halt(SERVER_ERROR);
    }
}
