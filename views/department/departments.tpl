{include file="lib/functions.tpl"}

{function print_departments}
    <tr>
        <td>{$department.name|capitalize:true}</td>
        <td>{$department.user.firstname} {$department.user.lastname}</td>
        <td>{$department.created}</td>
        {call show_actions type="department" level="admin"}
    </tr>
{/function}

<table class="table table-striped">
    <thead>
    <tr>
        <th>Department name</th>
        <th>Manager</th>
        <th>Date created</th>
        <th>Actions</th>
    </tr>
    </thead>
    {if isset($departments) && !empty($departments)}
        <tbody>
        {foreach $departments as $department}
            {print_departments}
        {/foreach}
        </tbody>
    {/if}
</table>
{if !isset($departments) || empty($departments)}
    No departments found!
{/if}
{call print_add_link level="admin" type="department"}
