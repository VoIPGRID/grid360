{include file="lib/functions.tpl"}

<script type="text/javascript">
    var locale = $('html').attr('lang');

    // By default Dutch and English language files are loaded. In case the browser has a different locale, load the appropriate language file for the datetime picker
    if(locale != 'en')
    {
        $.getScript('{$smarty.const.ASSETS_URI}' + 'js/bootstrap-datetimepicker/js/locales/bootstrap-datetimepicker.' + locale + '.js');
    }
</script>

{function create_control_group}
    <div class="control-group {if isset($form_values.{$input_name}.error)}error{/if}">
        <label class="control-label" for="{$group_name}">{$label_text}</label>
        <div class="controls">
            <div class="input-append">
                <input type="number" name="{$input_name}" class="input-mini" value="{$form_values.{$input_name}.value}" min=0 max={$count_users} />
            </div>
            {call check_if_error var_name="{$input_name}"}
        </div>
    </div>
{/function}

<form action="{$smarty.const.BASE_URI}{$smarty.const.ADMIN_URI}round/edit" method="post" class="form-horizontal" data-persist="garlic">
    <fieldset>
        <legend>{t}Edit round{/t}</legend>

        <div id="description-group" class="control-group {if isset($form_values.description.error)}error{/if}">
            {if isset($form_values.id.value)}
                <input type="hidden" name="id" value={$form_values.id.value} />
            {/if}
            <label class="control-label" for="round-description">{t}Round description{/t} <span class="required">*</span></label>

            <div class="controls">
                <textarea id="round-description" name="description" type="text" placeholder="{t}Round description{/t}" required>{$form_values.description.value}</textarea>
                {call check_if_error var_name="description"}
            </div>
        </div>

        <div class="control-group {if isset($form_values.closing_date.error)}error{/if}">
            <label class="control-label" for="closing-date">{t}Round closing date{/t}
                <span>
                    <i class="icon-question-sign" data-toggle="tooltip" title="{t}The date the round will close. If this field is left blank, the round will have to be ended manually.{/t}" data-placement="bottom"></i>
                </span>
            </label>
            <div class="controls">
                <input type="text" name="closing_date" id="closing-date" value="{$form_values.closing_date.value|date_format:"%e-%m-%Y %R"}" />
                {call check_if_error var_name="closing_date"}
            </div>
        </div>

        {assign "default_own" "{{$count_users * 0.66}|ceil}"}

        <div class="round-creation-field">
            <fieldset>
                <legend>{t}Report options{/t}</legend>

                <button id="report-info-box-button" class="btn btn-link">+ {t}Show info{/t}</button>
                <div id="report-field-info" class="alert alert-info">
                    {t}The following fields can be used to set the amount of people each person has to be reviewed by and has to review in order to view their own report.{/t}
                    <br />{t}If a field is blank the default values will be used. If a field has the value zero (0) there won't be a limit for that field.{/t}
                    <br />
                    <br /><strong>{t}Default values{/t}:</strong>
                    <br />{t}Minimum to be reviewed by{/t}: {{$count_users * 0.50}|ceil} ({t}50% of the default total amount to review, rounded up{/t})
                    <br />{t}Minimum to review{/t}: {{$count_users * 0.50}|ceil} ({t}50% of the default total amount to review, rounded up{/t})
                    <br />
                    <br /><strong>{t}Note:{/t}</strong> {t}These values can be changed after the round has started.{/t}
                </div>

                {create_control_group input_name="min_reviewed_by" label_text="{t}Minimum to be reviewed by{/t}"}
                {create_control_group input_name="min_to_review" label_text="{t}Minimum to review{/t}"}
            </fieldset>
        </div>

        <div class="form-actions">
            <a href="{$smarty.const.BASE_URI}{$smarty.const.ADMIN_URI}round" class="btn">{t}Cancel{/t}</a>
            <button type="submit" class="btn btn-primary">
                {t}Update round{/t}
            </button>
        </div>
    </fieldset>
</form>

<script type="text/javascript">
    $(document).ready(function()
    {
        $('#report-info-box-button').click(function(event)
        {
            if($('#report-field-info').is(':visible'))
            {
                $(this).text('+ {t}Show info{/t}');
            }
            else
            {
                $(this).text('- {t}Hide info{/t}');
            }

            $('#report-field-info').slideToggle();
            event.preventDefault();
        });

        $('[name="total_amount_to_review"]').change(function()
        {
            if($(this).val() != '')
            {
                var total_amount_to_review = parseInt(Math.floor($(this).val()));

                if(total_amount_to_review < parseInt('{$count_users}'))
                {
                    $('[name="own_amount_to_review"]').attr('max', total_amount_to_review + 1);
                }
            }
        });

        $('input').change(function()
        {
            $(this).parents('.control-group').removeClass('error').find('span.help-inline').empty();
        });

        $('#closing-date').datetimepicker(
        {
            // Prevent a user from chosing datetimes before the current datetime
            startDate: '{$smarty.now|date_format:'%Y-%m-%d %H:00:00'}',
            // Makes sure the minutes are set to 00
            initialDate: '{$smarty.now|date_format:'%Y-%m-%d %H:00:00'}',
            minView: 'day',
            maxView: 'year',
            format: 'dd-m-yyyy hh:ii',
            language: locale
        });
    });
</script>
