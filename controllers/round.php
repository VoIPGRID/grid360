<?php

function round_overview()
{
    security_authorize(ADMIN);
    $round = get_current_round();

    global $smarty;

    if($round->id != 0)
    {
        $smarty->assign('round', $round);

        $completed_reviews = R::count('roundinfo', 'round_id = ? AND status = ?', array($round->id, REVIEW_COMPLETED));
        $total_reviews = R::count('roundinfo', 'round_id = ? AND status != ?', array($round->id, REVIEW_SKIPPED));

        $smarty->assign('completed_reviews', $completed_reviews);
        $smarty->assign('total_reviews', $total_reviews);
    }

    $smarty->assign('page_header', 'Round overview');

    return html($smarty->fetch('round/round_overview.tpl'));
}

function create_round()
{
    security_authorize(ADMIN);

    if(get_current_round()->id != 0)
    {
        return html('Round already in progress');
    }

    global $smarty;

    return html($smarty->fetch('round/round.tpl'));
}

function start_round_confirmation()
{
    security_authorize(ADMIN);

    if(get_current_round()->id != 0)
    {
        return html('A round is already in progress!');
    }

    $values = validate_round_form();

    global $smarty;
    $smarty->assign('values', $values);

    if(isset($values['error']))
    {
        return create_round();
    }

    return html($smarty->fetch('round/start_round_confirmation.tpl'));
}

function start_round()
{
    security_authorize(ADMIN);

    $values = validate_round_form();

    global $smarty;
    if(isset($values['error']))
    {
        $smarty->assign('values', $values);
        return create_round();
    }

    if(get_current_round()->id != 0)
    {redirect_to('admin/round/create');
        return html('A round is already in progress!');
    }

    $round = R::dispense('round');
    $round->description = $_POST['description'];
    $users = R::find('user', 'status != ?', array(PAUSE_USER_REVIEWS)); // TODO: Add tenant id

    $min_own = $_POST['min_own'];
    $max_own = $_POST['max_own'];
    $min_other = $_POST['min_other'];
    $max_other = $_POST['max_other'];

    $index = 0;

    foreach($users as $reviewer)
    {
        $reviewees = null;

        // Get everyone from $reviewer's department and count them
        $own_department_users = R::find('user', 'department_id = ? AND id != ? AND status != ?', array($reviewer->department->id, $reviewer->id, PAUSE_USER_REVIEWS));
        $count_own_department = count($own_department_users);

        // Only continue if you have atleast 2 people (including yourself) in your own department, since you always have to review people of your own department
        if($count_own_department > 0)
        {
            // Calculate a random number between $min_own and $max_own
            $min = intval($count_own_department * ($min_own / 100));
            $max = intval($count_own_department * ($max_own / 100));
            $random_number = rand($min, $max);

            // Atleast 2 (atleast 1 from  people need to be reviewed, so set $random_number to 1 incase something silly happens
            if($random_number < 1)
            {
                $random_number = 1;
            }

            if(!is_array($own_department_users))
            {
                $own_department_users = array($own_department_users);
            }

            // Grab $random_number amount of users keys
            $own_department_user_ids = array_rand($own_department_users, $random_number);

            if(!is_array($own_department_user_ids))
            {
                $own_department_user_ids = array($own_department_user_ids);
            }

            // Grab the beans with the ids in $user_ids
            $own_random_users = array();
            for($i = 0; $i < count($own_department_user_ids); $i++)
            {
                $own_random_users[] = $own_department_users[$own_department_user_ids[$i]];
            }

            // Get users from other departments and count them
            $other_department_users = R::find('user', 'department_id != ? AND id != ? AND status != ?', array($reviewer->department->id, $reviewer->id, PAUSE_USER_REVIEWS));
            $count_other_department = count($other_department_users);

            $random_users = array();
            // Get random users of other departments if count > 1
            if($count_other_department > 1)
            {
                // Calculate a random number between $min_other and $max_other
                $min = intval($count_other_department * ($min_other / 100));
                $max = intval($count_other_department * ($max_other / 100));
                $random_number = rand($min, $max);

                // Atleast 2 people need to be reviewed, so set $random_number to 2 incase something silly happens
                if($random_number < 1)
                {
                    $random_number = 1;
                }

                if(!is_array($own_department_users))
                {
                    $other_department_users = array($other_department_users);
                }

                // Grab $random_number amount of users
                $user_ids = array_rand($other_department_users, $random_number);

                // Grab the beans with the ids in $user_ids

                for($i = 0; $i < count($user_ids); $i++)
                {
                    $random_users[] = $other_department_users[$user_ids[$i]];
                }
            }

            // Merge all the random users into one reviewee array
            $reviewees = array_merge($own_random_users, $random_users);
            // You always have to review yourself, so add $reviewer to $reviewees
            $reviewees[] = $reviewer;

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
    }

    $round->status = 1;
    $round->created = R::isoDateTime();

    R::store($round);

    return html('Round created!');
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

    $values = array();
    $values['description'] = $_POST['description'];
    $values['min_own'] = $min_own;
    $values['max_own'] = $max_own;
    $values['min_other'] = $min_other;
    $values['max_other'] = $max_other;

    if(!isset($_POST['description']) || empty($_POST['description']))
    {
        $values['error'] = 1;
    }
    else if(($min_own > $max_own) && ($min_other > $max_other))
    {
        $values['error'] = 2;
    }
    else if($min_own > $max_own)
    {
        $values['error'] = 3;
    }
    else if($min_other > $max_other)
    {
        $values['error'] = 4;
    }
    else if($min_own < 0 || $max_own < 0 || $min_other < 0 || $max_other < 0)
    {
        $values['error'] = 5;
    }
    else if($min_own > 100 || $max_own > 100 || $min_other > 100 || $max_other > 100)
    {
        $values['error'] = 6;
    }

    return $values;
}
