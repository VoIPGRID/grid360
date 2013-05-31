{function create_radiobuttons}
    {for $index=1 to 5}
        {if $index >= $disabled_from && $index <= $disabled_to}
            <td><input type="radio" name="{$type}[{$competency.id}][rating]" disabled="disabled" /></td>
        {else}
            <td><input type="radio" name="{$type}[{$competency.id}][rating]" value="{$index}" /></td>
        {/if}
    {/for}
{/function}

<div class="alert alert-warning">
    <span>{$smarty.const.FEEDBACK_FORM_INFO}</span>
</div>

{function create_form}
    <fieldset>
        <legend>{$legend}</legend>

        {if isset($error_{$type})}
            <div class="alert alert-error">
                <span>{$error_{$type}}</span>
            </div>
        {/if}

        <table class="table table-striped table-hover">
            <thead>
            <tr>
                <th></th>
                <th><i class="icon-minus"></i> <i class="icon-minus"></i></th>
                <th><i class="icon-minus"></i></th>
                <th><i class="icon-minus"></i> / <i class="icon-plus"></i></th>
                <th><i class="icon-plus"></i></th>
                <th><i class="icon-plus"></i> <i class="icon-plus"></i></th>
                <th>{$smarty.const.TEXT_COMMENTS}</th>
            </tr>
            </thead>
            <tbody>
            {foreach $competencies as $competency}
                <tr>
                    <td><input type="hidden" name="{$type}[{$competency.id}][id]" value="{$competency.id}" />{$competency.name}</td>
                    {create_radiobuttons competency=$competency type=$type disabled_from=$disabled_from disabled_to=$disabled_to}
                    <td>
                        <textarea class="input-xlarge" name="{$type}[{$competency.id}][comment]" placeholder="{$smarty.const.FEEDBACK_FORM_COMMENT_PLACEHOLDER|sprintf:{$competency.name}}"></textarea>
                        {*<button class="btn btn-link"><strong>+</strong> Add comment</button>*}
                    </td>
                </tr>
            {/foreach}
            </tbody>
        </table>
    </fieldset>
{/function}

<div id="feedback-form">
    <form class="form-horizontal" action="{$smarty.const.BASE_URI}feedback/{$reviewee.id}/3" method="post">

        {create_form competencies=$positive_competencies type="positive_competencies" disabled_from=0 disabled_to=2 legend=$smarty.const.FEEDBACK_FORM_POSITIVE_COMPETENCIES}
        {create_form competencies=$negative_competencies type="negative_competencies" disabled_from=4 disabled_to=5 legend=$smarty.const.FEEDBACK_FORM_NEGATIVE_COMPETENCIES}

        <fieldset>
            <legend>{$smarty.const.FEEDBACK_FORM_EXTRA_QUESTION_HEADER}</legend>
            <div class="control-group">
                {if $reviewee.id == $current_user.id}
                    <label>{$smarty.const.FEEDBACK_FORM_EXTRA_QUESTION_SELF}</label>
                {else}
                    <label>{$smarty.const.FEEDBACK_FORM_EXTRA_QUESTION|sprintf:{$reviewee.firstname}:{$reviewee.lastname}}</label>
                {/if}
                <textarea name="extra_question" class="input-xxlarge"></textarea>
            </div>
        </fieldset>

        <div class="form-actions">
            <button type="button" class="btn" onclick="history.go(-1);return true;">{$smarty.const.BUTTON_PREVIOUS}</button>
            <button type="submit" class="btn btn-primary">{$smarty.const.BUTTON_SUBMIT}</button>
        </div>
    </form>
</div>

{*<script type="text/javascript">
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
</script>*}
