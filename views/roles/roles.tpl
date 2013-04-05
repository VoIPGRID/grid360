{include file="views/functions.tpl"}

{function name="printRoles"}
    <tr>
        <td>{$role.name|capitalize:true}</td>
        <td>{$role.description}</td>
        <td>{$role.department.name}</td>
        <td>{$role.competencygroup.name}</td>
        {call showActions type="role" level="manager"}
    </tr>
{/function}

{function name="printAddLink"}
    <div style="width: 70px; margin-left:auto;">
        <a href='{$manager_uri}/role/create'><strong>+</strong> Add role</a>
    </div>
{/function}

<div class="container">
	<h2>Roles</h2>
	<table class = "table table-striped">
	<th>Name</th> <th>Description</th> <th>Department</th> <th>Competency group</th> <th>Actions</th>
	{if isset($roles) && !empty($roles)}
		{foreach $roles as $role}
			{printRoles}
		{/foreach}
        </table>
    {printAddLink}
	{elseif isset($role)}
            {printRoles}
        </table>
    {else}
    </table>
        No roles found!
    {printAddLink}
	{/if}

</div>