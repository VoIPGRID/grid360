{function name="createCheckBoxes"}
    {foreach $competencies as $competency}
        <div class="control-group">
            <div class="controls">
                <label class="checkbox" data-toggle="tooltip" title="{$competency.description}" data-placement="right">
                    <input type="checkbox" name="competencies[]" value="{$competency.id}"/> {$competency.name}
                </label>
            </div>
        </div>
    {/foreach}
{/function}

<div class="container">
    {$urlText = ""}

    {if isset($step) && $step == 2}
        {$text = "2 points of improvement"}
        {$urlText = "/2"}
        {$buttonText = "Previous"}
    {else}
        {$text = "3 positive competencies"}
        {$buttonText = "Cancel"}
    {/if}
    <h3>Select {$text} for {$currentUser.firstname} {$currentUser.lastname}</h3>

    <div class="alert alert-info">
        Hover over a competency to read its description
    </div>

    <form class="form-horizontal" action="{$base_uri}feedback{$urlText}" method="post">
        <fieldset>
            <legend>General competencies</legend>
            {createCheckBoxes competencies=$generalCompetencies}
        </fieldset>

        <fieldset>
            <legend>{$currentUser.role.competencygroup.name}</legend>
            {createCheckBoxes competencies=$competencies}
        </fieldset>

        <div class="form-actions">
            <button type="button" class="btn" onClick="history.go(-1);return true;">{$buttonText}</button>
            <button type="submit" class="btn btn-primary">Next</button>
        </div>
    </form>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        $('[data-toggle="tooltip"]').tooltip();
    });

    var countChecked = function () {
        var step = "{$step}";
        var count = $("input:checked").length;
        if (step == 2) {
            if (count >= 2)
                $("input:not(:checked)").attr("disabled", true);
            else
                $("input:not(:checked)").attr("disabled", false);
        }
        else {
            if (count >= 3)
                $("input:not(:checked)").attr("disabled", true);
            else
                $("input:not(:checked)").attr("disabled", false);
        }
    };

    countChecked();

    $("input[type=checkbox]").on("click", countChecked);
</script>