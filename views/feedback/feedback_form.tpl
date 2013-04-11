{function createRadiobuttons}
    {for $index=1 to 5}
        {if $index >= $disabledFrom && $index <= $disabledTo}
            <div class="span2"><input type="radio" name="competencies[{$competency.id}][rating]" disabled="disabled"></div>
        {else}
            <div class="span2"><input type="radio" name="competencies[{$competency.id}][rating]" value="{$index}"></div>
        {/if}
    {/for}
{/function}

{function createForm}
    {foreach $competencies as $competency}
        <div class="row-fluid">
            <div class="control-group">
                <div class="span2">{$competency.name}</div>
                {createRadiobuttons competency=$competency disabledFrom=$disabledFrom disabledTo=$disabledTo}
                <textarea style="display:none;" class="input-xlarge" name="competencies[{$competency.id}][comment]" placeholder="Add a comment for the competency {$competency.name} here"></textarea>
                <br><button class="btn btn-link"><strong>+</strong> Add comment</button>
            </div>
            <input type="hidden" name="competencies[{$competency.id}][id]" value="{$competency.id}";
        </div>
    {/foreach}
{/function}

<div class="container">
    <form class="form-horizontal" action="{$base_uri}feedback/3" method="post">

        <fieldset>
            <legend>General competencies</legend>
        </fieldset>

        <div class="row-fluid">
            <div class="span2 offset2">Underdeveloped</div>
            <div class="span2">Moderatly developed</div>
            <div class="span2">Neutral</div>
            <div class="span2">Well developed</div>
            <div class="span2">Very well developed</div>
        </div>

        {createForm competencies=$positiveCompetencies disabledFrom=0 disabledTo=2}

        <fieldset>
            <legend>Points of improvement</legend>
        </fieldset>

        {createForm competencies=$negativeCompetencies disabledFrom=4 disabledTo=5}

        <div class="control-group">
            <label>
                In welke zin heeft {$currentUser.firstname} {$currentUser.lastname} bijgedragen aan het success van de organisatie?
            </label>
            <textarea name="openQuestion" class="input-xxlarge"></textarea>
        </div>

        <div class="form-actions">
            <button type="button" class="btn" onClick="history.go(-1);return true;">Previous</button>
            <button type="submit" class="btn btn-primary">Submit</button>
        </div>
    </form>
</div>

<script type="text/javascript">
    $(document).ready(function()
    {
        $('[class="btn btn-link"]').bind('click', function()
        {
            /* TODO: Make this work */

            $(this).siblings('textarea').toggle();

            console.log($(this));
            if($(this).is(":hidden"))
            {
                $(this).html("<strong>+</strong> Open comment");
            }
            else
            {
                $(this).html("<strong>+</strong> Close comment");
            }
            return false;
        });

        // TODO: Add Javascript validation

    });

</script>