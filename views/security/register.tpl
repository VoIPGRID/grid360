<div class="row">
    <form class="form-vertical" action="{$smarty.const.BASE_URI}register" method="post">
        <fieldset>
            <div class="control-group">
                <label class="control-label" for="organisation-name">Organisation name</label>

                <div class="controls">
                    <div class="input-prepend">
                        <span class="add-on"><i class="icon-sitemap"></i></span>
                        <input type="text" name="organisation_name" id="organisation-name" class="input-large">
                    </div>
                </div>
            </div>
        </fieldset>

        <fieldset>
            <legend>Personal credentials</legend>

            <div class="control-group {if isset($form_values.firstname.error)}error{/if}">
                <input type="hidden" name="type" value="user" />
                {if isset($form_values.id.value)}
                    <input type="hidden" name="id" value="{$form_values.id.value}" />
                {/if}

                <label class="control-label" for="firstname">First name</label>

                <div class="controls">
                    <input id="firstname" name="firstname" type="text" placeholder="First name" class="input-large" required {if isset($form_values.firstname.value)}value="{$form_values.firstname.value}"{/if} />
                    {if isset($form_values.firstname.error)}
                        <span class="help-inline">{$form_values.firstname.error}</span>
                    {/if}
                </div>
            </div>

            <div class="control-group {if isset($form_values.lastname.error)}error{/if}">
                <label class="control-label" for="lastname">Last name</label>

                <div class="controls">
                    <input id="lastname" name="lastname" type="text" placeholder="Last name" class="input-large" required {if isset($form_values.lastname.value)}value="{$form_values.lastname.value}"{/if} />
                    {if isset($form_values.lastname.error)}
                        <span class="help-inline">{$form_values.lastname.error}</span>
                    {/if}
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="email">Email</label>

                <div class="controls">
                    <div class="input-prepend">
                        <span class="add-on"><i class="icon-envelope"></i></span>
                        <input type="email" name="email" id="email" class="input-large">
                    </div>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="password">Password</label>

                <div class="controls">
                    <div class="input-prepend">
                        <span class="add-on"><i class="icon-lock"></i></span>
                        <input type="password" name="password" id="password" class="input-large">
                    </div>
                </div>
            </div>

            <div class="control-group">
                <div class="controls">
                    <button type="submit" class="btn btn-primary" id="login-button">Register</button>
                </div>
            </div>
        </fieldset>
    </form>
</div>
