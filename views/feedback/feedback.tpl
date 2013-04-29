{function createCheckBoxes}
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

{$urlText = ""}

{if isset($step) && $step == 2}
    {$text = "2 points of improvement"}
    {$urlText = "/{$reviewee.id}/2"}
    {$buttonText = "Previous"}
{else}
    {$text = "3 positive competencies"}
    {$urlText = "/{$reviewee.id}"}
    {$buttonText = "Cancel"}
{/if}
<h3>Select {$text} for
    {if $reviewee.id == $currentUser.id}
        yourself
    {else}
        {$reviewee.firstname} {$reviewee.lastname}
    {/if}
</h3>

<div class="alert alert-info">
    Hover over a competency to read its description
</div>

<form class="form-horizontal" action="{$BASE_URI}feedback{$urlText}" method="post">
    <fieldset>
        <legend>General competencies</legend>
        {if isset($step) && $step == 1 && $reviewee.department.id != $currentUser.department.id}
            <button class="btn-large btn-inverse pull-right">Skip person</button>
        {/if}
        {createCheckBoxes competencies=$generalCompetencies}
    </fieldset>

    <fieldset>
        <legend>{$reviewee.role.competencygroup.name}</legend>
        {createCheckBoxes competencies=$competencies}
    </fieldset>

    <div class="form-actions">
        <button type="button" class="btn" onclick="history.go(-1);return true;">{$buttonText}</button>
        <button type="submit" class="btn btn-primary">Next</button>
    </div>
</form>

<script type="text/javascript">
    $(document).ready(function ()
    {
        $('[data-toggle="tooltip"]').tooltip();
        $('input[type=checkbox]').click(countChecked);
    });

    var countChecked = function ()
    {
        var step = '{$step}';
        var count = $('input:checked').length;
        if (step == 2)
        {
            if (count >= 2)
                $('input:not(:checked)').attr('disabled', true);
            else
                $('input:not(:checked)').attr('disabled', false);
        }
        else
        {
            if (count >= 3)
                $("input:not(:checked)").attr('disabled', true);
            else
                $("input:not(:checked)").attr('disabled', false);
        }
    };

    countChecked();
</script>
