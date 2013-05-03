<?php

function show_error($error_message, $type = 0)
{
    echo '<h1>Error!</h1>';
    echo $error_message . '<br />';
    if($type == 1)
    {
        echo 'You can fix this error by creating a production.php in your /configs folder and setting it up correctly';
    }
    else
    {
        echo 'There seems to be something wrong, please contact the administrator!';
    }
}

function get_userlevels()
{
    $userlevels = R::$adapter->getAssoc('select id, name from userlevel');

    return $userlevels;
}
