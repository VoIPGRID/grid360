{include file="views/functions.tpl"}

{function printDepartments}
    <tr>
        <td>{$department.name|capitalize:true}</td>
        <td>{$department.user.firstname} {$department.user.lastname}</td>
        {call showActions type="department" level="admin"}
    </tr>
{/function}

<div class="container">
    <h2>Departments</h2>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>Department name</th>
            <th>Manager</th>
            <th>Actions</th>
        </tr>
        </thead>
        {if isset($departments) && !empty($departments)}
            <tbody>
            {foreach $departments as $department}
                {printDepartments}
            {/foreach}
            </tbody>
        {/if}
    </table>
    {if !isset($departments) || count($departments) <= 0}
        No departments found!
    {/if}
    {call printAddLink level="admin" type="department"}
</div>