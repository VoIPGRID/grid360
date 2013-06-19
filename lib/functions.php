<?php

function show_error($error_message, $type = 0)
{
    echo '<h1>Error!</h1>';
    if($type == 1)
    {
        echo $error_message . '<br />';
        echo 'You can fix this error by creating a config file (local.php or production.php) in your /configs folder and setting it up correctly';
    }
    else
    {
        echo 'There seems to be something wrong, please contact the administrator! <br />';
        echo $error_message;
    }
}

function send_mail($subject, $from, $to, $body)
{
    $message = Swift_Message::newInstance()
        ->setSubject($subject)
        ->setFrom($from)
        ->setTo($to)
        ->setBody($body);

    global $mailer;

    $mailer->send($message);
}

function validate_form($keys_to_check)
{
    $form_values = array();

    // This array is used to provide translations for the various fields
    $labels = array
    (
        'name' => _('name'),
        'firstname' => _('first name'),
        'lastname' => _('last name'),
        'email' => _('email'),
        'department' => _('department'),
        'competencygroup' => _('competency group'),
        'competency' => _('competency'),
        'role' => _('role'),
        'userlevel' => _('user level'),
        'user' => _('user')
    );

    foreach($keys_to_check as $key => $value)
    {
        if(is_array($value))
        {
            if($value['load_bean'] == true)
            {
                $bean = R::load($value['type'], $value['id']);

                // Check if the bean could be loaded and also check if the type is correct, if not, set the form error for this key
                if($bean->id == 0 || ($key == 'id' && $value['type'] != $_POST['type']) || ($key != 'id' && $value['type'] != $_POST[$key]['type']))
                {
                    $form_values[$key]['error'] = sprintf(BEAN_NOT_FOUND, $labels[$value['type']]);
                }
                else if($key == 'user' && $bean->userlevel->level != ADMIN && $bean->userlevel->level != MANAGER)
                {
                    // If a department is being made, the given user must be an admin or manager, if not, set the form error for this key
                    $form_values[$key]['error'] = sprintf(BEAN_NOT_FOUND, $value['type']);
                }
            }

            // If a bean needs to be loaded, $value is an array, so a different variable must be set for $form_values
            $form_values[$key]['value'] = $value['id'];
        }
        else
        {
            $form_values[$key]['value'] = $value;
        }

        if(!is_array($value) && (!isset($value) || strlen(trim($value)) == 0))
        {
            $field = $labels[$key];
            $form_values[$key]['error'] = sprintf(FIELD_REQUIRED, $field);
        }
        else if($key == 'email' && !filter_var($value, FILTER_VALIDATE_EMAIL))
        {
            $form_values[$key]['error'] = INVALID_EMAIL_FORMAT;
        }
    }

    return $form_values;
}

function get_userlevels()
{
    return R::$adapter->getAssoc('SELECT id, name FROM userlevel');
}

function get_current_round()
{
    return R::findOne('round', 'status = ? ORDER BY id DESC', array(ROUND_IN_PROGRESS));
}

function get_general_competencies()
{
    return R::findOne('competencygroup', 'general = ?', array(1)); // TODO: Multiple general competencies allowed?
}

// Credits to http://www.php.net/manual/en/function.uniqid.php#94959 for the following two functions
function random_uuid()
{
    return sprintf('%04x%04x-%04x-%04x-%04x-%04x%04x%04x',

        // 32 bits for "time_low"
        mt_rand(0, 0xffff), mt_rand(0, 0xffff),

        // 16 bits for "time_mid"
        mt_rand(0, 0xffff),

        // 16 bits for "time_hi_and_version",
        // four most significant bits holds version number 4
        mt_rand(0, 0x0fff) | 0x4000,

        // 16 bits, 8 bits for "clk_seq_hi_res",
        // 8 bits for "clk_seq_low",
        // two most significant bits holds zero and one for variant DCE1.1
        mt_rand(0, 0x3fff) | 0x8000,

        // 48 bits for "node"
        mt_rand(0, 0xffff), mt_rand(0, 0xffff), mt_rand(0, 0xffff)
    );
}

function is_valid($uuid)
{
    return preg_match('/^\{?[0-9a-f]{8}\-?[0-9a-f]{4}\-?[0-9a-f]{4}\-?'.
        '[0-9a-f]{4}\-?[0-9a-f]{12}\}?$/i', $uuid) === 1;
}

function rand_string($length)
{
    $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    return substr(str_shuffle($chars), 0, $length);
}
