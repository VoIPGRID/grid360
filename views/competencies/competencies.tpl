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

{function name="printGroupAddLink"}
    <div style="width: 165px; margin-left:auto;">
        <a href='{$manager_uri}/competencygroup/create'><strong>+</strong> Add competency group</a>
    </div>
{/function}

{function name="printAddLink"}
    <div style="width: 120px; margin-left:auto;">
        <a href='{$manager_uri}/competency/create'><strong>+</strong> Add competency</a>
    </div>
{/function}

<div class="container">
    <h2>Competency groups</h2>
        <table class = "table table-striped">
            <th>Group name</th> <th>Description</th> <th>Actions</th>
            {if isset($competencygroups) && !empty($competencygroups)}
                {foreach $competencygroups as $competencygroup}
                    {printCompetencyGroups}
                {/foreach}
                </table>
                {printGroupAddLink}
            {else}
                </table>
                No competency groups found!
                {printGroupAddLink}
            {/if}
    <br><br>

	<h3>Competencies</h3>
	<table class = "table table-striped">
	<th>Name</th> <th>Description</th> <th>Competency group</th> <th>Actions</th>
	{if isset($competencies) && !empty($competencies)}
		{foreach $competencies as $competency}
			{printCompetencies}
		{/foreach}
        </table>
    {printAddLink}
	{elseif isset($competency)}
            {printCompetencies}
        </table>
    {else}
    </table>
        No competencies found!
    {printAddLink}
	{/if}
</div>