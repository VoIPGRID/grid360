{include file="lib/functions.tpl"}

<form action="{$smarty.const.ADMIN_URI}user/{$form_values.id.value}" method="POST" class="form-horizontal">
    <fieldset>
        {if $update && isset($form_values.id.value)}
            <legend>{t name=$competency_name}Updating user %1{/t}</legend>
        {else}
            <legend>{t}Creating new user{/t}</legend>
        {/if}

        <div class="control-group {if isset($form_values.firstname.error)}error{/if}">
            <input type="hidden" name="type" value="user" />
            {if isset($form_values.id.value)}
                <input type="hidden" name="id" value="{$form_values.id.value}" />
            {/if}

            <label class="control-label" for="firstname">{t}First name{/t}</label>

            <div class="controls">
                <input id="firstname" name="firstname" type="text" placeholder="{t}First name{/t}" class="input-large" required value="{$form_values.firstname.value}" />
                {call check_if_error var_name="firstname"}
            </div>
        </div>

        <div class="control-group {if isset($form_values.lastname.error)}error{/if}">
            <label class="control-label" for="lastname">{t}Last name{/t}</label>

            <div class="controls">
                <input id="lastname" name="lastname" type="text" placeholder="{t}Last name{/t}" class="input-large" required value="{$form_values.lastname.value}" />
                {call check_if_error var_name="lastname"}
            </div>
        </div>

        <div class="control-group {if isset($form_values.email.error)}error{/if}">
            <label class="control-label" for="email">{t}Email{/t}</label>

            <div class="controls">
                <input id="email" name="email" type="email" placeholder="{t}example@email.com{/t}" class="input-large" required value="{$form_values.email.value}" />
                {call check_if_error var_name="email"}
            </div>
        </div>

        <div class="control-group {if isset($form_values.department.error)}error{/if}">
            <input type="hidden" name="department[type]" value="department" />
            <label class="control-label">{t}Department{/t}</label>

            <div class="controls">
                <select name="department[id]">
                    <option value="0">{t}Select department{/t}</option>
                    {$form_values.department.value}
                    {foreach $departments as $id => $department}
                        {if isset($form_values.department.value) && $id == $form_values.department.value}
                            <option value="{$id}" selected="selected">{$department.name}</option>
                        {else}
                            <option value="{$id}">{$department.name}</option>
                        {/if}
                    {/foreach}
                </select>
                {call check_if_error var_name="department"}
            </div>
        </div>

        <div class="control-group {if isset($form_values.role.error)}error{/if}">
            <input type="hidden" name="role[type]" value="role" />
            <label class="control-label">{t}Role{/t}</label>

            <div class="controls">
                <select name="role[id]">
                    <option value="0" data-department="0">{t}Select role{/t}</option>
                    {foreach $roles as $id => $role}
                        {if $form_values.role.value && $id == $form_values.department.value}
                            <option value="{$id}" data-department="{$role.department.id}" selected="selected">{$role.name}</option>
                        {else}
                            <option value="{$id}" data-department="{$role.department.id}">{$role.name}</option>
                        {/if}
                    {/foreach}
                </select>
                {call check_if_error var_name="role"}
            </div>
        </div>

        <div class="control-group {if isset($form_values.userlevel.error)}error{/if}">
            <input type="hidden" name="userlevel[type]" value="userlevel" />
            <label class="control-label">User level</label>

            <div class="controls">
                {html_options name="userlevel[id]" options=$userlevel_options|capitalize selected={$form_values.userlevel.value|default:3}}

                {call check_if_error var_name="userlevel"}
            </div>
        </div>

        <div class="form-actions">
            <button type="button" class="btn" onclick="history.go(-1);return true;">{t}Cancel{/t}</button>
            <button type="submit" class="btn btn-primary">
                {if $update}
                    {t}Update user{/t}
                {else}
                    {t}Create new user{/t}
                {/if}
            </button>
        </div>
    </fieldset>
</form>

<script type="text/javascript">
    $(document).ready(function()
    {
        $('[name="department[id]"]').change(function()
        {
            $('[name="role[id]"] option').hide();

            var role_options = $('[name="role[id]"] option[data-department="' + $(this).val() + '"]');
            role_options.show();

            // Get the value of the first option in role_options and set the selected option to that value
            var option_to_select = role_options.first().val();
            $('[name="role[id]"]').val(option_to_select);
        });

        $('[name="department[id]"]').change();
    });
</script>
