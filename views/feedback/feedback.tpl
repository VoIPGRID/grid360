{include file="lib/functions.tpl"}

{function create_checkboxes}
    {foreach $competencies as $competency}
        <div class="control-group">
            <div class="controls">
                <label class="checkbox" data-toggle="tooltip" title="{$competency.description}" data-placement="right">
                    <input type="checkbox" id="competency-{$competency.id}" name="competencies[]" value="{$competency.id}" {if $competency.in_session}checked="checked"{/if}/> {$competency.name}
                </label>
            </div>
        </div>
    {/foreach}
{/function}

{$url_text = ""}

<h3>
    {if isset($step) && $step == 2}
        {t}Select 2 points of improvement for {/t}
        {$url_text = "/{$reviewee.id}/2"}
    {else}
        {t}Select 3 positive competencies for {/t}
        {$url_text = "/{$reviewee.id}"}
    {/if}

    {if $reviewee.id == $current_user.id}
        {t}yourself{/t}
    {else}
        {$reviewee.firstname} {$reviewee.lastname}
    {/if}
</h3>

<h4>{t step=$step}Step %1 of 3{/t}</h4>

{call print_alert type="info" text="{t}You can read the description of a competency by hovering your mouse over it{/t}"}

{if isset($step) && $step == 1 && $reviewee.department.id != $current_user.department.id}
    <form action="{$smarty.const.BASE_URI}feedback/skip/{$reviewee.id}">
        <div class="skip-button"><button class="btn-large btn-inverse">{t}Skip person{/t}</button></div>
    </form>
{/if}

<form class="form-horizontal" action="{$smarty.const.BASE_URI}feedback{$url_text}" method="post">
    <div class="row-fluid">
        {foreach $competencygroups as $competencygroup}
            <span class="span6">
                <fieldset>
                    <legend>{$competencygroup.name}</legend>
                    {create_checkboxes competencies=$competencygroup.ownCompetency}
                </fieldset>
            </span>
        {/foreach}
    </div>
    <div class="form-actions">
        <button type="button" class="btn" onclick="history.go(-1);return true;">
            {if $step == 1}
                {t}Cancel{/t}
            {else}
                {t}Previous{/t}
            {/if}
        </button>
        <button type="submit" class="btn btn-primary" id="submit">{t}Next{/t}</button>
    </div>
</form>

<script type="text/javascript" src="{$smarty.const.ASSETS_URI}js/feedback.js"></script>
<script type="text/javascript">
    var step = '{$step}';

    $(document).ready(function()
    {
        if(step == 1)
        {
            {if count($smarty.session.positive_competencies) == 3}
                $('input:not(:checked)').attr('disabled', true);
            {/if}
        }
        else if(step == 2)
        {
            {if count($smarty.session.negative_competencies) == 2}
                $('input:not(:checked)').attr('disabled', true);
            {/if}
        }
    });
</script>
