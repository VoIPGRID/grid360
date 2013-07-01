<table class="table table-striped">
    <thead>
    <tr>
        <th>{t}Description{/t}</th>
        <th></th>
    </tr>
    </thead>
{if !empty($rounds)}
    <tbody>
    {foreach $rounds as $round}
        <tr>
            <td>{$round.description}</td>
            <td>
                {if $round.status == 0}
                    <a href="{$smarty.const.BASE_URI}report/{$round.id}/{$user.id}">{t}View{/t}</a>
                {else}
                    {t}In progress{/t}
                {/if}
            </td>
        </tr>
    {/foreach}
    </tbody>
</table>
{else}
    </table>{t}No reports found!{/t}
{/if}
