{include file="lib/functions.tpl"}

{function print_competencygroup}
    <tr>
        <td>{$competencygroup.name}</td>
        <td>{$competencygroup.description}</td>
        <td>{if $competencygroup.general}Yes{else}No{/if}</td>
        {call show_actions type="competencygroup" level="manager"}
    </tr>
{/function}

{function print_competency}
    <tr>
        <td>{$competency.name}</td>
        <td>{$competency.description}</td>
        <td>{$competency.competencygroup.name}</td>
        {call show_actions type="competency" level="manager"}
    </tr>
{/function}

<h2>Competency groups</h2>
<table class="table table-striped">
    <thead>
    <tr>
        <th>Group name</th>
        <th>Description</th>
        <th>Is general</th>
        <th>Actions</th>
    </tr>
    </thead>
    {if isset($competencygroups) && !empty($competencygroups)}
    <tbody>
    {foreach $competencygroups as $competencygroup}
        {print_competencygroup}
    {/foreach}
    </tbody>
</table>
{else}
    </table>No competency groups found!
{/if}
{call print_add_link level="manager" type="competencygroup"}

<h3>Competencies</h3>

<table class="table table-striped">
    <thead>
    <tr>
        <th>Name</th>
        <th>Description</th>
        <th>Competency group</th>
        <th>Actions</th>
    </tr>
    </thead>
{if isset($competencygroups) && !empty($competencygroups)}
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
{call print_add_link level="manager" type="competency"}
