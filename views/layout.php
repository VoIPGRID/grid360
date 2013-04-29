<?php
/**
 * @author epasagic
 * @date 24-4-13
 */

global $smarty;

$smarty->assign('SERVER_REQUEST_URI', $_SERVER['REQUEST_URI']);
$smarty->assign('content', $content);

if(isset($title) && !empty($title))
{
    $smarty->assign('title', $title);
}
else
{
    $smarty->assign('title', APPNAME);
}

$smarty->display('layout.tpl');
