<?php

// Userlevels
define('ADMIN', 1);
define('MANAGER', 2);
define('EMPLOYEE', 3);
define('ANONYMOUS', 4);

// Round specific constants
define('ROUND_IN_PROGRESS', 1);
define('ROUND_COMPLETED', 0);

// Roundinfo specific constants
define('REVIEW_IN_PROGRESS', 0);
define('REVIEW_COMPLETED', 1);
define('REVIEW_SKIPPED', 2);

// User specific constant
define('PAUSE_USER_REVIEWS', 0);

// Messages
define('FIELD_REQUIRED', '%s is required!');
define('CREATE_SUCCESS', 'Successfully added %s %s');
define('UPDATE_SUCCESS', 'Successfully updated %s %s');
define('DELETE_SUCCESS', 'Successfully deleted %s %s');
