<script type="text/javascript">
    type = 'competency';
</script>
<script type="text/javascript" src="{$smarty.const.BASE_URI}assets/js/add_row.js"></script>

<form action="{$smarty.const.MANAGER_URI}competencygroup/{$competencygroup.id}" method="POST" class="form-horizontal">
    <fieldset>
        {if $update && isset($competencygroup)}
            <legend>Updating competency group {$competencygroup.name}</legend>
        {else}
            <legend>Creating new competency group</legend>
        {/if}

        <div class="control-group">
            <label class="control-label" for="general">Is general?</label>

            <div class="controls">
                <input type="checkbox" id="general" name="general" {if isset($competencygroup) && $competencygroup.general == 1 || $competencygroup.general == 'on'}checked{/if} />
                <span><i class="icon-question-sign" data-toggle="tooltip" title="Checking this will display the current competencygroup for everybody" data-placement="right"></i></span>
            </div>
        </div>

        <div class="control-group">
            <input type="hidden" name="type" value="competencygroup" />
            {if isset($competencygroup)}
                <input type="hidden" name="id" value="{$competencygroup.id}" />
            {/if}

            <label class="control-label" for="group-name">Group name</label>

            <div class="controls">
                <input id="group-name" name="name" type="text" placeholder="Group name" class="input-large" required {if isset($competencygroup)}value="{$competencygroup.name}"{/if} />
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="group_description">Group description</label>

            <div class="controls">
                <textarea id="group_description" name="description" placeholder="Group description" class="input-xxlarge">{if isset($competencygroup)}{$competencygroup.description}{/if}</textarea>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">Competencies</label>

            <div id="competency-list">
                {if isset($competencygroup) && count($competencygroup.ownCompetency) > 0}{* Using count > 0 here because !empty doesn't work for some reason *}
                    {assign "index" 0}
                    {foreach $competencygroup.ownCompetency as $competency}
                        <div class="controls">
                            <input type="hidden" name="ownCompetency[{$index}][type]" value="competency" />
                            <input type="hidden" name="ownCompetency[{$index}][id]" value="{$competency.id}" />
                            <input name="ownCompetency[{$index}][name]" type="text" placeholder="Role name" class="input-xlarge" value="{$competency.name}" />
                            <textarea name="ownCompetency[{$index}][description]" type="text" placeholder="Competency description" class="input-xxlarge">{$competency.description}</textarea>
                        </div>
                        {assign "index" {counter}}
                    {/foreach}
                {else}
                    <div class="controls">
                        <input type="hidden" name="ownCompetency[0][type]" value="competency" />
                        <input type="text" name="ownCompetency[0][name]" placeholder="Competency name" class="input-xlarge" />
                        <textarea class="input-xxlarge" name="ownCompetency[0][description]" placeholder="Competency description"></textarea>
                    </div>
                {/if}
            </div>
        </div>

        <div class="control-group">
            <div class="controls">
                <button id="add-button" class="btn btn-link"><strong>+</strong> Add competency</button>
            </div>
        </div>

        <div class="form-actions">
            <button type="button" class="btn" onclick="history.go(-1);return true;">Cancel</button>
            <button type="submit" class="btn btn-primary">
                {if $update}
                    Update competency group
                {else}
                    Create competency group
                {/if}
            </button>
        </div>
    </fieldset>
</form>
