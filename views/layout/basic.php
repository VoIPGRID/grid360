<?php

global $smarty;

$smarty->assign('content', $content);

if(isset($title) && !empty($title))
{
    $smarty->assign('title', $title);
}
else
{
    $smarty->assign('title', APPNAME);
}

$smarty->display('layout/basic.tpl');

