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
    {$text = "2 points of improvement"}
    {$url_text = "/{$reviewee.id}/2"}
    {$button_text = "Previous"}
{else}
    {$text = "3 positive competencies"}
    {$url_text = "/{$reviewee.id}"}
    {$button_text = "Cancel"}
{/if}
<h3>Select {$text} for
    {if $reviewee.id == $current_user.id}
        yourself
    {else}
        {$reviewee.firstname} {$reviewee.lastname}
    {/if}
</h3>

<div class="alert alert-info">
    Hover over a competency to read its description
</div>

{if isset($step) && $step == 1 && $reviewee.department.id != $current_user.department.id}
    <form action="{$BASE_URI}feedback/skip/{$reviewee.id}">
        <div class="skip-button"><button class="btn-large btn-inverse">Skip person</button></div>
    </form>
{/if}

<form class="form-horizontal" action="{$BASE_URI}feedback{$url_text}" method="post">
    {foreach $competencygroups as $competencygroup}
        <fieldset>
            <legend>{$competencygroup.name}</legend>
            {create_checkboxes competencies=$competencygroup.ownCompetency}
        </fieldset>
    {/foreach}

    <div class="form-actions">
        <button type="button" class="btn" onclick="history.go(-1);return true;">{$button_text}</button>
        <button type="submit" class="btn btn-primary" id="submit">Next</button>
    </div>
</form>

<script type="text/javascript">
    var step = '{$step}';
</script>
<script type="text/javascript" src="{$ASSETS_URI}js/feedback.js"></script>
