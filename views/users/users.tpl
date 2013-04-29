{include file="views/functions.tpl"}

{function printUserInfo}
    <tr>
        <td>{$user.firstname|capitalize}</td>
        <td>{$user.lastname|capitalize}</td>
        <td>{$user.email}</td>
        <td>{$user.department.name|capitalize:true}</td>
        <td>{$user.role.name|capitalize:true}</td>
        <td>{$user.userlevel.name|capitalize}</td>
        {call showActions type="user" level="admin"}
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
        {printUserInfo}
    {/foreach}
    </tbody>
</table>
{else}
    </table>No users found!
{/if}
{call printAddLink level="admin" type="user"}
