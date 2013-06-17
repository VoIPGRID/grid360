<div class="row">
    <form class="form-vertical" action="{$smarty.const.BASE_URI}reset" method="post">
        <div class="control-group {if isset($form_values.email.error)}error{/if}">
            <label class="control-label" for="email">Email</label>
            <div class="controls">
                <div class="input-prepend">
                    <span class="add-on"><i class="icon-envelope"></i></span>
                    <input type="email" name="email" id="email" class="input-large" autofocus value="{$form_values.email.value}" />
                </div>
                {check_if_error var_name="email"}
            </div>
        </div>

        <div class="actions">
            <button type="button" class="btn" onclick="history.go(-1);return true;">Cancel</button>
            <button type="submit" class="btn btn-primary">Reset password</button>
        </div>
    </form>
</div>
