<html>
<body>
<div class="container">
    <div class="page-header"><h1>Dashboard</h1></div>
    <div class="row">
        <div class="span5">
            <h4>Review status</h4>
            <table class="table table-striped">
                <thead>
                <tr>
                    <th>Name</th>
                    <th>Role</th>
                    <th>Status</th>
                </tr>
                </thead>
                <tbody>
                {foreach $roundInfo as $info}
                    {if $info.reviewee.id != $currentUser.id}
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
        </div>

        <div class="span4 offset3">
            <table class="table table-striped">
                <thead>
                <h4>Reports</h4>
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
                                <a href="{$base_uri}report/{$round.id}">View</a>
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
</div>
</body>
</html>