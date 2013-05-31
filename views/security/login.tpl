{if isset($error_type) && !empty($error_type)}
        {if $error_type == 1}
            {$error_message = "Wrong email/password combo!"}
        {elseif $error_type == 2}
            {$error_message = "Email can't be empty!"}
        {elseif $error_type == 3}
            {$error_message = "Password can't be empty!"}
        {elseif $error_type == 4}
            {$error_message = "Email and password can't be empty!"}
        {/if}
    {if isset($error_message) && !empty($error_message)}
        <div class="alert alert-error">
            <strong>Error!</strong>
            {$error_message}
        </div>
    {/if}
{/if}

{if isset($smarty.get.success)}
    <div class="alert alert-success">
        {$smarty.get.success}
    </div>
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
                <label class="checkbox">
                    <input type="checkbox" name="remember_me"> Remember me
                </label>
                <br />
                <button type="submit" class="btn btn-primary" id="login-button">Login</button>
            </div>
        </div>

        {*<a href="{$smarty.const.BASE_URI}register">Register new organisation</a>*}
    </form>
</div>
<br />
{*<form action="{$smarty.const.BASE_URI}login_google" method="get">
    <button class="btn pull-right">Login with Google</button>
</form>*}

<script type="text/javascript">
    $(document).ready(function()
    {
        $('.alert').delay(5000).fadeOut();

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
