{function check_errors}
    {$error_type = $values.error}
    {if isset($error_type) && !empty($error_type)}
        {if $error_type == 1}
            {$error_message = "Competency name can't be empty!"}
        {/if}
        {if isset($error_message) && !empty($error_message)}
            <div class="alert alert-error">
                {$error_message}
            </div>
        {/if}
    {/if}
{/function}

<form action="{$smarty.const.MANAGER_URI}competency/{$competency.id}" method="POST" class="form-horizontal">
    <fieldset>
        {if $update && isset($competency)}
            <legend>Updating competency {$competency.name}</legend>
        {else}
            <legend>Creating new competency</legend>
        {/if}

        {check_errors}

        <div class="control-group">
            <input type="hidden" name="type" value="competency" />
            {if isset($competency)}
                <input type="hidden" name="id" value={$competency.id} />
            {/if}

            <label class="control-label" for="competency-name">Competency name</label>

            <div class="controls">
                <input id="competency-name" name="name" type="text" placeholder="Competency name" class="input-large" required {if isset($competency)}value="{$competency.name}"{/if} />
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
                {if isset($group_options) && !empty($group_options)}
                    {html_options name="competencygroup[id]" options=$group_options selected=$competency.competencygroup.id}
                {else}
                    No competency groups found
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
