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
    <h3>{t firstname=$reviewee.firstname lastname=$reviewee.lastname}Rate the chosen competencies for %1 %2{/t}</h3>
{else}
    <h3>{t firstname="yourself" lastname=""}Rate the chosen competencies for %1 %2{/t}</h3>
{/if}

<h4>{t step=$step}Step %1 of 3{/t}</h4>

<div class="alert alert-warning">
    {* Make sure you edit MINUTES to match the text you need (either HOURS or HOUR) *}
    <span>{t time=$session_lifetime time_text=$time_text}Make sure you submit this form within %1 %2. Otherwise you will be automatically logged out.{/t}</span>
</div>

{if $reviewee.id != $smarty.session.current_user.id}
    <div class="alert alert-error">
        <span><strong>{t}Notice:{/t}</strong>{t}Feedback, positive as well as constructive is directly viewable for your colleagues. Keep this in mind when writing comments{/t}</span>
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
                <th>{t}Comments{/t}</th>
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
                        <textarea class="input-xlarge" name="{$type}[{$competency.id}][comment]" placeholder="{t competency=$competency.name}Add a comment for the competency %1 here{/t}"></textarea>
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
            <legend>{t}Extra question{/t}</legend>
            <div class="control-group">
                {if $reviewee.id == $current_user.id}
                    <label>{t}In what way have you contributed to the success of the organisation?{/t}</label>
                {else}
                    <label>{t firstname=$reviewee.firstname lastname=$reviewee.lastname}In what way has %1 %2 contributed to the success of the organisation?{/t}</label>
                {/if}
                <textarea name="extra_question" class="input-xxlarge"></textarea>
            </div>
        </fieldset>

        <div class="form-actions">
            <button type="button" class="btn" onclick="history.go(-1);return true;">{t}Previous{/t}</button>
            <button type="submit" class="btn btn-primary" id="submit" >{t}Submit{/t}</button>
            <span id="help-text" style="display:none;" class="help-inline error">Not all fields are filled in</span>
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
