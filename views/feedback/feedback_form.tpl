{function createRadiobuttons}
    {for $index=1 to 5}
        {if $index >= $disabledFrom && $index <= $disabledTo}
            <td><input type="radio" name="competencies[{$competency.id}][rating]" disabled="disabled" /></td>
        {else}
            <td><input type="radio" name="competencies[{$competency.id}][rating]" value="{$index}" /></td>
        {/if}
    {/for}
{/function}

{function createForm}
    <fieldset>
        <legend>{$legend}</legend>

        <table class="table table-striped table-hover">
            <thead>
            <tr>
                <th></th>
                <th>--</th>
                <th>-</th>
                <th>-/+</th>
                <th>+</th>
                <th>++</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            {foreach $competencies as $competency}
                <tr>
                    <td><input type="hidden" name="competencies[{$competency.id}][id]" value="{$competency.id}" />{$competency.name}</td>
                    {createRadiobuttons competency=$competency disabledFrom=$disabledFrom disabledTo=$disabledTo}
                    <td><textarea class="input-xlarge" name="competencies[{$competency.id}][comment]" placeholder="Add a comment for {$competency.name} here"></textarea>
                        <button class="btn btn-link"><strong>+</strong> Add comment</button>
                    </td>
                </tr>
            {/foreach}

            </tbody>
        </table>
    </fieldset>
{/function}

<div class="container">
    <div id="feedbackForm">
        <form class="form-horizontal" action="{$base_uri}feedback/3" method="post">

            {createForm competencies=$positiveCompetencies disabledFrom=0 disabledTo=2 legend="Positive competencies"}
            {createForm competencies=$negativeCompetencies disabledFrom=4 disabledTo=5 legend="Points of improvement"}

            <fieldset>
                <legend>Open comment</legend>

                <div class="control-group">
                    <label>In welke zin heeft {$currentUser.firstname} {$currentUser.lastname} bijgedragen aan het success van de organisatie?</label>
                    <textarea name="openQuestion" class="input-xxlarge"></textarea>
                </div>
            </fieldset>
            <div class="form-actions">
                <button type="button" class="btn" onClick="history.go(-1);return true;">Previous</button>
                <button type="submit" class="btn btn-primary">Submit</button>
            </div>
        </form>
    </div>
</div>

<script type="text/javascript">
    $('table textarea').hide();

    $(document).ready(function ()
    {
        $('[class="btn btn-link"]').bind('click', function ()
        {
            $(this).siblings('textarea').show();
            $(this).hide();

            return false;
        });
    });
</script>