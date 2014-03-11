<div class="row-fluid">
    <div class="span5">
        <h4>{t}Review status{/t}</h4>
        {if !empty($roundinfo)}
            <table class="table table-striped">
                <thead>
                <tr>
                    <th>{t}Name{/t}</th>
                    <th>{t}Status{/t}</th>
                </tr>
                </thead>
                <tbody>
                {foreach $roundinfo as $info}
                    {if $info.reviewee.id != $current_user.id}
                        <tr>
                            <td>{$info.reviewee.firstname} {$info.reviewee.lastname}</td>
                            <td>
                                {if $info.status == 0}
                                    <a href="{$smarty.const.BASE_URI}feedback/{$info.reviewee.id}">{t}Pending{/t}</a>
                                {else}
                                    {t}Completed{/t}
                                {/if}
                            </td>
                        </tr>
                    {/if}
                {/foreach}
                </tbody>
            </table>
        {else}
            {t}No round in progress{/t}
        {/if}
    </div>

    <div class="span4 offset3">
        <h4>{t}Reports{/t}</h4>
        {if !empty($rounds)}
            <table class="table table-striped">
                <thead>
                <tr>
                    <th>{t}Description{/t}</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                {foreach $rounds as $round}
                    <tr>
                        <td>{$round.description}</td>
                        <td>
                            {if $round.status == 0}
                                <a href="{$smarty.const.BASE_URI}report/{$round.id}">{t}View report{/t}</a>
                            {else}
                                {t}Round in progress{/t}
                            {/if}
                        </td>
                    </tr>
                {/foreach}
                </tbody>
            </table>
        {else}
            {t}No reports found{/t}
        {/if}
    </div>
</div>
