{include file="lib/functions.tpl"}

{function print_user_info}
    <tr>
        <td>{$user.firstname|capitalize:true} {$user.lastname}</td>
        <td>{$user.department.name|capitalize:true}</td>
        <td>{$counts[$round->id][$user->id]['reviewed']} / {$counts[$round->id][$user->id]['total_reviewed']}</td>
        <td>{$counts[$round->id][$user->id]['reviewed_by']} / {$counts[$round->id][$user->id]['total_reviewed_by']}</td>
    </tr>
{/function}

{foreach $rounds as $round}
    <h3>{$round->description}</h3>
    <table class="table table-striped counts-table">
        <thead>
        <tr>
            <th>{t}Name{/t}</th>
            <th>{t}Department{/t}</th>
            <th>{t}Completed / Total reviews{/t}</th>
            <th>{t}Reviewed by / Total reviewed{/t}</th>
        </tr>
        </thead>
        <tbody>
        {foreach $users as $user}
            {if $counts[$round->id][$user->id]['reviewed'] < $counts[$round->id][$user->id]['total_reviewed']}
                {print_user_info}
            {/if}
        {/foreach}
        </tbody>
    </table>
{/foreach}