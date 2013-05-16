<?php

global $smarty;

$smarty->assign('SERVER_REQUEST_URI', $_SERVER['REQUEST_URI']);
$smarty->assign('content', $content);

if(isset($title) && !empty($title))
{
    $smarty->assign('title', $title);
}
else
{
    $smarty->assign('title', APP_NAME);
}
$smarty->display('layout/layout.tpl');
