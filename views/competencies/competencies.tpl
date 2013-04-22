{include file="views/functions.tpl"}

{function name="printCompetencies"}
    <tr>
        <td>{$competency.name}</td>
        <td>{$competency.description}</td>
        <td>{$competency.competencygroup.name}</td>
        {call showActions type="competency" level="manager"}
    </tr>
{/function}

{function name="printCompetencyGroups"}
    <tr>
        <td>{$competencygroup.name}</td>
        <td>{$competencygroup.description}</td>
        {call showActions type="competencygroup" level="manager"}
    </tr>
{/function}

<div class="container">
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
            {printCompetencyGroups}
        {/foreach}
        </tbody>
    </table>
    {else}
    </table>No competency groups found!
    {/if}
    {call printAddLink level="manager" type="competencygroup"}

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
            {printCompetencies}
        {/foreach}
        </tbody>
    </table>
    {else}
    </table>No competencies found!
    {/if}
    {call printAddLink level="manager" type="competency"}
</div>