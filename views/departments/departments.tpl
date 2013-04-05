{include file="views/functions.tpl"}

{function name="printDepartments"}
    <tr>
        <td>{$department.name|capitalize:true}</td>
        <td>{$department.user.firstname} {$department.user.lastname}</td>
        {call showActions type="department" level="admin"}
    </tr>
{/function}

{function name="printAddLink"}
    <div style="width: 115px; margin-left:auto;">
        <a href='{$admin_uri}/department/create'><strong>+</strong> Add department</a>
    </div>
{/function}

<div class="container">
    <h2>Departments</h2>
	<table class = "table table-striped">
	<th>Department name</th> <th>Manager</th> <th>Actions</th>
	{if isset($departments) && !empty($departments)}
		{foreach $departments as $department}
			{printDepartments}
		{/foreach}
    {/if}
    </table>
    {if !isset($departments) || count($departments) <= 0}
        No departments found!
    {/if}
    {printAddLink}
</div>