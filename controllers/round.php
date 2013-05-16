<?php

function create_round()
{
    security_authorize(ADMIN);

    if(get_current_round()->id != 0)
    {
        return html('Round already in progress');
    }

    global $smarty;

    if(isset($_GET['error']))
    {
        $smarty->assign('error_type', $_GET['error']);

        if(isset($_GET['description']))
        {
            $smarty->assign('description', $_GET['description']);
        }
        if(isset($_GET['min_own']))
        {
            $smarty->assign('min_own', $_GET['min_own']);
        }
        if(isset($_GET['max_own']))
        {
            $smarty->assign('max_own', $_GET['max_own']);
        }
        if(isset($_GET['min_other']))
        {
            $smarty->assign('min_other', $_GET['min_other']);
        }
        if(isset($_GET['max_other']))
        {
            $smarty->assign('max_other', $_GET['max_other']);
        }
    }

    return html($smarty->fetch('round/round.tpl'));
}

function start_round_confirmation()
{
    security_authorize(ADMIN);

    if(get_current_round()->id != 0)
    {
        return html('A round is already in progress!');
    }

    validate_round_form();

    global $smarty;
    return html($smarty->fetch('round/start_round_confirmation.tpl'));
}

function start_round()
{
    security_authorize(ADMIN);

    if(!validate_round_form())
    {
        return false;
    }

    if(get_current_round()->id != 0)
    {
        return html('A round is already in progress!');
    }

    $round = R::dispense('round');
    $round->description = $_POST['description'];
    $users = R::findAll('user'); // TODO: Add tenant id
    $random_number = 0;

    $min_own = $_POST['min_own'];
    $max_own = $_POST['max_own'];
    $min_other = $_POST['min_other'];
    $max_other = $_POST['max_other'];

    $index = 0;

    foreach($users as $reviewer)
    {
        $own_department_users = R::find('user', 'department_id = ?', array($reviewer->department->id));
        $other_department_users = R::find('user', 'department_id != ?', array($reviewer->department->id));

        $count_own_department = count($own_department_users);

        if($count_own_department > 1)
        {
            // Calculate a random number between $min_own and $max_own
            $min = intval($count_own_department * ($min_own / 100));
            $max = intval($count_own_department * ($max_own / 100));
            $random_number = rand($min, $max);

            if($random_number < 2)
            {
                $random_number = 2;
            }
        }

        // Grab $random_number amount of users
        $own_department_user_ids = array_rand($own_department_users, $random_number);

        // Grab the beans with the ids in $user_ids
        $own_random_users = array();
        for($i = 0; $i < count($own_department_user_ids); $i++)
        {
            $own_random_users[] = $own_department_users[$own_department_user_ids[$i]];
        }

        // Get random users of other departments if > 1
        if($count_own_department > 1)
        {
            $count_other_department = count($other_department_users);

            // Calculate a random number between $min_other and $max_other
            $min = intval($count_other_department * ($min_other / 100));
            $max = intval($count_other_department * ($max_other / 100));
            $random_number = rand($min, $max);

            if($random_number < 2)
            {
                $random_number = 2;
            }
        }

        // Grab $random_number amount of users
        $user_ids = array_rand($other_department_users, $random_number);

        // Grab the beans with the ids in $user_ids
        $random_users = array();
        for($i = 0; $i < count($user_ids); $i++)
        {
            $random_users[] = $other_department_users[$user_ids[$i]];
        }

        // Merge all the random users into one reviewee array
        $reviewees = array_merge($own_random_users, $random_users);

        // You always have to review yourself, so add own user to reviewees if it isn't in the array yet
        if(!in_array($reviewer->id, $own_department_user_ids))
        {
            $reviewees[] = $reviewer;
        }

        $roundinfo = R::dispense('roundinfo', count($reviewees));

        // Create the roundinfo
        foreach($reviewees as $user_id => $reviewee)
        {
            $roundinfo[$user_id]->status = 0;
            $roundinfo[$user_id]->answer = '';
            $roundinfo[$user_id]->round = $round;
            $roundinfo[$user_id]->reviewer = $reviewer;
            $roundinfo[$user_id]->reviewee = $reviewee;

            $index++;
        }

        R::storeAll($roundinfo);
    }

    $round->status = 1;
    $round->created = R::isoDateTime();

    R::store($round);

    return html('Round created!');
}

function round_overview()
{
    security_authorize(ADMIN);
    $round = get_current_round();
    $completed_reviews = R::count('roundinfo', 'round_id = ? AND status = ?', array($round->id, REVIEW_COMPLETED));
    global $smarty;
    $smarty->assign('round', $round);
    $smarty->assign('completed_reviews', $completed_reviews);
    $smarty->assign('page_title', 'Round overview');

    return html($smarty->fetch('round/round_overview.tpl'));
}

function end_round_confirmation()
{
    security_authorize(ADMIN);

    $round = get_current_round();

    if($round->id == 0)
    {
        return html('Round not found');
    }

    global $smarty;

    return html($smarty->fetch('round/end_round_confirmation.tpl'));
}

function end_round()
{
    security_authorize(ADMIN);

    $round = get_current_round();

    if($round->id == 0)
    {
        return html('Round not found');
    }

    $round->status = ROUND_COMPLETED;

    R::store($round);

    return html('Round ended!');
}

function validate_round_form()
{
    $min_own = $_POST['min_own'];
    $max_own = $_POST['max_own'];
    $min_other = $_POST['min_other'];
    $max_other = $_POST['max_other'];

    if($min_own == 0)
    {
        $min_own = 50;
    }
    if($max_own == 0)
    {
        $max_own = 100;
    }
    if($min_other == 0)
    {
        $min_other = 25;
    }
    if($max_other == 0)
    {
        $max_other = 50;
    }

    $values = '&description=' . $_POST['description'] . '&min_own=' . $min_own . '&max_own=' . $max_own . '&min_other=' . $min_other . '&max_other=' . $max_other;

    if(!isset($_POST['description']) || empty($_POST['description']))
    {
        header('Location:' . ADMIN_URI . 'round/create?error=1');
        return false;
    }
    else if(($min_own > $max_own) && ($min_other > $max_other))
    {
        header('Location:' . ADMIN_URI . 'round/create?error=2' . $values);
        return false;
    }
    else if($min_own > $max_own)
    {
        header('Location:' . ADMIN_URI . 'round/create?error=3' . $values);
        return false;
    }
    else if($min_other > $max_other)
    {
        header('Location:' . ADMIN_URI . 'round/create?error=4' . $values);
        return false;
    }
    else if($min_own < 0 || $max_own < 0 || $min_other < 0 || $max_other < 0)
    {
        header('Location:' . ADMIN_URI . 'round/create?error=5' . $values);
        return false;
    }
    else if($min_own > 100 || $max_own > 100 || $min_other > 100 || $max_other > 100)
    {
        header('Location:' . ADMIN_URI . 'round/create?error=6' . $values);
        return false;
    }

    global $smarty;
    $smarty->assign('description', $_POST['description']);
    $smarty->assign('min_own', $min_own);
    $smarty->assign('max_own', $max_own);
    $smarty->assign('min_other', $min_other);
    $smarty->assign('max_other', $max_other);

    return true;
}
