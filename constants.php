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

// User specific constants
define('PAUSE_USER_REVIEWS', 0);

// Form messages
define('FIELD_REQUIRED', _('%s is required!'));
define('CREATE_SUCCESS', _('Successfully added %s %s'));
define('UPDATE_SUCCESS', _('Successfully updated %s %s'));
define('DELETE_SUCCESS', _('Successfully deleted %s %s'));

define('BEAN_NOT_FOUND', _('Error loading %s, please try again.'));
define('INVALID_EMAIL_FORMAT', _('Email is not formatted correctly!'));
define('EMAIL_EXISTS', _('Email already exists!'));
