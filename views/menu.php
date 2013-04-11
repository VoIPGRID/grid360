<?php

function checkActive($requestUri, $extra_css_classes = '')
{
    if ($requestUri == BASE_URI && $_SERVER['REQUEST_URI'] ==  $requestUri) {
        echo 'class="active ' . $extra_css_classes . '"';
    } else if (strpos($_SERVER['REQUEST_URI'], BASE_URI . $requestUri) === 0) {
        echo 'class="active ' . $extra_css_classes . '"';
    } else {
        echo 'class="' . $extra_css_classes . '"';
    }
}

?><!DOCTYPE HTML>
<html>
<head>
    <title>GRID360</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="<?php echo BASE_URI; ?>lib/bootstrap/css/bootstrap.css" rel="stylesheet">
    <link href="<?php echo BASE_URI; ?>lib/bootstrap/css/bootstrap-responsive.css" rel="stylesheet">
    <link href="<?php echo BASE_URI; ?>lib/css/css.css" rel="stylesheet">
    <script src="//code.jquery.com/jquery-latest.js"></script>
    <script type="text/javascript" src="<?php echo BASE_URI; ?>lib/bootstrap/js/bootstrap.js"></script>
</head>
<body>
<div class = "container">
    <div class="navbar">
        <div class="navbar-inner">
            <a class="brand" href="http://www.voipgrid.nl">V</a>
            <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </a>
            <div class="nav-collapse collapse">
                <ul class="nav">
                    <li <?php checkActive(BASE_URI); ?> ><a href="<?php echo BASE_URI; ?>"><i class="icon-home"></i> Dashboard</a></li>
                    <li <?php checkActive("report"); ?> ><a href="<?php echo BASE_URI; ?>report"><i class="icon-file"></i> Report</a></li>
                    <li <?php checkActive("feedback"); ?> ><a href="<?php echo BASE_URI; ?>feedback"><i class="icon-bullhorn"></i> Feedback</a></li>
                </ul>
                <ul class="nav pull-right">
                    <li <?php checkActive("admin", "dropdown"); ?>>
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <i class="icon-wrench"></i> Admin
                            <b class="caret"></b>
                        </a>

                        <ul class="dropdown-menu">
                            <li <?php checkActive("departments"); ?> ><a href="<?php echo ADMIN_URI; ?>departments">Departments</a></li>
                            <li <?php checkActive("users"); ?> ><a href="<?php echo ADMIN_URI; ?>users">Users</a></li>
                            <li <?php checkActive("roles"); ?> ><a href="<?php echo MANAGER_URI; ?>roles">Roles</a></li>
                            <li <?php checkActive("competencies"); ?> ><a href="<?php echo MANAGER_URI; ?>competencies">Competencies</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>