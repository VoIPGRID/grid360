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

<form class="form-horizontal" action="{$BASE_URI}feedback{$url_text}" method="post">
    <fieldset>
        <legend>General competencies</legend>
        {if isset($step) && $step == 1 && $reviewee.department.id != $current_user.department.id}
            <button class="btn-large btn-inverse pull-right">Skip person</button>
        {/if}
        {create_checkboxes competencies=$general_competencies}
    </fieldset>

    <fieldset>
        <legend>{$reviewee.role.competencygroup.name}</legend>
        {create_checkboxes competencies=$competencies}
    </fieldset>

    <div class="form-actions">
        <button type="button" class="btn" onclick="history.go(-1);return true;">{$button_text}</button>
        <button type="submit" class="btn btn-primary" id="submit">Next</button>
    </div>
</form>

<script type="text/javascript">
    $(document).ready(function()
    {
        $('[data-toggle="tooltip"]').tooltip();
        $('input[type=checkbox]').click(count_checked);

        $('#submit').click(function()
        {
            var step = '{$step}';
            var count = $('input:checked').length;
            if (step == 2)
            {
                if (!(count >= 2))
                {
                    return false;
                }
            }
            else
            {
                if (!(count >= 3))
                {
                    return false;
                }
            }
        });
    });

    var count_checked = function()
    {
        var step = '{$step}';
        var count = $('input:checked').length;
        if(step == 2)
        {
            if(count >= 2)
            {
                $('input:not(:checked)').attr('disabled', true);
            }
            else
            {
                $('input:not(:checked)').attr('disabled', false);
            }
        }
        else
        {
            if(count >= 3)
            {
                $("input:not(:checked)").attr('disabled', true);
            }
            else
            {
                $("input:not(:checked)").attr('disabled', false);
            }
        }
    };

    count_checked();
</script>
