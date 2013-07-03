{include file="lib/functions.tpl"}

{function print_roles}
    <tr>
        <td>{$role.name|capitalize:true}</td>
        <td>{$role.description}</td>
        <td>{$role.department.name}</td>
        <td>{$role.competencygroup.name}</td>
        {call print_actions type="role" level="manager"}
    </tr>
{/function}

{if !empty($roles)}
<table class="table table-striped">
    <thead>
    <tr>
        <th>{t}Name{/t}</th>
        <th>{t}Description{/t}</th>
        <th>{t}Department{/t}</th>
        <th>{t}Competency group{/t}</th>
        <th>{t}Actions{/t}</th>
    </tr>
    </thead>
    <tbody>
    {foreach $roles as $role}
        {print_roles}
    {/foreach}
    </tbody>
</table>
{else}
    {t}No roles found!{/t}
{/if}

{call print_add_link level="manager" type_var="role" type="{t}role{/t}"}

<script type="text/javascript">
    $(document).ready(function()
    {
        create_datatable($('.table.table-striped'));
    });
</script>