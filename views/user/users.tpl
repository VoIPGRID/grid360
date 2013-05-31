{include file="lib/functions.tpl"}

<script type="text/javascript">
    var base_uri = {$smarty.const.BASE_URI};
</script>

{function print_user_info}
    <tr>
        <td>{$user.firstname|capitalize:true}</td>
        <td>{$user.lastname}</td>
        <td>{$user.email}</td>
        <td>{$user.department.name|capitalize:true}</td>
        <td>{$user.role.name|capitalize:true}</td>
        <td>{$user.userlevel.name|capitalize}</td>
        <td><a href="{$smarty.const.BASE_URI}report/overview/{$user.id}">View</a></td>
        {call show_actions type="user" level="admin"}
    </tr>
{/function}

{if isset($smarty.get.success)}
    <div class="alert alert-success">
        <button type="button" class="close" data-dismiss="alert">&times;</button>
        {$smarty.get.success}
    </div>
{/if}

<table class="table table-striped">
    <thead>
    <tr>
        <th>First name</th>
        <th>Last name</th>
        <th>Email</th>
        <th>Department</th>
        <th>Role</th>
        <th>User level</th>
        <th>Reports</th>
        <th>Actions</th>
    </tr>
    </thead>
    {if isset($users) && !empty($users)}
    <tbody>
    {foreach $users as $user}
        {print_user_info}
    {/foreach}
    </tbody>
</table>
{else}
    </table>No users found!
{/if}
{call print_add_link level="admin" type="user"}
