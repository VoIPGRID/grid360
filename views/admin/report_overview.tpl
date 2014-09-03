<p>{t}Click on a user to view all reports for that user{/t}</p>

{foreach $users as $user}
    <a href="{$smarty.const.BASE_URI}report/overview/{$user.id}">{$user.firstname} {$user.lastname}</a><br>
{/foreach}