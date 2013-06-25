{include file="lib/functions.tpl"}

<script type="text/javascript">
    type = 'competency';
</script>
<script type="text/javascript" src="{$smarty.const.BASE_URI}assets/js/add_row.js"></script>

<form action="{$smarty.const.MANAGER_URI}competencygroup/{$form_values.id.value}" method="POST" class="form-horizontal">
    <fieldset>
        {if $update && isset($form_values.id.value)}
            <legend>{t name=$competency_name}Updating competency group %1{/t}</legend>
        {else}
            <legend>{t}Creating new competency group{/t}</legend>
        {/if}

        <div class="control-group">
            <label class="control-label" for="general">{t}Is general{/t}?</label>

            <div class="controls">
                <input type="checkbox" id="general" name="general" {if isset($form_values.is_general.value) && $form_values.is_general.value == 1 || $form_values.is_general.value == 'on'}checked{/if} />
                <span><i class="icon-question-sign" data-toggle="tooltip" title="{t}Checking this will display the current competency group for everybody{/t}" data-placement="right"></i></span>
            </div>
        </div>

        <div class="control-group {if isset($form_values.name.error)}error{/if}">
            <input type="hidden" name="type" value="competencygroup" />
            {if isset($form_values.id.value)}
                <input type="hidden" name="id" value="{$form_values.id.value}" />
            {/if}

            <label class="control-label" for="group-name">{t}Group name{/t}</label>

            <div class="controls">
                <input id="group-name" name="name" type="text" placeholder="{t}Group name{/t}" class="input-large" required value="{$form_values.name.value}" />
                {call check_if_error var_name="name"}
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="group_description">{t}Group description{/t}</label>

            <div class="controls">
                <textarea id="group_description" name="description" placeholder="{t}Group description{/t}" class="input-xxlarge">{$form_values.description.value}</textarea>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">{t}Competencies{/t}</label>

            <div id="competency-list">
                {if isset($form_values.competencies.value) && count($form_values.competencies.value) > 0}{* Using count > 0 here because !empty doesn't work for some reason *}
                    {assign "index" 0}
                    {foreach $form_values.competencies.value as $competency}
                        <div class="controls">
                            <input type="hidden" name="ownCompetency[{$index}][type]" value="competency" />
                            <input type="hidden" name="ownCompetency[{$index}][id]" value="{$competency.id}" />
                            <input name="ownCompetency[{$index}][name]" type="text" placeholder="{t}Competency name{/t}" class="input-xlarge" value="{$competency.name}" />
                            <textarea name="ownCompetency[{$index}][description]" type="text" placeholder="{t}Competency description{/t}" class="input-xxlarge">{$competency.description}</textarea>
                        </div>
                        {assign "index" {counter}}
                    {/foreach}
                {else}
                    <div class="controls">
                        <input type="hidden" name="ownCompetency[0][type]" value="competency" />
                        <input type="text" name="ownCompetency[0][name]" placeholder="{t}Competency name{/t}" class="input-xlarge" />
                        <textarea class="input-xxlarge" name="ownCompetency[0][description]" placeholder="{t}Competency description{/t}"></textarea>
                    </div>
                {/if}
            </div>
        </div>

        <div class="control-group">
            <div class="controls">
                <button id="add-button" class="btn btn-link"><strong>+</strong> {t}Add competency{/t}</button>
            </div>
        </div>

        <div class="form-actions">
            <button type="button" class="btn" onclick="history.go(-1);return true;">{t}Cancel{/t}</button>
            <button type="submit" class="btn btn-primary">
                {if $update}
                    {t}Update competency group{/t}
                {else}
                    {t}Create competency group{/t}
                {/if}
            </button>
        </div>
    </fieldset>
</form>
