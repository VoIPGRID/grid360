<div class="row-fluid">
    <div class="span5">
        <h4>{$smarty.const.DASHBOARD_REVIEW_STATUS}</h4>
        {if isset($roundinfo) && !empty($roundinfo)}
            <table class="table table-striped">
                <thead>
                <tr>
                    <th>{$smarty.const.TH_NAME}</th>
                    <th>Status</th>
                </tr>
                </thead>
                <tbody>
                {foreach $roundinfo as $info}
                    {if $info.reviewee.id != $current_user.id}
                        <tr>
                            <td>{$info.reviewee.firstname} {$info.reviewee.lastname}</td>
                            <td>
                                {if $info.status == 0}
                                    <a href="{$smarty.const.BASE_URI}feedback/{$info.reviewee.id}">{$smarty.const.TEXT_PENDING}</a>
                                {else}
                                    {$smarty.const.TEXT_COMPLETED}
                                {/if}
                            </td>
                        </tr>
                    {/if}
                {/foreach}
                </tbody>
            </table>
        {else}
            {$smarty.const.DASHBOARD_NO_ROUND}
        {/if}
    </div>

    <div class="span4 offset3">
        <h4>{$smarty.const.DASHBOARD_REPORTS}</h4>
        {if isset($rounds) && !empty($rounds)}
            <table class="table table-striped">
                <thead>
                <tr>
                    <th>{$smarty.const.TH_DESCRIPTION}</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                {foreach $rounds as $round}
                    <tr>
                        <td>{$round.description}</td>
                        <td>
                            {if $round.status == 0}
                                <a href="{$smarty.const.BASE_URI}report/{$round.id}">{$smarty.const.DASHBOARD_VIEW_REPORT}</a>
                            {else}
                                {$smarty.const.TEXT_ROUND_IN_PROGRESS}
                            {/if}
                        </td>
                    </tr>
                {/foreach}
                </tbody>
            </table>
        {else}
            {$smarty.const.DASHBOARD_NO_REPORTS}
        {/if}
    </div>
</div>
