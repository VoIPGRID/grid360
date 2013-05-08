{include file="lib/functions.tpl"}

{function print_user_info}
    <tr>
        <td>{$user.firstname|capitalize}</td>
        <td>{$user.lastname|capitalize}</td>
        <td>{$user.email}</td>
        <td>{$user.department.name|capitalize:true}</td>
        <td>{$user.role.name|capitalize:true}</td>
        <td>{$user.userlevel.name|capitalize}</td>
        {call show_actions type="user" level="admin"}
    </tr>
{/function}

<table class="table table-striped">
    <thead>
    <tr>
        <th>First name</th>
        <th>Last name</th>
        <th>Email</th>
        <th>Department</th>
        <th>Role</th>
        <th>User level</th>
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
