<div class="page-header">
    <h3>{t}Meeting overview{/t}</h3>
</div>

<div class="row-fluid">
    {if !empty($meetings)}
        <table class="table table-striped">
            <thead>
            <tr>
                <th>{t}Name{/t}</th>
                <th>{t}Wants meeting with{/t}</th>
                <th>{t}Subject{/t}</th>
            </tr>
            </thead>
            <tbody>
            {foreach $meetings as $meeting}
                <tr>
                    <td>{$meeting.user.firstname} {$meeting.user.lastname}</td>
                    <td>{$meeting.with.firstname} {$meeting.with.lastname}</td>
                    <td>{$meeting.subject}</td>
                </tr>
            {/foreach}
            </tbody>
        </table>
    {else}
        {t}No meetings found for current round{/t}
    {/if}

    <br />
    <br />

    <div>
        <a href="{$smarty.const.BASE_URI}{$smarty.const.ADMIN_URI}meetings">{t}Back{/t}</a>
    </div>
</div>