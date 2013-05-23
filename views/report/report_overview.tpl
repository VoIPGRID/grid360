<table class="table table-striped">
    <thead>
    <tr>
        <th>Description</th>
        <th></th>
    </tr>
    </thead>
{if isset($rounds) && !empty($rounds)}
    <tbody>
    {foreach $rounds as $round}
        <tr>
            <td>{$round.description}</td>
            <td>
                {if $round.status == 0}
                    <a href="{$smarty.const.BASE_URI}report/{$round.id}/{$user.id}">View</a>
                {else}
                    In progress
                {/if}
            </td>
        </tr>
    {/foreach}
    </tbody>
</table>
{else}
    </table>No reports found!
{/if}
