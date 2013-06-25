{include file="lib/functions.tpl"}

<div class="row">
    <form class="form-vertical" action="{$smarty.const.BASE_URI}register" method="post">
        <fieldset>
            <div class="control-group {if isset($form_values.organisation_name.error)}error{/if}">
                <label class="control-label" for="organisation-name">Organisation name</label>

                <div class="controls">
                    <div class="input-prepend">
                        <span class="add-on"><i class="icon-sitemap"></i></span>
                        <input type="text" name="organisation_name" id="organisation-name" class="input-large" value="{$form_values.organisation_name.value}" />
                    </div>
                    {call check_if_error var_name="organisation_name"}
                </div>
            </div>
        </fieldset>

        <fieldset>
            <legend>{t}Personal credentials{/t}</legend>

            <div class="control-group {if isset($form_values.firstname.error)}error{/if}">
                <input type="hidden" name="type" value="user" />
                <label class="control-label" for="firstname">{t}First name{/t}</label>

                <div class="controls">
                    <input id="firstname" name="firstname" type="text" placeholder="{t}First name{/t}" class="input-large" required value="{$form_values.firstname.value}" />
                    {call check_if_error var_name="firstname"}
                </div>
            </div>

            <div class="control-group {if isset($form_values.lastname.error)}error{/if}">
                <label class="control-label" for="lastname">{t}Last name{/t}</label>

                <div class="controls">
                    <input type="text" name="lastname" id="lastname" placeholder="{t}Last name{/t}" class="input-large" required value="{$form_values.lastname.value}" />
                    {call check_if_error var_name="lastname"}
                </div>
            </div>

            <div class="control-group {if isset($form_values.email.error)}error{/if}">
                <label class="control-label" for="email">{t}Email{/t}</label>

                <div class="controls">
                    <div class="input-prepend">
                        <span class="add-on"><i class="icon-envelope"></i></span>
                        <input type="email" name="email" id="email" placeholder="{t}example@email.com{/t}" class="input-large" value="{$form_values.email.value}" />
                    </div>
                    {call check_if_error var_name="email"}
                </div>
            </div>

            <div class="control-group {if isset($form_values.password.error)}error{/if}">
                <label class="control-label" for="password">{t}Password{/t}</label>

                <div class="controls">
                    <div class="input-prepend">
                        <span class="add-on"><i class="icon-lock"></i></span>
                        <input type="password" name="password" id="password" class="input-large" value="{$form_values.password.value}"/>
                    </div>
                    {call check_if_error var_name="password"}
                </div>
            </div>

            <div class="control-group">
                <div class="controls">
                    <button type="button" class="btn" onclick="history.go(-1);return true;">{t}Cancel{/t}</button>
                    <button type="submit" class="btn btn-primary" id="login-button">{t}Register{/t}</button>
                </div>
            </div>
        </fieldset>
    </form>
</div>
