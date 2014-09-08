{include file="lib/functions.tpl"}

<form action="{$smarty.const.BASE_URI}profile" method="POST" class="form-horizontal" data-persist="garlic">
    {if $display_password_form}
        <fieldset>
            <legend>{t}New password{/t}</legend>

            <div class="control-group {if isset($form_values.new_password.error)}error{/if}">
                <label class="control-label" for="new-password">{t}New password{/t}</label>

                <div class="controls">
                    <input type="password" id="new-password" name="new_password" placeholder="{t}New password{/t}" class="input-xlarge">
                    {call check_if_error var_name="new_password"}
                </div>
            </div>

            <div class="control-group {if isset($form_values.new_password.error)}error{/if}">
                <label class="control-label" for="new-password-confirm">{t}Confirm new password{/t}</label>

                <div class="controls">
                    <input type="password" id="new-password-confirm" name="new_password_confirm" placeholder="{t}Confirm new password{/t}" class="input-xlarge">
                    {call check_if_error var_name="new_password"}
                </div>
            </div>
        </fieldset>
    {/if}

    <fieldset>
        <legend>{t}Agreements{/t}</legend>

        {if !empty($form_values.agreements.error)}
            {call print_alert type="error" text="{$form_values.agreements.error}"}
        {/if}

        <span><p>{t}Here you can enter the agreements you've made in your last performance review{/t}</p></span>

        <div id="profile-agreement-fields"{if $agreements.id != 0 && !$agreements.has_agreements} class="hide"{/if}>
            <div class="control-group">
                <label class="control-label" for="work_agreements">{t}Work agreements{/t} <span class="required">*</span></label>

                <div class="controls">
                    <textarea id="work_agreements" name="work" placeholder="{t}Work agreements{/t}" class="input-xxlarge">{$form_values.work.value}</textarea>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="training_agreements">{t}Training agreements{/t} <span class="required">*</span></label>

                <div class="controls">
                    <textarea id="training_agreements" name="training" placeholder="{t}Training agreements{/t}" class="input-xxlarge">{$form_values.training.value}</textarea>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="other_agreements">{t}Other agreements{/t}</label>

                <div class="controls">
                    <textarea id="other_agreements" name="other" placeholder="{t}Other agreements{/t}" class="input-xxlarge">{$form_values.other.value}</textarea>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="personal_goals">{t}Personal goals{/t} <span class="required">*</span></label>

                <div class="controls">
                    <textarea id="personal_goals" name="goals" placeholder="{t}Personal goals{/t}" class="input-xxlarge">{$form_values.goals.value}</textarea>
                </div>
            </div>
        </div>

        {if $display_has_agreements || ($agreements.id != 0 && !$agreements.has_agreements)}
            <div>
                {if $agreements.id == 0}
                    <input type="hidden" id="has-agreements" name="has_agreements" value="1" data-storage="false" />
                    <button id="has-agreements-button" class="btn btn-link">{t}I haven't made any agreements yet{/t}</button>
                {else}
                    <input type="hidden" id="has-agreements" name="has_agreements" value="0" data-storage="false" />
                    <button id="has-agreements-button" class="btn btn-link">{t}I have agreements{/t}</button>
                {/if}
            </div>
        {/if}

        <div class="form-actions">
            <a href="{$smarty.const.BASE_URI}" class="btn">{t}Cancel{/t}</a>
            <button type="submit" class="btn btn-primary">
                {t}Save changes{/t}
            </button>
        </div>
    </fieldset>
</form>

<script type="text/javascript">
    $(document).ready(function()
    {
        $('#has-agreements-button').click(function()
        {
            var has_agreements = $('#has-agreements').val();

            if(has_agreements == 1)
            {
                $('#profile-agreement-fields').addClass('hide');
                $('#has-agreements').val(0);
                $(this).text('{t}I have agreements{/t}');
            }
            else
            {
                $('#profile-agreement-fields').removeClass('hide');
                $('#has-agreements').val(1);
                $(this).text("{t}I haven't made any agreements yet{/t}");
            }

            event.preventDefault();
        });
    });
</script>
