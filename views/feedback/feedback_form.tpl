{function create_radiobuttons}
    {for $index=1 to 5}
        {if $index >= $disabled_from && $index <= $disabled_to}
            <td><input type="radio" name="competencies[{$competency.id}][rating]" disabled="disabled" /></td>
        {else}
            <td><input type="radio" name="competencies[{$competency.id}][rating]" value="{$index}" /></td>
        {/if}
    {/for}
{/function}

{function create_form}
    <fieldset>
        <legend>{$legend}</legend>

        <table class="table table-striped table-hover">
            <thead>
            <tr>
                <th></th>
                <th><i class="icon-minus"></i> <i class="icon-minus"></i></th>
                <th><i class="icon-minus"></i></th>
                <th><i class="icon-minus"></i> / <i class="icon-plus"></i></th>
                <th><i class="icon-plus"></i></th>
                <th><i class="icon-plus"></i> <i class="icon-plus"></i></th>
                <th>Comments</th>
            </tr>
            </thead>
            <tbody>
            {foreach $competencies as $competency}
                <tr>
                    <td><input type="hidden" name="competencies[{$competency.id}][id]" value="{$competency.id}" />{$competency.name}</td>
                    {create_radiobuttons competency=$competency disabled_from=$disabled_from disabled_to=$disabled_to}
                    <td><textarea class="input-xlarge" name="competencies[{$competency.id}][comment]" placeholder="Add a comment for {$competency.name} here"></textarea>
                        <button class="btn btn-link"><strong>+</strong> Add comment</button>
                    </td>
                </tr>
            {/foreach}

            </tbody>
        </table>
    </fieldset>
{/function}

<div id="feedback-form">
    <form class="form-horizontal" action="{$BASE_URI}feedback/{$reviewee.id}/3" method="post">

        {create_form competencies=$positive_competencies disabled_from=0 disabled_to=2 legend="Positive competencies"}
        {create_form competencies=$negative_competencies disabled_from=4 disabled_to=5 legend="Points of improvement"}

        <fieldset>
            <legend>Open comment</legend>
            <div class="control-group">
                {if $reviewee.id == $current_user.id}
                    <label>In welke zin heb jij bijgedragen aan het success van de organisatie?</label>
                {else}
                    <label>In welke zin heeft {$reviewee.firstname} {$reviewee.lastname} bijgedragen aan het success van de organisatie?</label>
                {/if}
                <textarea name="extra_question" class="input-xxlarge"></textarea>
            </div>
        </fieldset>

        <div class="form-actions">
            <button type="button" class="btn" onclick="history.go(-1);return true;">Previous</button>
            <button type="submit" class="btn btn-primary">Submit</button>
        </div>
    </form>
</div>

<script type="text/javascript">
    $('table textarea').hide();

    $(document).ready(function()
    {
        $('[class="btn btn-link"]').click(function()
        {
            $(this).siblings('textarea').show();
            $(this).hide();

            return false;
        });
    });
</script>
