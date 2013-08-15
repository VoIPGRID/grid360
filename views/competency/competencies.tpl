{include file="lib/functions.tpl"}

{function print_competencygroup}
    <tr>
        <td>{$competencygroup.name}</td>
        <td>{$competencygroup.description}</td>
        <td>{if $competencygroup.general}{t}Yes{/t}{else}{t}No{/t}{/if}</td>
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

<h2>{t}Competency groups{/t}</h2>
{if !empty($competencygroups)}
<table id="competencygroups" class="table table-striped">
    <thead>
    <tr>
        <th>{t}Group name{/t}</th>
        <th>{t}Description{/t}</th>
        <th>{t}Is general{/t}</th>
        <th>{t}Actions{/t}</th>
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

        var ignored_columns = [-1, -2]; // Stop the 'Is general?' and actions columns from being sortable
        create_datatable($('#competencygroups'), ignored_columns);
        create_datatable($('#competencies'));
    });
</script>
