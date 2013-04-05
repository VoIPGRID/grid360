<?php

error_reporting(E_ALL ^ E_NOTICE);

define('SUB_DIR', '/yoursubdir');

define('HOSTNAME', 'yourhost.com');
define('DBNAME', 'yourdatabase');
define('USERNAME', 'youruser');
define('PASSWORD', 'yourpass');
define('CONNECTION', 'mysql:host=' . HOSTNAME . ';dbname=' . DBNAME);