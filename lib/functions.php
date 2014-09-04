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

    $message->setContentType('text/html');

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
        'user' => _('user'),
        'organisation_name' => _('organisation name'),
        'password' => _('password')
    );

    foreach($keys_to_check as $key => $value)
    {
        if(is_array($value))
        {
            if($value['load_bean'] == true)
            {
                $bean = R::load($value['type'], $value['id']);

                if($bean->id == 0 || ($key == 'id' && $value['type'] != $_POST['type']) || ($key != 'id' && $value['type'] != $_POST[$key]['type']))
                {
                    // Check if the bean could be loaded and also check if the type is correct, if not, set the form error for this key
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
        else if($key == 'email')
        {
            if(!filter_var($value, FILTER_VALIDATE_EMAIL))
            {
                $form_values[$key]['error'] = INVALID_EMAIL_FORMAT;
            }
            else
            {
                // Using getCell here because I want to ignore the multitenancy query for this
                $user_id = R::getCell('SELECT id FROM user WHERE email = ?', array($value));

                if($user_id != 0 && $user_id != $_POST['id'])
                {
                    $form_values[$key]['error'] = EMAIL_EXISTS;
                }
            }
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
    return R::findOne('competencygroup', 'general = ?', array(1));
}

function get_managers()
{
    $levels = array(ADMIN, MANAGER);

    $managers = R::$adapter->getAssoc('SELECT user.id, CONCAT(firstname, " ", lastname) as name
                                       FROM user
                                       LEFT JOIN userlevel
                                       ON userlevel.id = user.userlevel_id
                                       WHERE userlevel.level IN (' . R::genSlots($levels) . ')
                                       AND user.tenant_id = ' . $_SESSION['current_user']->tenant_id, $levels);

    return $managers;
}

function has_agreements($user_id)
{
    $agreements = R::findOne('agreements', 'user_id = ?', array($user_id));

    if($agreements->id == 0)
    {
        return false;
    }
    else if($agreements->has_agreements && (empty($agreements->work) || empty($agreements->training) || empty($agreements->goals)))
    {
        return false;
    }

    return true;
}

function get_agreements($user_id)
{
    $agreements_row = R::findOne('agreements', 'user_id = ?', array($user_id));

    $agreements = array();
    $agreements['work']['value'] = $agreements_row->work;
    $agreements['work']['label'] = _('Work agreements');
    $agreements['training']['value'] = $agreements_row->training;
    $agreements['training']['label'] = _('Training agreements');
    $agreements['other']['value'] = $agreements_row->other;
    $agreements['other']['label'] = _('Other agreements');
    $agreements['goals']['value'] = $agreements_row->goals;
    $agreements['goals']['label'] = _('Personal goals');

    return $agreements;
}

function get_current_locale()
{
    global $supported_locales, $default_locale;

    /* Check if browser accepts en_US or nl_NL or ? */
    if(function_exists('locale_accept_from_http')) {
        $browser_locale = locale_accept_from_http($_SERVER['HTTP_ACCEPT_LANGUAGE']);
        if($browser_locale && array_key_exists($browser_locale, $supported_locales))
        {
            /* disable this line to force $default_locale */
            return $supported_locales[$browser_locale];
        }
    }

    /* if browser locale is not supported, set default */
    return $supported_locales[$default_locale];
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

// Credits to http://www.php.net/manual/en/function.debug-print-backtrace.php#86932
function debug_string_backtrace()
{
    ob_start();
    debug_print_backtrace();
    $trace = ob_get_contents();
    ob_end_clean();

    $trace = preg_replace ('/^#0\s+' . __FUNCTION__ . "[^\n]*\n/", '', $trace, 1);
    $trace = preg_replace ('/^#(\d+)/me', '\'#\' . ($1 - 1)', $trace);

    return $trace;
}

function englishify_date($date_str)
{
    $dutch = array('Jan', 'Feb', 'Mrt', 'Apr', 'Mei', 'Jun', 'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dec');
    $english = array('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
    return str_ireplace($dutch, $english, $date_str);
}

function unaccent_string($string)
{
    $normalize_chars = array(
        'Š'=>'S', 'š'=>'s', 'Ð'=>'Dj','Ž'=>'Z', 'ž'=>'z', 'À'=>'A', 'Á'=>'A', 'Â'=>'A', 'Ã'=>'A', 'Ä'=>'A',
        'Å'=>'A', 'Æ'=>'A', 'Ç'=>'C', 'È'=>'E', 'É'=>'E', 'Ê'=>'E', 'Ë'=>'E', 'Ì'=>'I', 'Í'=>'I', 'Î'=>'I',
        'Ï'=>'I', 'Ñ'=>'N', 'Ò'=>'O', 'Ó'=>'O', 'Ô'=>'O', 'Õ'=>'O', 'Ö'=>'O', 'Ø'=>'O', 'Ù'=>'U', 'Ú'=>'U',
        'Û'=>'U', 'Ü'=>'U', 'Ý'=>'Y', 'Þ'=>'B', 'ß'=>'Ss','à'=>'a', 'á'=>'a', 'â'=>'a', 'ã'=>'a', 'ä'=>'a',
        'å'=>'a', 'æ'=>'a', 'ç'=>'c', 'è'=>'e', 'é'=>'e', 'ê'=>'e', 'ë'=>'e', 'ì'=>'i', 'í'=>'i', 'î'=>'i',
        'ï'=>'i', 'ð'=>'o', 'ñ'=>'n', 'ò'=>'o', 'ó'=>'o', 'ô'=>'o', 'õ'=>'o', 'ö'=>'o', 'ø'=>'o', 'ù'=>'u',
        'ú'=>'u', 'û'=>'u', 'ý'=>'y', 'ý'=>'y', 'þ'=>'b', 'ÿ'=>'y', 'ƒ'=>'f',
        'ă'=>'a', 'î'=>'i', 'â'=>'a', 'ș'=>'s', 'ț'=>'t', 'Ă'=>'A', 'Î'=>'I', 'Â'=>'A', 'Ș'=>'S', 'Ț'=>'T',
    );

    return strtr($string, $normalize_chars);
}

/**
 * Sets up the url which is used when the user logs in with Google
 * @return string the redirect url
 */
function get_redirect_url()
{
    if(isset($_SERVER['HTTPS']))
    {
        $protocol = ($_SERVER['HTTPS'] && $_SERVER['HTTPS'] != 'off') ? 'https' : 'http';
    }
    else
    {
        $protocol = 'http';
    }

    return $protocol . '://' . $_SERVER['HTTP_HOST'] . BASE_URI . 'login_google';
}
