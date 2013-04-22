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

<div class="container">
    <h2>Roles</h2>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>Name</th>
            <th>Description</th>
            <th>Department</th>
            <th>Competency group</th>
            <th>Actions</th>
        </tr>
        </thead>
        {if isset($roles) && !empty($roles)}
        <tbody>
        {foreach $roles as $role}
            {printRoles}
        {/foreach}
        </tbody>
    </table>
    {else}
    </table>No roles found!
    {/if}
    {call printAddLink level="manager" type="role"}
</div>