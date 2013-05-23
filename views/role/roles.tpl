{include file="lib/functions.tpl"}

{function print_roles}
    <tr>
        <td>{$role.name|capitalize:true}</td>
        <td>{$role.description}</td>
        <td>{$role.department.name}</td>
        <td>{$role.competencygroup.name}</td>
        {call show_actions type="role" level="manager"}
    </tr>
{/function}

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
        {print_roles}
    {/foreach}
    </tbody>
</table>
{else}
    </table>No roles found!
{/if}
{call print_add_link level="manager" type="role"}
