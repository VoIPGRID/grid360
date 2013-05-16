<form action="{$MANAGER_URI}competency/submit" method="POST" class="form-horizontal">
    <fieldset>
        {if $update && isset($competency)}
            <legend>Edit competency {$competency.name}</legend>
        {else}
            <legend>New competency</legend>
        {/if}

        <div class="control-group">
            <input type="hidden" name="type" value="competency" />
            {if isset($competency)}
                <input type="hidden" name="id" value={$competency.id} />
            {/if}

            <label class="control-label" for="competency-name">Competency name</label>

            <div class="controls">
                <input id="competency-name" name="name" type="text" placeholder="Competency name" class="input-large" {if isset($competency)}value="{$competency.name}"{/if} />
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="competency-description">Competency description</label>

            <div class="controls">
                <textarea class="input-xxlarge" rows="3" id="competency-description" name="description" type="text" placeholder="Competency description">{if isset($competency)}{$competency.description}{/if}</textarea>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">Competency group</label>
            <input type="hidden" name="competencygroup[type]" value="competencygroup" />

            <div class="controls">
                {if isset($group_options) && count($group_options) >= 1}
                    {html_options name="competencygroup[id]" options=$group_options selected=$competency.competencygroup.id}
                {else}
                    No competency groups found
                    <input type="hidden" name="competencygroup[id]" value=" " />
                {/if}
            </div>
        </div>

        <div class="form-actions">
            <button type="button" class="btn" onclick="history.go(-1);return true;">Cancel</button>
            <button type="submit" class="btn btn-primary">
                {if $update}
                    Update competency
                {else}
                    Create competency
                {/if}
            </button>
        </div>
    </fieldset>
</form>
