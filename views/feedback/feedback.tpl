{include file="lib/functions.tpl"}

{function create_choice_row}
    {foreach $competencies as $competency}
        <div class="span6" data-toggle="tooltip" title="{$competency.description}" data-placement="right">
            <input type="hidden" value="0" id="{$competency.id}" name="competencies[{$competency.id}][value]" />
            <div class="control-group">
                <div class="controls">
                    <div class="pull-left">
                        <button class="btn btn-link"><span class="smile-default"></span></button>
                        <button class="btn btn-link"><input type="hidden" /><span class="meh-default"></span></button>
                    </div>
                    <div class="review-row-name">{$competency.name}</div>
                </div>
            </div>
        </div>
        <div class="span5 hide">
            <textarea class="input-xxlarge" name="competencies[{$competency.id}][comment]" placeholder="{t competency=$competency.name}Add a comment for the competency %1 here{/t}">{$smarty.session.competencies[{$step}][{$competency.id}].comment}</textarea>
        </div>
    {/foreach}
{/function}

{function create_agreements_row}
    {if !empty($agreements[{$type}])}
        <span class="span12">
            <div class="control-group">
                <div class="controls">
                    <label class="checkbox"><strong>{$type_text}</strong>
                        <br />
                        <small class="muted">{$agreements[{$type}]|ucfirst}</small>
                    </label>
                </div>
            </div>
        </span>
        <span class="span5">
            <input type="hidden" value="0" id="{$type}_agreements" name="agreements[{$type}][value]" />
            <div class="control-group">
                <div class="controls">
                    <button class="btn btn-link"><span class="smile-default"></span></button>
                    <button class="btn btn-link"><input type="hidden" /><span class="meh-default"></span></button>
                </div>
            </div>
        </span>
        <span class="span5 hide">
            <textarea class="input-xxlarge" name="agreements[{$type}][comment]" placeholder="{t type=$type_text}Add a comment for %1 here{/t}">{$smarty.session.agreements[{$type}].comment}</textarea>
        </span>
    {/if}
{/function}

<h4>{$step_text}</h4>

<div class="alert alert-warning">
    <span>{t time=$session_lifetime time_text=$time_text}Make sure you submit this form within %1 %2. Otherwise you will be automatically logged out and you will lose the data you filled in.{/t}</span>
</div>

{if isset($step) && $step == 1 && $reviewee.department.id != $current_user.department.id}
    <a href="{$smarty.const.BASE_URI}feedback/skip/{$reviewee.id}" class="btn btn-large btn-inverse pull-right">{t}Skip person{/t}</a>
{/if}

<form class="form-horizontal" action="{$smarty.const.BASE_URI}feedback{$form_action_url}" method="post" data-persist="garlic" data-destroy="false">
    <div class="row-fluid">
        {if count($competencygroup.ownCompetency) > 0}
            <span class="span12 no-left-margin" id="competencies">
                <fieldset>
                    <legend>{$competencygroup.name}</legend>
                    <div class="feedback-header-subtext">{$feedback_header_subtext}</div>
                    <br />
                    {create_choice_row competencies=$competencygroup.ownCompetency step=$step}
                </fieldset>
            </span>
            {if $step == 2 && $reviewee.department.id != $current_user.department.id}
                <div>
                    <input type="hidden" id="review-competencies" name="review_competencies" value="1" data-storage="false" />
                    <button id="review-competencies-button" class="btn btn-link">{t}I can't review the role competencies{/t}</button>
                </div>
            {/if}
        {/if}

        {if $step == 2}
            {if !empty({$agreements}) && $agreements.has_agreements}
                <span class="span12 no-left-margin" id="agreements">
                    <fieldset>
                        <legend>{t}Agreements{/t}</legend>
                        <div class="feedback-header-subtext">{$agreement_header_subtext}</div>
                        <br />
                        {create_agreements_row type="work" type_text="{t}Work agreements{/t}"}
                        {create_agreements_row type="training" type_text="{t}Training agreements{/t}"}
                        {create_agreements_row type="other" type_text="{t}Other agreements{/t}"}
                        {create_agreements_row type="goals" type_text="{t}Personal goals{/t}"}
                    </fieldset>
                </span>
            {/if}
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
                button.parents('.span6').nextAll('.span5:first').fadeIn(300);
            }
            else
            {
                button.parents('.span6').nextAll('.span5:first').fadeOut(300);
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
                icon.parents('.span5').children('input').val(0);
            }
            else if(icon.hasClass('smile-default'))
            {
                icon.attr('class', 'smile-active');
                other_icon.attr('class', 'meh-default');
                icon.parents('.span5').children('input').val(1);
            }
            else if(icon.hasClass('meh-active'))
            {
                icon.attr('class', 'meh-default');
                icon.parents('.span5').children('input').val(0);
            }
            else if(icon.hasClass('meh-default'))
            {
                icon.attr('class', 'meh-active');
                other_icon.attr('class', 'smile-default');
                icon.parents('.span5').children('input').val(2);
            }

            if(icon.hasClass('smile-active') || icon.hasClass('meh-active'))
            {
                button.parents('.span5').next('.span5').fadeIn(300);
            }
            else
            {
                button.parents('.span5').next('.span5').fadeOut(300);
            }

            event.preventDefault();
        });

        $('#review-competencies-button').click(function()
        {
            var review_competencies = $('#review-competencies').val();

            if(review_competencies == 1)
            {
                $('#competencies').slideUp();
                $('#review-competencies').val(0);
                $(this).text('{t}I can review the role competencies{/t}');
            }
            else
            {
                $('#competencies').slideDown();
                $('#review-competencies').val(1);
                $(this).text("{t}I can't review the role competencies{/t}");
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
