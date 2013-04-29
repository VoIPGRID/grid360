<?php

error_reporting(E_ALL ^ E_NOTICE);

define('SUB_DIR', '/yoursubdir/');

define('DB_HOSTNAME', 'yourhost.com');
define('DB_NAME', 'yourdatabase');
define('DB_USERNAME', 'youruser');
define('DB_PASSWORD', 'yourpass');
define('CONNECTION', 'mysql:host=' . DB_HOSTNAME . ';dbname=' . DB_NAME);

define('APPNAME', 'yourappname');
