{include file="lib/functions.tpl"}

<div class="row">
    {if isset($form_values.error)}
        {call print_alert type="error" text=$form_values.error}
    {/if}
    <form class="form-vertical reset" action="{$smarty.const.BASE_URI}reset" method="post">
        <div class="control-group {if isset($form_values.password.error)}error{/if}">
            <input type="hidden" name="uuid" value="{$smarty.get.uuid}"/>
            <input type="hidden" name="email" value="{$smarty.get.email}"/>

            <label class="control-label" for="password">{t}New password{/t}</label>

            <div class="controls">
                <div class="input-prepend">
                    <span class="add-on"><i class="icon-lock"></i></span>
                    <input type="password" name="password" id="password" class="input-large" required>
                </div>
                {call check_if_error var_name="password"}
            </div>
        </div>

        <div class="control-group {if isset($form_values.password_confirm.error)}error{/if}">
            <label class="control-label" for="password">{t}Confirm new password{/t}</label>

            <div class="controls">
                <div class="input-prepend">
                    <span class="add-on"><i class="icon-lock"></i></span>
                    <input type="password" name="password_confirm" id="password-confirm" class="input-large" required>
                </div>
                {call check_if_error var_name="password_confirm"}
            </div>
        </div>

        <a href="{$smarty.const.BASE_URI}login" class="btn">{t}Cancel{/t}</a>
        <button type="submit" class="btn btn-primary" id="login-button">{t}Change password{/t}</button>
    </form>
</div>
