{include file="lib/functions.tpl"}

{function print_competencies}
    <tr>
        <td>{$competency.name}</td>
        <td>{$competency.description}</td>
        <td>{$competency.competencygroup.name}</td>
        {call show_actions type="competency" level="manager"}
    </tr>
{/function}

{function print_competencygroups}
    <tr>
        <td>{$competencygroup.name}</td>
        <td>{$competencygroup.description}</td>
        {call show_actions type="competencygroup" level="manager"}
    </tr>
{/function}

<h2>Competency groups</h2>
<table class="table table-striped">
    <thead>
    <tr>
        <th>Group name</th>
        <th>Description</th>
        <th>Actions</th>
    </tr>
    </thead>
    {if isset($competencygroups) && !empty($competencygroups)}
    <tbody>
    {foreach $competencygroups as $competencygroup}
        {print_competencygroups}
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
    {if isset($competencies) && !empty($competencies)}
    <tbody>
    {foreach $competencies as $competency}
        {print_competencies}
    {/foreach}
    </tbody>
</table>
{else}
    </table>No competencies found!
{/if}
{call print_add_link level="manager" type="competency"}
