{include file="views/functions.tpl"}

{function name="printUserInfo"}
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

{function name = "printAddLink"}
    <div style="width: 75px; margin-left:auto;">
        <a href='{$admin_uri}/user/create'><strong>+</strong> Add user</a>
    </div>
{/function}

<div class="container">
	<h2>Users</h2>
	<table class = "table table-striped">
	<th>First name</th> <th>Last name</th> <th>Email</th> <th>Department</th> <th>Role</th> <th>User level</th> <th>Actions</th>
    {if isset($users) && !empty($users)}
		{foreach $users as $user}
			{printUserInfo}
		{/foreach}
        </table>
        {printAddLink}
    {elseif isset($user)}
        {printUserInfo}
        </table>
        {printAddLink}
    {else}
        </table>
        No users found!
        {printAddLink}
	{/if}
</div>