<?php

/**
 * Handle error at the earliest possible stage with as less as dependencies
 * as possible.
 */

/* register error handlers */
register_shutdown_function('shutdown');
set_error_handler('mail_error', -1 & ~E_NOTICE & ~E_USER_NOTICE);


/* Handle fatal errors */
function shutdown() {
    //mail_error();
}

/* check if an error worth mentioning might have occured */
function has_error() {
    $error = error_get_last();
    if(isset($error)) {
        if(strpos($error['file'], '.templates_c') === false) {
            return true;
        }
    }

    return false;
}

/* mail error information to *ERROR_MAIL* */
function mail_error() {
    /* don't mail if there is nothing to mail about */
    if(!has_error()) {
        return;
    }

    $last_error = error_get_last();
    $type = '';
    $file = $last_error['file'];
    $line = $last_error['line'];
    $message = $last_error['message'];

    /* find out what this error type is called */
    switch($last_error['type']) {
        case 1:
            $type = 'E_ERROR';
            break;
        case 2:
            $type = 'E_WARNING';
            break;
        case 4:
            $type= 'E_PARSE';
            break;
        case 8:
            $type= 'E_NOTICE';
            break;
        default:
            $type= 'E_UNKNOWN';
            break;
    }

    $file = str_replace(BASE_DIR, '', $file);

    $short_msg = explode("\n", $message);
    $short_msg = str_replace(BASE_DIR, '', $short_msg[0]);
    $subject = sprintf('%s | %s#%s: %s', $type, $file, $line, $short_msg);

    /* create mail body */
    $body = 'SCRIPT_FILENAME: ' . BASE_DIR . $file . '(' . $line . ')' . PHP_EOL;

    /* pretty print backtrace */
    $debug_string_backtrace = function() use (&$message) {
        ob_start();
        print $message;
        $trace = ob_get_contents();
        ob_end_clean();

        return $trace;
    };
    $body .= '<pre>';
    $body .= str_replace(BASE_DIR, '', $debug_string_backtrace());
    $body .= '</pre>' . PHP_EOL . '<br /><br />' . PHP_EOL;
    $body .= 'Trace for ' . $_SERVER['REQUEST_METHOD'] . '-request at ' . $_SERVER['REQUEST_URI'] . '<br />' . PHP_EOL;
    // if(array_key_exists('HTTP_REFERER', $_SERVER)) {
    //     $body .= 'HTTP_REFERER: ' . $_SERVER['HTTP_REFERER'] . '<br />' . PHP_EOL;
    // } else {
    //     $body .= 'HTTP_REFERER: No $_SERVER[\'HTTP_REFERER\']<br />' . PHP_EOL;
    // }
    $body .= 'QUERY_STRING: ' . $_SERVER['QUERY_STRING'] . '<br />' . PHP_EOL;
    $body .= 'POST: ' . PHP_EOL . var_export($_POST, true) . '<br />' . PHP_EOL;
    $body .= 'SERVER: ' . PHP_EOL . var_export($_SERVER, true);

    /* more or less a copy of the contents from functions.php:send_mail() below */
    if(!class_exists('Swift_Mailer')) {
        include_once(BASE_DIR . 'lib/Swift-5.0.0/lib/swift_required.php');
        require_once(BASE_DIR . 'lib/smarty/libs/Smarty.class.php');
    }

    $email_address = ADMIN_EMAIL;

    if(defined('ERROR_MAIL'))
    {
        $email_address = ERROR_MAIL;
    }

    /* create email message */
    $message = Swift_Message::newInstance()
        ->setSubject($subject)
        ->setFrom($email_address)
        ->setTo($email_address)
        ->setBody($body);

    /* mark message as html */
    $message->setContentType('text/html');

    if(MAIL_DEBUG) {
        /* debug: log mails to file otherwise send via swift */
        $mail = $message->getHeaders()->get('To');
        $mail .= $message->getHeaders()->get('Subject');
        $message->getHeaders()->remove('To');
        $message->getHeaders()->remove('Subject');
        $mail .= $message->toString();
        $mail .= "\n\n";
        $mail .= '=================================================================================================';
        $mail .= "\n";

        debug_to_file('email.log', $mail);
    } else {
        /* send */
        if($type != 'E_NOTICE') {
            global $mailer;
            $mailer->send($message);
        }
    }

    /* output clean page for errors other than type E_NOTICE */
    if($type != 'E_NOTICE') {
        ob_clean();

        global $smarty;
        header(http_response_status_code(500));
        print html($smarty->fetch('error/500.tpl'), error_layout());
    }
}

/* write $content to $file */
function debug_to_file($file, $content) {
    file_put_contents(BASE_DIR . '.debug/' . $file, $content);
}
