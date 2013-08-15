{include file="lib/functions.tpl"}

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

<form action="{$smarty.const.BASE_URI}{$smarty.const.ADMIN_URI}round/confirm" method="post" class="form-horizontal" data-persist="garlic">
    <fieldset>
        <legend>{t}Create round{/t}</legend>

        <div id="description-group" class="control-group {if isset($form_values.description.error)}error{/if}">
            {if isset($form_values.id.value)}
                <input type="hidden" name="id" value={$form_values.id.value} />
            {/if}
            <label class="control-label" for="round-description">{t}Round description{/t}</label>

            <div class="controls">
                <textarea id="round-description" name="description" type="text" placeholder="{t}Round description{/t}" required>{$form_values.description.value}</textarea>
                {call check_if_error var_name="description"}
            </div>
        </div>

        <hr />

        {assign "default_own" "{{$count_users * 0.66}|ceil}"}

        <button id="info-box-button" class="btn btn-link">+ {t}Show info{/t}</button>
        <div id="field-info" class="alert alert-info"> {*TODO: Improve info text*}
            {t}The following fields can be used to set the amount of people each person has to review.{/t}
            <br />{t}If a field is blank the default values will be used.{/t}
            <br />
            <br /><strong>{t}Default values{/t}:</strong>
            <br />{t}Total amount to review{/t}: {$count_users} ({t}All users in your organisation minus 1, because of the reviewer{/t})
            <br />{t}Amount to review from own department{/t}: {$default_own} ({t}66% of the above number, rounded up{/t})
            <br />
            <br />{t}The amount of people that need to be reviewed from other departments will be calculated by the system.{/t}
            {t default_total=$count_users default_own=$default_own}This number will be: Total amount to review (default: %1) - Amount to review from own department (default: %2).{/t}
            {t default_own=$default_own}If there aren't enough people in the reviewer's own department (default: %1), all the available people from the department have to be reviewed.{/t}
            <br /><strong>{t}Note:{/t}</strong> {t}If there are no people in the reviewer's department he or she won't get any reviewees, because everybody always has to review atleast 1 person from his/her own department.{/t}
            <br />
            <br /><strong>{t}For example:{/t}</strong>
            <br />{t}Person A has 2 people in his own department. The total amount of people he has to review is 8.{/t}
            {t}Since there are only 2 people in his department, the remaining reviewees will be: 8 - 2 = 6 people from other departments.{/t}
        </div>

        <div class="round-creation-field">
            {if !$update}
                {create_control_group input_name="total_amount_to_review" label_text="{t}Total amount to review{/t}"}
                {create_control_group input_name="own_amount_to_review" label_text="{t}Amount to review from own department{/t}"}
            {/if}

            <fieldset>
                <legend>{t}Report options{/t}</legend>

                <button id="report-info-box-button" class="btn btn-link">+ {t}Show info{/t}</button>
                <div id="report-field-info" class="alert alert-info"> {*TODO: Improve info text*}
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
            <button type="button" class="btn" onclick="history.go(-1);return true;">{t}Cancel{/t}</button>
            <button type="submit" class="btn btn-primary">
                {if $update}
                    {t}Update round{/t}
                {else}
                    {t}Create round{/t}
                {/if}
            </button>
        </div>
    </fieldset>
</form>

<script type="text/javascript">
    $(document).ready(function()
    {
        $('#info-box-button').click(function(event)
        {
            if($('#field-info').is(':visible'))
            {
                $(this).text('+ {t}Show info{/t}');
            }
            else
            {
                $(this).text('- {t}Hide info{/t}');
            }

            $('#field-info').slideToggle();
            event.preventDefault();
        });

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
            $(this).parents('.control-group').removeClass('error').find('span').empty();
        });
    });
</script>
