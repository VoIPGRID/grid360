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

        <div class="form-actions">
            <a href="{$smarty.const.BASE_URI}" class="btn">{t}Cancel{/t}</a>
            <button type="submit" class="btn btn-primary">
                {t}Save changes{/t}
            </button>
        </div>
    </fieldset>
</form>
