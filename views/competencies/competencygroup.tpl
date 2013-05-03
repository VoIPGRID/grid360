<script type="text/javascript" src="{$BASE_URI}assets/js/add_competency.js"></script>

<form action="{$MANAGER_URI}competencygroup/submit" method="POST" class="form-horizontal">
    <fieldset>
        {if $update && isset($competencygroup)}
            <legend>Edit competency group {$competencygroup.name}</legend>
        {else}
            <legend>Create competency group</legend>
        {/if}

        <div class="control-group">
            <input type="hidden" name="type" value="competencygroup" />
            {if isset($competencygroup)}
                <input type="hidden" name="id" value="{$competencygroup.id}" />
            {/if}

            <label class="control-label" for="group-name">Group name</label>

            <div class="controls">
                <input id="group-name" name="name" type="text" placeholder="Group name" class="input-large" {if isset($competencygroup)}value="{$competencygroup.name}"{/if} />
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="group_description">Group description</label>

            <div class="controls">
                <textarea id="group_description" name="description" placeholder="Group description" class="input-xxlarge">{if isset($competencygroup)}value="{$competencygroup.description}"{/if}</textarea>
            </div>
        </div>

        <div class="control-group">
            <input type="hidden" name="role[type]" value="role" />
            <label class="control-label">Role</label>

            <div class="controls">
                {if isset($role_options) && count($role_options) >= 1}
                    {html_options name="role[id]" options=$role_options selected=$competencygroup.role.id}
                {else}
                    No roles found
                {/if}
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">Competencies</label>

            <div id="competency-list">
                {if isset($competencygroup) && count($competencygroup.ownCompetency) >= 1}
                    {assign "index" 0}
                    {foreach $competencygroup.ownCompetency as $competency}
                        <div class="controls">
                            <input type="hidden" name="ownCompetencies[{$index}][type]" value="competency" />
                            <input type="hidden" name="ownCompetencies[{$index}][id]" value="{$competency.id}" />
                            <input name="ownCompetencies[{$index}][name]" type="text" placeholder="Role name" class="input-xlarge" value="{$competency.name}" />
                            <textarea name="ownCompetencies[{$index}][description]" type="text" placeholder="Competency description" class="input-xxlarge">{$competency.description}</textarea>
                        </div>
                        {assign "index" {counter}}
                    {/foreach}
                {else}
                    <div class="controls">
                        <input type="hidden" name="ownCompetencies[0][type]" value="competency" />
                        <input name="ownCompetencies[0][name]" type="text" placeholder="Competency name" class="input-xlarge" />
                        <textarea class="input-xxlarge" name="ownCompetencies[0][description]" placeholder="Competency description"></textarea>
                    </div>
                {/if}
            </div>
        </div>

        <div class="control-group">
            <div class="controls">
                <button class="btn btn-link"><strong>+</strong> Add competency</button>
            </div>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-primary">
                {if $update}
                    Update competency group
                {else}
                    Create competency group
                {/if}
            </button>
            <button type="button" class="btn" onclick="history.go(-1);return true;">Cancel</button>
        </div>
    </fieldset>
</form>
