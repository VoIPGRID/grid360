<?php

// Menu items
define('MENU_ITEM_REPORT', 'Report');

// Admin/Manager menu items
define('MENU_ITEM_DEPARTMENTS', 'Departments');
define('MENU_ITEM_USERS', 'Users');
define('MENU_ITEM_ROLES', 'Roles');
define('MENU_ITEM_COMPETENCIES', 'Competencies');
define('MENU_ITEM_ROUNDS', 'Round overview');

// General text
define('TEXT_COMMENTS', 'Comments');
define('TEXT_COMPETENCIES', 'Competencies');
define('TEXT_PENDING', 'Pending review');
define('TEXT_COMPLETED', 'Completed');
define('TEXT_ROUND_IN_PROGRESS', 'Round in progress');

// General table headers
define('TH_NAME', 'Name');
define('TH_FIRSTNAME', 'First name');
define('TH_LASTNAME', 'Last name');
define('TH_DATE', 'Date');
define('TH_DESCRIPTION', 'Description');
define('TH_DEPARTMENT', 'Department');
define('TH_ROLE', 'Role');

// General form buttons
define('BUTTON_CANCEL', 'Cancel');
define('BUTTON_PREVIOUS', 'Previous');
define('BUTTON_NEXT', 'Next');
define('BUTTON_SUBMIT', 'Submit');

// Dashboard
define('DASHBOARD_REVIEW_STATUS', 'Review status');
define('DASHBOARD_REPORTS', 'Reports');
define('DASHBOARD_VIEW_REPORT', 'View');
define('DASHBOARD_NO_REPORTS', 'No reports found');
define('DASHBOARD_NO_ROUND', 'No round info found');

// Report
define('NO_REPORTS_FOUND', 'No reports found');
define('REPORT_PAGE_HEADER', 'Report for %s %s of %s');
define('REPORT_PREVIOUS', 'Previous report');
define('REPORT_NEXT', 'Next report');
define('REPORT_COMMENTS_HEADER', 'Comments');
define('REPORT_ALL_COMMENTS', 'All comments');
define('REPORT_EXTRA_QUESTION', 'Extra question');
define('REPORT_NO_REVIEWS', 'No reviews found for this round');
define('REPORT_INSUFFICIENT_DATA', 'Insufficient data available to generate a report.
<br />%d of %d people have reviewed you.
<br />A minimum of 5 people is needed to generate a report.');

// Report options
define('REPORT_OPTIONS_HEADER', 'Options');
define('REPORT_SHOW_OPTIONS', 'show');
define('REPORT_HIDE_OPTIONS', 'hide');
define('REPORT_OPTIONS_COMPETENCIES_HEADER', 'Competencies');
define('REPORT_OPTIONS_RATINGS_HEADER', 'Ratings');
define('REPORT_OPTIONS_SHOW_AVERAGE', 'Show average');
define('REPORT_OPTIONS_SHOW_OWN', 'Show own');
define('REPORT_OPTIONS_SHOW_COMPARISONS', 'Show comparisons');
define('REPORT_OPTIONS_SELECT_ALL', 'Select all');
define('REPORT_OPTIONS_DESELECT_ALL', 'Deselect all');

// Report graph
define('REPORT_GRAPH_HEADER', 'Ratings');
define('REPORT_GRAPH_POINTS', 'Points');
define('REPORT_GRAPH_AVERAGE', 'Average');
define('REPORT_GRAPH_OWN', 'Own');
define('REPORT_GRAPH_REVIEW_TEXT_SINGLE', 'review');
define('REPORT_GRAPH_REVIEW_TEXT', 'reviews');

// Feedback overview
define('FEEDBACK_OVERVIEW_HEADER', 'Round overview');
define('FEEDBACK_INFO_SELF', 'You haven\'t review yourself yet!');
define('FEEDBACK_INFO_SELF_BUTTON', 'Click here to review yourself.');
define('FEEDBACK_INFO_PENDING', ' You have pending reviews! Click the review button next to an open review to review that person.');
define('FEEDBACK_REVIEW_BUTTON', 'Review');
define('FEEDBACK_REVIEWEE_NAME', 'Name reviewee');
define('FEEDBACK_OVERVIEW_NO_ROUND', 'No round in progress');
define('FEEDBACK_OVERVIEW_EDIT', 'Edit comments');

// Feedback steps
define('FEEDBACK_INFO_COMPETENCY_DESCRIPTION', 'U kunt de beschrijving van een competentie lezen door uw muis over de competentie te bewegen');
define('FEEDBACK_SKIP_BUTTON', 'Skip person');
define('FEEDBACK_HEADER_STEP_1', 'Select 3 positive competencies for ');
define('FEEDBACK_HEADER_STEP_2', 'Select 2 points of improvement for ');
define('FEEDBACK_HEADER_TEXT_SELF', 'yourself');
define('FEEDBACK_SKIP_HEADER', 'Skip person');
define('FEEDBACK_SKIP_TEXT', 'Are you sure you don\'t want to review %s %s?');
define('FEEDBACK_SKIP_WARNING_BOLD', 'Warning!');
define('FEEDBACK_SKIP_WARNING_TEXT', 'You won\'t be able to review this person again this round.');
define('FEEDBACK_STEP_TEXT', 'Step %d of 3');

// Feedback form
define('FEEDBACK_FORM_HEADER_STEP_3', 'Rate the chosen competencies for %s %s');
define('FEEDBACK_FORM_POSITIVE_COMPETENCIES', 'Positive competencies');
define('FEEDBACK_FORM_NEGATIVE_COMPETENCIES', 'Points of improvement');
define('FEEDBACK_FORM_EXTRA_QUESTION_HEADER', 'Extra question');
define('FEEDBACK_FORM_EXTRA_QUESTION', 'In what way has %s %s contributed to the success of the organisation?');
define('FEEDBACK_FORM_EXTRA_QUESTION_SELF', 'In what way have you contributed to the success of the organisation?');
define('FEEDBACK_FORM_COMMENT_PLACEHOLDER', 'Add a comment for the competency %s here');
define('FEEDBACK_FORM_INFO', '<strong>Notice:</strong> Feedback, positive as well as constructive is directly viewable for your colleagues. Keep this in mind when writing comments');
define('FEEDBACK_FORM_LOGOUT_WARNING', 'Make sure you submit this form within %d %s. Otherwise you will be automatically logged out.');
define('FEEDBACK_FORM_LOGOUT_WARNING_MINUTES', 'minutes');
define('FEEDBACK_FORM_LOGOUT_WARNING_HOUR', 'hour');
define('FEEDBACK_FORM_LOGOUT_WARNING_HOURS', 'hours');

// Messages
define('MESSAGE_REVIEW_SUCCESS', 'Your review for %s %s has been saved');
