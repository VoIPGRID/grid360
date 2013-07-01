<?php

global $smarty;

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

if(!empty($success))
{
    $smarty->assign('success', flash_now('success'));
}
if(!empty($error))
{
    $smarty->assign('error', flash_now('error'));
}

$smarty->display('layout/basic.tpl');

