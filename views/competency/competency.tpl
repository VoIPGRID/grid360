{include file="lib/functions.tpl"}

{if isset($form_values.error)}
    {call print_alert type="error" text=$form_values.error}
{/if}

<form action="{$smarty.const.BASE_URI}{$smarty.const.MANAGER_URI}competency/{$competency.id}" method="POST" class="form-horizontal">
    <fieldset>
        {if $update && isset($form_values.id.value)}
            <legend>{t name=$competency_name}Updating competency %1{/t}</legend>
        {else}
            <legend>{t}Creating new competency{/t}</legend>
        {/if}

        <div class="control-group {if isset($form_values.name.error)}error{/if}">
            <input type="hidden" name="type" value="competency" />
            {if isset($competency)}
                <input type="hidden" name="id" value={$competency.id} />
            {/if}

            <label class="control-label" for="competency-name">{t}Competency name{/t}</label>

            <div class="controls">
                <input id="competency-name" name="name" type="text" placeholder="{t}Competency name{/t}" class="input-large" required {if isset($competency)}value="{$competency.name}"{/if} />
                {call check_if_error var_name="name"}
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="competency-description">{t}Competency description{/t}</label>

            <div class="controls">
                <textarea class="input-xxlarge" rows="3" id="competency-description" name="description" type="text" placeholder="{t}Competency description{/t}">{if isset($competency)}{$competency.description}{/if}</textarea>
            </div>
        </div>

        <div class="control-group {if isset($form_values.competencygroup.error)}error{/if}">
            <label class="control-label">{t}Competency group{/t}</label>
            <input type="hidden" name="competencygroup[type]" value="competencygroup" />

            <div class="controls">
                {if !empty($group_options)}
                    {html_options name="competencygroup[id]" options=$group_options selected=$competency.competencygroup.id}
                {else}
                    {t}No competency groups found{/t}
                {/if}
            </div>
        </div>

        <div class="form-actions">
            <button type="button" class="btn" onclick="history.go(-1);return true;">{t}Cancel{/t}</button>
            <button type="submit" class="btn btn-primary">
                {if $update}
                    {t}Update competency{/t}
                {else}
                    {t}Create competency{/t}
                {/if}
            </button>
        </div>
    </fieldset>
</form>
