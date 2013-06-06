{function create_radiobuttons}
    {for $index=1 to 5}
        {if $index >= $disabled_from && $index <= $disabled_to}
            <td><input type="radio" name="{$type}[{$competency.id}][rating]" disabled="disabled" /></td>
        {else}
            <td><input type="radio" name="{$type}[{$competency.id}][rating]" value="{$index}" /></td>
        {/if}
    {/for}
{/function}

{if $reviewee.id != $smarty.session.current_user.id}
    <h3>{$smarty.const.FEEDBACK_FORM_HEADER_STEP_3|sprintf:$reviewee.firstname:$reviewee.lastname}</h3>
{else}
    <h3>{$smarty.const.FEEDBACK_FORM_HEADER_STEP_3|sprintf:{$smarty.const.FEEDBACK_HEADER_TEXT_SELF}:''}</h3>
{/if}

<h4>{$smarty.const.FEEDBACK_STEP_TEXT|sprintf:$step}</h4>

<div class="alert alert-warning">
    {* Make sure you edit MINUTES to match the text you need (either HOURS or HOUR) *}
    <span>{$smarty.const.FEEDBACK_FORM_LOGOUT_WARNING|sprintf:$session_lifetime:$smarty.const.FEEDBACK_FORM_LOGOUT_WARNING_MINUTES}</span>
</div>

{if $reviewee.id != $smarty.session.current_user.id}
    <div class="alert alert-error">
        <span>{$smarty.const.FEEDBACK_FORM_INFO}</span>
    </div>
{/if}

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
                    <td>
                        <input type="hidden" name="{$type}[{$competency.id}][id]" value="{$competency.id}" />
                        <input type="hidden" name="{$type}[{$competency.id}][is_positive]" value="{$is_positive}" />
                        <span data-toggle="tooltip" title="{$competency.description}" data-placement="right">{$competency.name}</span>
                    </td>
                    {create_radiobuttons competency=$competency type=$type disabled_from=$disabled_from disabled_to=$disabled_to}
                    <td>
                        <textarea class="input-xlarge" name="{$type}[{$competency.id}][comment]" placeholder="{$smarty.const.FEEDBACK_FORM_COMMENT_PLACEHOLDER|sprintf:{$competency.name}}"></textarea>
                    </td>
                </tr>
            {/foreach}
            </tbody>
        </table>
    </fieldset>
{/function}

<div id="feedback-form">
    <form class="form-horizontal" action="{$smarty.const.BASE_URI}feedback/{$reviewee.id}/3" method="post">

        {create_form competencies=$positive_competencies type="positive_competencies" disabled_from=0 disabled_to=2 legend=$smarty.const.FEEDBACK_FORM_POSITIVE_COMPETENCIES is_positive=1}
        {create_form competencies=$negative_competencies type="negative_competencies" disabled_from=4 disabled_to=5 legend=$smarty.const.FEEDBACK_FORM_NEGATIVE_COMPETENCIES is_positive=0}

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
            <button type="submit" class="btn btn-primary" id="submit" >{$smarty.const.BUTTON_SUBMIT}</button><span id="help-text" style="display:none;" class="help-inline error">Not all fields are filled in</span>
        </div>
    </form>
</div>

<script type="text/javascript">
    $(document).ready()
    {
        $('#submit').click(function()
        {
            var count = 0;
            $('[type="radio"]').each(function()
            {
                if($(this).is(':checked'))
                {
                    count++;
                }
            });

            if(count == 5)
            {
                return true;
            }

            $('#help-text').show();
            return false;
        });
    }
</script>
