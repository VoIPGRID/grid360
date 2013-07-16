{include file="lib/functions.tpl"}

<div class="row">
    <form class="form-vertical reset" action="{$smarty.const.BASE_URI}reset" method="post">
        <div class="control-group {if isset($form_values.email.error)}error{/if}">
            <label class="control-label" for="email">{t}Email{/t}</label>
            <div class="controls">
                <div class="input-prepend">
                    <span class="add-on"><i class="icon-envelope"></i></span>
                    <input type="email" name="email" id="email" class="input-large" autofocus value="{$form_values.email.value}" />
                </div>
                {call check_if_error var_name="email"}
            </div>
        </div>

        <button type="button" class="btn" onclick="history.go(-1);return true;">{t}Cancel{/t}</button>
        <button type="submit" class="btn btn-primary">{t}Reset password{/t}</button>
    </form>
</div>
