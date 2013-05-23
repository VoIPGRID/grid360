{function create_control_group}
    <div id="{$group_name}-group" class="control-group">
        <label class="control-label" for="{$group_name}">{$label_text}</label>
        <div class="controls">
            <div class="input-append">
                <input type="number" name="{$input_name}" id="{$group_name}" class="input-mini" {if isset($values.{$input_name})}value="{$values.{$input_name}}"{/if}/>
                <span class="add-on">%</span>
            </div>
            <span class="help-inline"></span>
        </div>
    </div>
{/function}

{function check_errors}
    {$error_type = $values.error}
    {if isset($error_type) && !empty($error_type)}
        {if $error_type == 1}
            {$error_message = "Round description can't be empty!"}
        {elseif $error_type == 2}
            {$error_message = "<strong>Error!</strong> Minimum can't be greater than maximum!"}
        {elseif $error_type == 3}
            {$error_message = "Error for own department fields: Minimum can't be greater than maximum!"}
        {elseif $error_type == 4}
            {$error_message = "Error for other department fields: Minimum can't be greater than maximum!"}
        {elseif $error_type == 5}
            {$error_message = "<strong>Error!</strong> Values can't be less than 0!"}
        {elseif $error_type == 6}
            {$error_message = "<strong>Error!</strong> Values can't be greater than 100!"}
        {/if}
        {if isset($error_message) && !empty($error_message)}
            <div class="alert alert-error">
                {$error_message}
            </div>
        {/if}
    {/if}
{/function}

<form action="{$smarty.const.ADMIN_URI}round/confirm" method="post" class="form-horizontal">
    <fieldset>
        <legend>Create round</legend>

        <div id="description-group" class="control-group">
            {if isset($round)}
                <input type="hidden" name="id" value={$round.id} />
            {/if}
            <label class="control-label" for="round-description">Round description</label>

            <div class="controls">
                <textarea id="round-description" name="description" type="text" placeholder="Round description">{$values.description}</textarea>
                <span class="help-inline"></span>
            </div>
        </div>

        <hr />
        <button id="info-box-button" class="btn btn-link">- Hide info</button>
        <div id="field-info" class="alert alert-info"> {*TODO: Improve info text*}
            The following fields can be used to set the minimum and maximum amount of people each person has to review.
            <br />If a field is blank or 0 (zero), the default values will be used.
            <br />
            <br />Default values for own department:
            <br />Min: 50%
            <br />Max: 100%
            <br />Default values for other departments:
            <br />Min: 25%
            <br />Max: 50%
        </div>

        {check_errors}

        {create_control_group group_name="min-own" input_name="min_own" label_text="Min. own department"}
        {create_control_group group_name="max-own" input_name="max_own" label_text="Max. own department"}

        <hr />

        {create_control_group group_name="min-other" input_name="min_other" label_text="Min. other department"}
        {create_control_group group_name="max-other" input_name="max_other" label_text="Max. other department"}

        <div class="form-actions">
            <button type="button" class="btn" onclick="history.go(-1);return true;">Cancel</button>
            <button type="submit" class="btn btn-primary">
                {if $update}
                    Update round
                {else}
                    Create round
                {/if}
            </button>
        </div>
    </fieldset>
</form>

<script type="text/javascript" src="{$smarty.const.ASSETS_URI}js/create_round.js"></script>
