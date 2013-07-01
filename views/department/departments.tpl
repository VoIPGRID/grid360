{include file="lib/functions.tpl"}

{function print_departments}
    <tr>
        <td>{$department.name|capitalize:true}</td>
        <td>{$department.user.firstname} {$department.user.lastname}</td>
        <td>{$department.created}</td>
        {call print_actions type="department" level="admin"}
    </tr>
{/function}

{if !empty($departments)}
<table class="table table-striped">
    <thead>
    <tr>
        <th>{t}Department name{/t}</th>
        <th>{t}Manager{/t}</th>
        <th>{t}Date created{/t}</th>
        <th>{t}Actions{/t}</th>
    </tr>
    </thead>
    <tbody>
    {foreach $departments as $department}
        {print_departments}
    {/foreach}
    </tbody>
</table>
{else}
    {t}No departments found{/t}!
{/if}

{call print_add_link level="admin" type_var="department" type="{t}department{/t}"}
