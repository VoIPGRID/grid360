<?php

// Menu items
define('MENU_ITEM_REPORT', 'Rapport');

// Admin/Manager menu items
define('MENU_ITEM_DEPARTMENTS', 'Afdelingen');
define('MENU_ITEM_USERS', 'Gebruikers');
define('MENU_ITEM_ROLES', 'Rollen');
define('MENU_ITEM_COMPETENCIES', 'Competenties');
define('MENU_ITEM_ROUNDS', 'Overzicht ronde');

// General text
define('TEXT_COMMENTS', 'Commentaar');
define('TEXT_COMPETENCIES', 'Competenties');
define('TEXT_PENDING', 'Niet beoordeeld');
define('TEXT_COMPLETED', 'Voltooid');
define('TEXT_ROUND_IN_PROGRESS', 'Ronde bezig');

// General table headers
define('TH_NAME', 'Naam');
define('TH_FIRSTNAME', 'Voornaam');
define('TH_LASTNAME', 'Achternaam');
define('TH_DATE', 'Datum');
define('TH_DESCRIPTION', 'Omschrijving');
define('TH_DEPARTMENT', 'Afdeling');
define('TH_ROLE', 'Rol');

// General form buttons
define('BUTTON_CANCEL', 'Annuleren');
define('BUTTON_PREVIOUS', 'Vorige');
define('BUTTON_NEXT', 'Volgende');
define('BUTTON_SUBMIT', 'Verzenden');

// Dashboard
define('DASHBOARD_REVIEW_STATUS', 'Status beoordelingen');
define('DASHBOARD_REPORTS', 'Rapporten');
define('DASHBOARD_VIEW_REPORT', 'Bekijken');
define('DASHBOARD_NO_REPORTS', 'Geen rapporten gevonden');
define('DASHBOARD_NO_ROUND', 'Geen rondegegevens gevonden');

// Report
define('NO_REPORTS_FOUND', 'Geen rapporten gevonden');
define('REPORT_PAGE_HEADER', 'Rapport voor %s %s van %s');
define('REPORT_PREVIOUS', 'Vorige rapport');
define('REPORT_NEXT', 'Volgende rapport');
define('REPORT_COMMENTS_HEADER', 'Commentaar');
define('REPORT_ALL_COMMENTS', 'Alle commentaar');
define('REPORT_EXTRA_QUESTION', 'Extra vraag');
define('REPORT_NO_REVIEWS', 'Geen beoordelingen gevonden voor deze ronde');
define('REPORT_INSUFFICIENT_DATA', 'Niet genoeg data beschikbaar om een rapport te genereren.
<br />%d van de %d mensen hebben u beoordeeld.
<br />Een minimum van 5 mensen is nodig om een rapport te genereren.');

// Report options
define('REPORT_OPTIONS_HEADER', 'Opties');
define('REPORT_SHOW_OPTIONS', 'toon');
define('REPORT_HIDE_OPTIONS', 'verberg');
define('REPORT_OPTIONS_COMPETENCIES_HEADER', 'Competenties');
define('REPORT_OPTIONS_RATINGS_HEADER', 'Beoordelingen');
define('REPORT_OPTIONS_SHOW_AVERAGE', 'Toon gemiddelde');
define('REPORT_OPTIONS_SHOW_OWN', 'Toon eigen');
define('REPORT_OPTIONS_SHOW_COMPARISONS', 'Toon vergelijkingen');
define('REPORT_OPTIONS_SELECT_ALL', 'Selecteer alles');
define('REPORT_OPTIONS_DESELECT_ALL', 'Deselecteer alles');

// Report graph
define('REPORT_GRAPH_HEADER', 'Beoordelingen');
define('REPORT_GRAPH_POINTS', 'Punten');
define('REPORT_GRAPH_AVERAGE', 'Gemiddelde');
define('REPORT_GRAPH_OWN', 'Eigen');

// Feedback overview
define('FEEDBACK_OVERVIEW_HEADER', 'Overzicht beoordelingsronde');
define('FEEDBACK_INFO_SELF', 'U heeft uzelf nog niet beoordeeld!');
define('FEEDBACK_INFO_SELF_BUTTON', 'Klik hier om uzelf te beoordelen.');
define('FEEDBACK_INFO_PENDING', 'U heeft openstaande beoordelingen. Klik de \'Beoordeel\' knop naast een naam om die persoon te beoordelen.');
define('FEEDBACK_REVIEW_BUTTON', 'Beoordeel');
define('FEEDBACK_REVIEWEE_NAME', 'Naam beoordeelde');
define('FEEDBACK_OVERVIEW_NO_ROUND', 'Geen ronde bezig');

// Feedback steps
define('FEEDBACK_INFO_COMPETENCY_DESCRIPTION', 'U kunt de beschrijving van een competentie lezen door uw muis over de competentie te bewegen');
define('FEEDBACK_SKIP_BUTTON', 'Persoon overslaan');
define('FEEDBACK_HEADER_STEP_1', 'Selecteer 3 positieve competenties voor ');
define('FEEDBACK_HEADER_STEP_2', 'Selecteer 2 verbeterpunten voor ');
define('FEEDBACK_SKIP_HEADER', 'Persoon overslaan');
define('FEEDBACK_SKIP_TEXT', 'Weet u zeker dat u %s %s niet wilt beoordelen?');
define('FEEDBACK_SKIP_WARNING_BOLD', 'Waarschuwing!');
define('FEEDBACK_SKIP_WARNING_TEXT', 'U kunt deze persoon deze ronde niet weer beoordelen.');

// Feedback form
define('FEEDBACK_FORM_POSITIVE_COMPETENCIES', 'Positieve competenties');
define('FEEDBACK_FORM_NEGATIVE_COMPETENCIES', 'Verbeterpunten');
define('FEEDBACK_FORM_EXTRA_QUESTION_HEADER', 'Extra vraag');
define('FEEDBACK_FORM_EXTRA_QUESTION', 'In welke zin heeft %s %s bijgedragen aan het success van de organisatie?');
define('FEEDBACK_FORM_EXTRA_QUESTION_SELF', 'In welke zin heeft u bijgedragen aan het success van de organisatie?');
define('FEEDBACK_FORM_COMMENT_PLACEHOLDER', 'Voeg hier commentaar toe voor de competentie %s');
define('FEEDBACK_FORM_INFO', 'Let op: Feedback, zowel positief als opbouwend is direct leesbaar voor je collega\'s. Houd daar rekening mee in de opbouw van je commentaar');

// Messages
define('MESSAGE_REVIEW_SUCCESS', 'Uw beoordeling voor %s is opgeslagen');
