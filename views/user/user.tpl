<form action="{$smarty.const.ADMIN_URI}user/{$form_values.id.value}" method="POST" class="form-horizontal">
    <fieldset>
        {if $update && isset($form_values.id.value)}
            <legend>Updating user {$form_values.firstname.value} {$form_values.lastname.value}</legend>
        {else}
            <legend>Creating new user</legend>
        {/if}

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

        <div class="control-group {if isset($form_values.email.error)}error{/if}">
            <label class="control-label" for="email">Email</label>

            <div class="controls">
                <input id="email" name="email" type="email" placeholder="example@email.com" class="input-large" required {if isset($form_values.email.value)}value="{$form_values.email.value}"{/if} />
                {if isset($form_values.email.error)}
                    <span class="help-inline">{$form_values.email.error}</span>
                {/if}
            </div>
        </div>

        <div class="control-group {if isset($form_values.department.error)}error{/if}">
            <input type="hidden" name="department[type]" value="department" />
            <label class="control-label">Department</label>

            <div class="controls">
                <select name="department[id]">
                    <option value="0">Select department</option>
                    {$form_values.department.value}
                    {foreach $departments as $id => $department}
                        {if isset($form_values.department.value) && $id == $form_values.department.value}
                            <option value="{$id}" selected="selected">{$department.name}</option>
                        {else}
                            <option value="{$id}">{$department.name}</option>
                        {/if}
                    {/foreach}
                </select>
                {if isset($form_values.department.error)}
                    <span class="help-inline">{$form_values.department.error}</span>
                {/if}
            </div>
        </div>

        <div class="control-group {if isset($form_values.role.error)}error{/if}">
            <input type="hidden" name="role[type]" value="role" />
            <label class="control-label">Role</label>

            <div class="controls">
                <select name="role[id]">
                    <option value="0" data-department="0">Select role</option>
                    {foreach $roles as $id => $role}
                        {if $form_values.role.value && $id == $form_values.department.value}
                            <option value="{$id}" data-department="{$role.department.id}" selected="selected">{$role.name}</option>
                        {else}
                            <option value="{$id}" data-department="{$role.department.id}">{$role.name}</option>
                        {/if}
                    {/foreach}
                </select>
                {if isset($form_values.role.error)}
                    <span class="help-inline">{$form_values.role.error}</span>
                {/if}
            </div>
        </div>

        <div class="control-group">
            <input type="hidden" name="userlevel[type]" value="userlevel" />
            <label class="control-label">User level</label>

            <div class="controls">
                {if isset($user)}
                    {html_options name="userlevel[id]" options=$userlevel_options|capitalize selected={$user.userlevel.id}}
                {else}
                    {html_options name="userlevel[id]" options=$userlevel_options|capitalize selected=3}
                {/if}
            </div>
        </div>

        <div class="form-actions">
            <button type="button" class="btn" onclick="history.go(-1);return true;">Cancel</button>
            <button type="submit" class="btn btn-primary">
                {if $update}
                    Update user
                {else}
                    Create user
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
