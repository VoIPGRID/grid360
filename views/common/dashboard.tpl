<div class="row-fluid">
    <div class="span5">
        <h4>Review status</h4>
        {if  isset($roundinfo) && !empty($roundinfo)}
        <table class="table table-striped">
            <thead>
            <tr>
                <th>Name</th>
                <th>Role</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody>
                {foreach $roundinfo as $info}
                    {if $info.reviewee.id != $current_user.id}
                        <tr>
                            <td>{$info.reviewee.firstname} {$info.reviewee.lastname}</td>
                            <td>{$info.reviewee.role.name}</td>
                            <td>
                                {if $info.status == 0}
                                    Pending
                                {else}
                                    Completed
                                {/if}
                            </td>
                        </tr>
                    {/if}
                {/foreach}
            </tbody>
        </table>
        {else}
            No reviewee's found
        {/if}
    </div>

    <div class="span4 offset3">
        <h4>Reports</h4>
        <table class="table table-striped">
            <thead>
            <tr>
                <th>Date</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            {foreach $rounds as $round}
                <tr>
                    <td>{$round.description}</td>
                    <td>
                        {if $round.status == 0}
                            <a href="{$BASE_URI}report/{$round.id}">View</a>
                        {else}
                            In progress
                        {/if}
                    </td>
                </tr>
            {/foreach}
            </tbody>
        </table>
    </div>
</div>
