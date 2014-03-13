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
            <textarea class="input-xlarge" name="competencies[{$competency.id}][comment]" placeholder="{t competency=$competency.name}Add a comment for the competency %1 here{/t}">{$smarty.session.competencies[{$step}][{$competency.id}].comment}</textarea>
        </span>
    {/foreach}
{/function}

{function create_agreements_row}
    <span class="span6">
        <input type="hidden" value="0" id="{$type}_agreements" name="agreements[{$type}][value]" />
        <div class="control-group">
            <div class="controls">
                <label class="checkbox"><strong>{$type_text|ucfirst}</strong>: {$agreements[{$type}]|ucfirst}</label> <br />
                <button class="btn btn-link"><span class="smile-default"></span></button>
                <button class="btn btn-link"><input type="hidden" /><span class="meh-default"></span></button>
            </div>
        </div>
    </span>
    <span class="span5 hide">
        <br />
        <textarea class="input-xlarge" name="agreements[{$type}][comment]" placeholder="{t type=$type_text}Add a comment for %1 agreements here{/t}">{$smarty.session.agreements[{$type}].comment}</textarea>
    </span>
{/function}

<h3>
    {$feedback_header}
</h3>

<h4>{$step_text}</h4>

{call print_alert type="info" text="{t}You can read the description of a competency by hovering your mouse over it{/t}"}

{if isset($step) && $step == 1 && $reviewee.department.id != $current_user.department.id}
    <a href="{$smarty.const.BASE_URI}feedback/skip/{$reviewee.id}" class="btn btn-large btn-inverse pull-right">{t}Skip person{/t}</a>
{/if}

<form class="form-horizontal" action="{$smarty.const.BASE_URI}feedback{$form_action_url}" method="post" data-persist="garlic">
    <div class="row-fluid">
        {if count($competencygroup.ownCompetency) > 0}
            <span class="span12" id="competencies">
                <fieldset>
                    <legend>{$competencygroup.name}</legend>
                    {create_choice_row competencies=$competencygroup.ownCompetency step=$step}
                </fieldset>
            </span>
        {/if}

        {if $step == 2}

            {if !empty({$agreements})}
                <span class="span12" id="agreements">
                    <fieldset>
                        <legend>Agreements</legend>
                        {create_agreements_row type="work" type_text="{t}work{/t}"}
                        {create_agreements_row type="training" type_text="{t}training{/t}"}
                        {create_agreements_row type="other" type_text="{t}other{/t}"}
                        {create_agreements_row type="goals" type_text="{t}goals{/t}"}
                    </fieldset>
                </span>
            {/if}

            <button class="btn btn-primary" id="no-competencies-button">{t}I can't review role specific competencies{/t}</button>
            <div class="no-competencies-box">
                <hr />
                <textarea class="input-xxlarge" rows="3" name="no_competencies_comment">{$smarty.session.no_competencies_comment}</textarea>
            </div>
        {/if}
    </div>
    <div class="form-actions">
        {if $step == 1}
            <a href="{$smarty.const.BASE_URI}feedback" class="btn">{t}Cancel{/t}</a>
        {else}
            <a href="{$smarty.const.BASE_URI}feedback/{$reviewee.id}" class="btn">{t}Previous{/t}</a>
        {/if}
        <button type="submit" class="btn btn-primary" id="submit">{t}Next{/t}</button>
    </div>
</form>

<script type="text/javascript">
    var step = '{$step}';

    $(document).ready(function()
    {
        $('#no-competencies-button').click(function(event)
        {
            $('.no-competencies-box').slideToggle();
            event.preventDefault();
        });

        $('#competencies button').click(function(event)
        {
            var icon = $(this).children('span');
            var other_icon = $(this).siblings('button').children('span');
            var button = $(this);

            var count_smile_active = $('#competencies .smile-active').length;
            var count_meh_active = $('#competencies .meh-active').length;

            if(icon.hasClass('smile-active'))
            {
                icon.attr('class', 'smile-default');
                icon.parents('.span6').children('input').val(0);
            }
            else if((count_smile_active < 2) && icon.hasClass('smile-default'))
            {
                icon.attr('class', 'smile-active');
                other_icon.attr('class', 'meh-default');
                icon.parents('.span6').children('input').val(1);
            }
            else if(icon.hasClass('meh-active'))
            {
                icon.attr('class', 'meh-default');
                icon.parents('.span6').children('input').val(0);
            }
            else if(count_meh_active < 1 && icon.hasClass('meh-default'))
            {
                icon.attr('class', 'meh-active');
                other_icon.attr('class', 'smile-default');
                icon.parents('.span6').children('input').val(2);
            }

            if(icon.hasClass('smile-active') || icon.hasClass('meh-active'))
            {
                button.parents('.span6').next().fadeIn(300);
            }
            else
            {
                button.parents('.span6').next().fadeOut(300);
            }

            event.preventDefault();
        });

        $('#agreements button').click(function(event)
        {
            var icon = $(this).children('span');
            var other_icon = $(this).siblings('button').children('span');
            var button = $(this);

            if(icon.hasClass('smile-active'))
            {
                icon.attr('class', 'smile-default');
                icon.parents('.span6').children('input').val(0);
            }
            else if(icon.hasClass('smile-default'))
            {
                icon.attr('class', 'smile-active');
                other_icon.attr('class', 'meh-default');
                icon.parents('.span6').children('input').val(1);
            }
            else if(icon.hasClass('meh-active'))
            {
                icon.attr('class', 'meh-default');
                icon.parents('.span6').children('input').val(0);
            }
            else if(icon.hasClass('meh-default'))
            {
                icon.attr('class', 'meh-active');
                other_icon.attr('class', 'smile-default');
                icon.parents('.span6').children('input').val(2);
            }

            if(icon.hasClass('smile-active') || icon.hasClass('meh-active'))
            {
                button.parents('.span6').next().fadeIn(300);
            }
            else
            {
                button.parents('.span6').next().fadeOut(300);
            }

            event.preventDefault();
        });

        {foreach $smarty.session.competencies[$step] as $key => $competency}
            var competency_div = $('#' + '{$key}');

            if('{$competency.value}' == 1)
            {
                competency_div.parent().find('.smile-default').parent().click();
            }
            else if('{$competency.value}' == 2)
            {
                competency_div.parent().find('.meh-default').parent().click();
            }
        {/foreach}

        {foreach $smarty.session.agreements as $type => $agreement}
            var agreement_div = $('#' + '{$type}' + '_agreements');

            if('{$agreement.value}' == 1)
            {
                agreement_div.parent().find('.smile-default').parent().click();
            }
            else if('{$agreement.value}' == 2)
            {
                agreement_div.parent().find('.meh-default').parent().click();
            }
        {/foreach}
    });
</script>
