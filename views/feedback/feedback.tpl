{function create_checkboxes}
    {foreach $competencies as $competency}
        <div class="control-group">
            <div class="controls">
                <label class="checkbox" data-toggle="tooltip" title="{$competency.description}" data-placement="right">
                    <input type="checkbox" name="competencies[]" value="{$competency.id}" /> {$competency.name}
                </label>
            </div>
        </div>
    {/foreach}
{/function}

{$url_text = ""}

{if isset($step) && $step == 2}
    {$text = $smarty.const.FEEDBACK_HEADER_STEP_2}
    {$url_text = "/{$reviewee.id}/2"}
    {$button_text = $smarty.const.BUTTON_PREVIOUS}
{else}
    {$text =  $smarty.const.FEEDBACK_HEADER_STEP_1}
    {$url_text = "/{$reviewee.id}"}
    {$button_text = {$smarty.const.BUTTON_CANCEL}}
{/if}
<h3>{$text}
    {if $reviewee.id == $current_user.id}
        {$smarty.const.FEEDBACK_HEADER_TEXT_SELF}
    {else}
        {$reviewee.firstname} {$reviewee.lastname}
    {/if}
</h3>

<h4>{$smarty.const.FEEDBACK_STEP_TEXT|sprintf:{$step}}</h4>

<div class="alert alert-info">
    {$smarty.const.FEEDBACK_INFO_COMPETENCY_DESCRIPTION}
</div>

{if isset($step) && $step == 1 && $reviewee.department.id != $current_user.department.id}
    <form action="{$smarty.const.BASE_URI}feedback/skip/{$reviewee.id}">
        <div class="skip-button"><button class="btn-large btn-inverse">{$smarty.const.FEEDBACK_SKIP_BUTTON}</button></div>
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
        <button type="button" class="btn" onclick="history.go(-1);return true;">{$button_text}</button>
        <button type="submit" class="btn btn-primary" id="submit">{$smarty.const.BUTTON_NEXT}</button>
    </div>
</form>

<script type="text/javascript">
    var step = '{$step}';
</script>
<script type="text/javascript" src="{$smarty.const.ASSETS_URI}js/feedback.js"></script>
