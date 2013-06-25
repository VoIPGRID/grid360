{include file="lib/functions.tpl"}

{if isset($smarty.get.error) && !empty($smarty.get.error)}
    {call print_alert type="error" text="{$smarty.get.error}"}
{/if}

{if isset($smarty.get.success)}
    {call print_alert type="success" text="{$smarty.get.success}"}
{/if}

<div class="row">
    <form class="form-vertical" action="{$smarty.const.BASE_URI}login" method="post">
        <div class="control-group">
            <label class="control-label" for="email">Email</label>
            <div class="controls">
                <div class="input-prepend">
                    <span class="add-on"><i class="icon-envelope"></i></span>
                    <input type="email" name="email" id="email" class="input-large" autofocus>
                </div>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="password">{t}Password{/t}</label>
            <div class="controls">
                <div class="input-prepend">
                    <span class="add-on"><i class="icon-lock"></i></span>
                    <input type="password" name="password" id="password" class="input-large">
                </div>
            </div>
        </div>

        <div class="control-group">
            <div class="controls">
                <label class="checkbox">
                    <input type="checkbox" name="remember_me"> {t}Remember me{/t}
                </label>
                <br />
                <button type="submit" class="btn btn-primary" id="login-button">Login</button>
            </div>
        </div>
        <a href="{$smarty.const.BASE_URI}register">{t}Register new organisation{/t}</a>
        <br />
        <br />
        <a href="{$smarty.const.BASE_URI}reset">{t}Forgot password?{/t}</a>
    </form>

    <form class="form-vertical" action="{$smarty.const.BASE_URI}login_google" method="get">
        <button class="btn">{t}Login with Google{/t}</button>
    </form>
</div>
<br />

<script type="text/javascript">
    $(document).ready(function()
    {
        $('#login-button').click(function()
        {
            if($('#email').val().length == 0 && $('#password').val().length == 0)
            {
                $('#email').parents('.control-group').addClass('error');
                $('#password').parents('.control-group').addClass('error');
                return false;
            }
            else if($('#email').val().length == 0 && $('#password').val().length != 0)
            {
                $('#email').parents('.control-group').addClass('error');
                $('#password').parents('.control-group').removeClass('error');
                return false;
            }
            else if($('#email').val().length != 0 && $('#password').val().length == 0)
            {
                $('#email').parents('.control-group').removeClass('error');
                $('#password').parents('.control-group').addClass('error');
                return false;
            }
        });
    });
</script>
