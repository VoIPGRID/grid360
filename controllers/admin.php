<?php

require_once(LIB_DIR . 'htmlpurifier-4.5.0/HTMLPurifier.standalone.php');

function create_info_message()
{
    security_authorize(ADMIN);

    global $smarty;

    return html($smarty->fetch('admin/info_message.tpl'));
}

function info_message_post()
{
    security_authorize(ADMIN);

    $info_message = R::findOne('infomessage');

    if($info_message->id == 0)
    {
        $info_message = R::dispense('infomessage');
    }

    $config = HTMLPurifier_Config::createDefault();

    // Makes sure external resources gets removed from the HTML
    $config->set('URI.DisableExternalResources', true);

    $purifier = new HTMLPurifier($config);
    $clean_html = $purifier->purify($_POST['info_message']);

    $info_message->message = $clean_html;

    if($info_message->id != 0)
    {
        $message = sprintf(UPDATE_SUCCESS, _('info message'), '');
    }
    else
    {
        $message = sprintf(CREATE_SUCCESS, _('info message'), '');
    }

    R::store($info_message);

    flash('success', $message);
    redirect_to(ADMIN_URI . 'infomessage/overview');
}

function info_message_overview()
{
    security_authorize(ADMIN);

    global $smarty;

    $info_message = R::findOne('infomessage');

    if($info_message->id != 0)
    {
        $smarty->assign('info_message', $info_message);
    }

    $smarty->assign('page_header', _('Info message overview'));

    return html($smarty->fetch('admin/info_message_overview.tpl'));
}

function edit_info_message()
{
    security_authorize(ADMIN);

    global $smarty;

    $info_message = R::findOne('infomessage');

    $smarty->assign('info_message', $info_message);

    return html($smarty->fetch('admin/info_message.tpl'));
}

function meetings_overview()
{
    security_authorize(ADMIN);

    global $smarty;

    $rounds = R::findAll('round');

    $smarty->assign('rounds', $rounds);

    return html($smarty->fetch('admin/meeting_overview.tpl'));
}

function view_round_meetings()
{
    security_authorize(ADMIN);

    global $smarty;

    $round = R::load('round', params('id'));

    if($round->id == 0)
    {
        $message = sprintf(BEAN_NOT_FOUND, _('round'));
        flash('error', $message);
        redirect_to('meetings');
    }

    $meetings = R::find('meeting', 'round_id = ?', array($round->id));
    R::preload($meetings, array('with' => 'user'));

    $smarty->assign('meetings', $meetings);

    return html($smarty->fetch('admin/round_meetings.tpl'));
}

function report_overview()
{
    security_authorize(ADMIN);

    global $smarty;

    $users = R::findAll('user', ' ORDER BY firstname');

    $smarty->assign('users', $users);
    $smarty->assign('page_header', _('Users'));

    return html($smarty->fetch('admin/report_overview.tpl'));
}