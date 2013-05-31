<?php

function show_error($error_message, $type = 0)
{
    echo '<h1>Error!</h1>';
    if($type == 1)
    {
        echo $error_message . '<br />';
        echo 'You can fix this error by creating a config file (local.php or production.php) in your /configs folder and setting it up correctly';
    }
    else
    {
        echo 'There seems to be something wrong, please contact the administrator! <br />';
        echo $error_message;
    }
}

function get_userlevels()
{
    return R::$adapter->getAssoc('select id, name from userlevel');
}

function get_current_round()
{
    return R::findOne('round', 'status = ? ORDER BY id DESC', array(ROUND_IN_PROGRESS));
}

function get_general_competencies()
{
    return R::findOne('competencygroup', 'general = ?', array(1)); // TODO: Multiple general competencies allowed?
}
