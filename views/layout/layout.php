<?php

global $smarty;

$smarty->assign('SERVER_REQUEST_URI', $_SERVER['REQUEST_URI']);
$smarty->assign('content', $content);

if(!empty($title))
{
    $smarty->assign('title', $title);
}
else
{
    $smarty->assign('title', APP_NAME);
}

$success = flash_now('success');
$error = flash_now('error');
$warning = flash_now('warning');
$info = flash_now('info');

if(!empty($success))
{
    $smarty->assign('success', flash_now('success'));
}
if(!empty($error))
{
    $smarty->assign('error', flash_now('error'));
}
if(!empty($warning))
{
    $smarty->assign('warning', flash_now('warning'));
}
if(!empty($info))
{
    $smarty->assign('info', flash_now('info'));
}

$smarty->display('layout/layout.tpl');
