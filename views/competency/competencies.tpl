{include file="lib/functions.tpl"}

{function print_competencygroup}
    <tr>
        <td>{$competencygroup.name}</td>
        <td>{$competencygroup.description}</td>
        <td>{if $competencygroup.general}Yes{else}No{/if}</td>
        {call print_actions type="competencygroup" level="manager"}
    </tr>
{/function}

{function print_competency}
    <tr data-group="{$competency.competencygroup.id}">
        <td>{$competency.name}</td>
        <td>{$competency.description}</td>
        <td>{$competency.competencygroup.name}</td>
        {call print_actions type="competency" level="manager"}
    </tr>
{/function}

<h2>Competency groups</h2>
{if isset($competencygroups) && !empty($competencygroups)}
<table class="table table-striped">
    <thead>
    <tr>
        <th>Group name</th>
        <th>Description</th>
        <th>Is general</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    {foreach $competencygroups as $competencygroup}
        {print_competencygroup}
    {/foreach}
    </tbody>
</table>
{else}
    {t}No competency groups found{/t}!
{/if}

{call print_add_link level="manager" type_var="competencygroup" type="{t}competency group{/t}"}

<h3>Competencies</h3>
{if isset($competencygroups) && !empty($competencygroups)}
<div class="controls">
    <select id="group-filter">
        <option value="0">Select all</option>
        {foreach $competencygroups as $id => $competencygroup}
                <option value="{$competencygroup.id}">{$competencygroup.name}</option>
        {/foreach}
    </select>
</div>
<table id="competencies" class="table table-striped">
    <thead>
    <tr>
        <th>Name</th>
        <th>Description</th>
        <th>Competency group</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    {foreach $competencygroups as $competencygroup}
        {foreach $competencygroup.ownCompetency as $competency}
            {print_competency}
        {/foreach}
    {/foreach}
    </tbody>
</table>
{else}
    </table>No competencies found!
{/if}

{call print_add_link level="manager" type_var="competency" type="{t}competency{/t}"}

<script type="text/javascript">
    $(document).ready(function()
    {
        $('#group-filter').change(function()
        {
            if($(this).val() == 0)
            {
                $('#competencies tbody tr').show();
            }
            else
            {
                $('#competencies tbody tr').hide();

                $('#competencies tbody tr[data-group="' + $(this).val() + '"]').show();
            }
        });
    });
</script>
