{include file="lib/functions.tpl"}

{function create_choice_row}
    {foreach $competencies as $competency}
        <span class="span6">
            <input type="hidden" value="0" id="{$competency.id}" name="competencies[{$competency.id}][value]" />
            <div class="control-group">
                <div class="controls">
                    <button class="btn btn-link"><span class="smile-default"></span></button>
                    <button class="btn btn-link"><input type="hidden" /><span class="meh-default"></span></button>
                    <label class="checkbox" data-toggle="tooltip" title="{$competency.description}" data-placement="right">{$competency.name}</label>
                </div>
            </div>
        </span>
        <span class="span5 hide">
            <textarea class="input-xlarge" name="competencies[{$competency.id}][comment]" placeholder="{t competency=$competency.name}Add a comment for the competency %1 here{/t}">{$smarty.session.competencies[$competency.id].comment}</textarea>
        </span>
    {/foreach}
{/function}

<h3>
    {$feedback_header}
</h3>

<h4>{$step_text}</h4>

{call print_alert type="info" text="{t}You can read the description of a competency by hovering your mouse over it{/t}"}

{if isset($step) && $step == 1 && $reviewee.department.id != $current_user.department.id}
    <form action="{$smarty.const.BASE_URI}feedback/skip/{$reviewee.id}">
        <div class="skip-button"><button class="btn-large btn-inverse">{t}Skip person{/t}</button></div>
    </form>
{/if}

<form class="form-horizontal" action="{$smarty.const.BASE_URI}feedback{$form_action_url}" method="post" data-persist="garlic">
    <div class="row-fluid">
        {if count($competencygroup.ownCompetency) > 0}
            <span class="span12">
                <fieldset>
                    <legend>{$competencygroup.name}</legend>
                    {create_choice_row competencies=$competencygroup.ownCompetency}
                </fieldset>
            </span>
        {/if}

        {if $step == 2}
            <button class="btn btn-primary" id="no-competencies-button">{t}I can't review role specific competencies{/t}</button>
            <div {if !isset($smarty.session.no_competencies_comment)}class="no-competencies-box"{/if}>
                <hr />
                <textarea class="input-xxlarge" rows="3" name="no_competencies_comment">{$smarty.session.no_competencies_comment}</textarea>
            </div>
        {/if}
    </div>
    <div class="form-actions">
        <button type="button" class="btn" onclick="history.go(-1);return true;">
            {if $step == 1}
                {t}Cancel{/t}
            {else}
                {t}Previous{/t}
            {/if}
        </button>
        <button type="submit" class="btn btn-primary" id="submit">{t}Next{/t}</button>
    </div>
</form>

{*<script type="text/javascript" src="{$smarty.const.ASSETS_URI}js/feedback.js"></script>*}
<script type="text/javascript">
    var step = '{$step}';

    $(document).ready(function()
    {
        $('#no-competencies-button').click(function(event)
        {
            $('.no-competencies-box').slideDown();
            event.preventDefault();
        });

        $('.span12 button').click(function(event)
        {
            var icon = $(this).children('span');
            var other_icon = $(this).siblings('button').children('span');
            var button = $(this);

            var count_smile_active = $('.smile-active').length;
            var count_meh_active = $('.meh-active').length;

            if(icon.attr('class') == 'smile-active')
            {
                icon.attr('class', 'smile-default');
                icon.parents('.span6').children('input').val(0);
            }
            else if(count_smile_active < 2 && icon.attr('class') == 'smile-default')
            {
                icon.attr('class', 'smile-active');
                other_icon.attr('class', 'meh-default');
                icon.parents('.span6').children('input').val(1);
            }
            else if(icon.attr('class') == 'meh-active')
            {
                icon.attr('class', 'meh-default');
                icon.parents('.span6').children('input').val(0);
            }
            else if(count_meh_active < 1 && icon.attr('class') == 'meh-default')
            {
                icon.attr('class', 'meh-active');
                other_icon.attr('class', 'smile-default');
                icon.parents('.span6').children('input').val(2);
            }

            if(icon.attr('class') == 'smile-active' || icon.attr('class') == 'meh-active')
            {
                button.parents('.span6').next().fadeIn(300);
            }
            else
            {
                button.parents('.span6').next().fadeOut(300);
            }

            event.preventDefault();
        });

        {foreach $smarty.session.competencies as $key => $competency}
            var e = $('#' + '{$key}');

            if('{$competency.value}' == 1)
            {
                e.parent().find('.smile-default').parent().click();
            }
            else if('{$competency.value}' == 2)
            {
                e.parent().find('.meh-default').parent().click();
            }
        {/foreach}
    });
</script>
