<?php

include_once(dirname(__FILE__) . '/lib/functions.php');
include_once(dirname(__FILE__) . '/lib/security.php');
include_once(dirname(__FILE__) . '/lib/Swift-5.0.0/lib/swift_required.php');
require_once(dirname(__FILE__) . '/lib/smarty/libs/Smarty.class.php');

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
define('ASSETS_DIR', BASE_DIR . 'assets/');

define('BASE_URI', SUB_DIR);
define('ASSETS_URI', BASE_URI . 'assets/');
define('ADMIN_URI', 'admin/');
define('MANAGER_URI', 'manager/');

define('ASSET_COMPILE_OUTPUT_DIR', BASE_DIR . 'public');
define('ASSET_COMPILE_URL_ROOT', BASE_URI . 'public');
define('SACY_WRITE_HEADERS', false);

set_include_path(get_include_path() . PATH_SEPARATOR . LIB_DIR . 'google-api-client/src');

/* Setup i18n */
$supported_locales = array(
    'en' => 'en_US',
    'en_US' => 'en_US',
    'en_US.UTF-8' => 'en_US',
    'nl' => 'nl_NL',
    'nl_NL' => 'nl_NL',
    'nl_NL.UTF-8' => 'nl_NL',
);
$default_locale = 'nl';
$locale = get_current_locale();

setlocale(LC_ALL, $locale);
putenv('LANG=' . $locale);

$domain = 'messages';
bindtextdomain($domain, BASE_DIR . '/locale');
bind_textdomain_codeset($domain, 'UTF-8');
textdomain($domain);

$smarty = new Smarty();
$smarty->setTemplateDir(BASE_DIR . 'views/');
$smarty->setCompileDir(BASE_DIR . 'views/templates_c');
$smarty->escape_html = true;
