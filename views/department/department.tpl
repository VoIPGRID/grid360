<script type="text/javascript">
    type = 'role';
</script>
<script type="text/javascript" src="{$smarty.const.BASE_URI}assets/js/add_row.js"></script>

<form action="{$smarty.const.ADMIN_URI}department/{$department.id}" method="post" class="form-horizontal">
    <fieldset>
        {if $update && isset($department)}
            <legend>Updating department {$department.name}</legend>
        {else}
            <legend>Creating new department</legend>
        {/if}

        <div class="control-group {if isset($form_values.name.error)}error{/if}">
            <input type="hidden" name="type" value="department" />
            {if isset($department)}
                <input type="hidden" name="id" value="{$department.id}" />
            {/if}

            <label class="control-label" for="department_name">Department name</label>

            <div class="controls">
                <input id="department-name" name="name" type="text" placeholder="Department name" class="input-large" required {if isset($department)}value="{$department.name}"{/if} />
                {if isset($form_values.name.error)}
                    <span class="help-inline">{$form_values.name.error}</span>
                {/if}
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">Manager</label>
            <input type="hidden" name="user[type]" value="user" />

            <div class="controls">
                {if isset($manager_options) && !empty($manager_options)}
                    {html_options name="user[id]" options=$manager_options selected=$department.user.id}
                {else}
                    No managers/admins found
                {/if}
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">Role(s)</label>

            <div id="role-list">
                {if isset($department) && count($department.ownRole) > 0} {* Using count > 0 here because !empty doesn't work for some reason *}
                    {assign "index" 0}
                    {foreach $department.ownRole as $role}
                        <div class="controls">
                            <input type="hidden" name="ownRole[{$index}][type]" value="role" />
                            <input type="hidden" name="ownRole[{$index}][id]" value="{$role.id}" />
                            <input name="ownRole[{$index}][name]" type="text" placeholder="Role name" class="input-xlarge" value="{$role.name}" />
                            <textarea name="ownRole[{$index}][description]" placeholder="Role description" class="input-xxlarge">{$role.description}</textarea>
                        </div>
                        {assign "index" {counter}}
                    {/foreach}
                {else}
                    <div class="controls">
                        <input type="hidden" name="ownRole[0][type]" value="role" />
                        <input name="ownRole[0][name]" type="text" placeholder="Role name" class="input-xlarge" />
                        <textarea name="ownRole[0][description]" placeholder="Role description" class="input-xxlarge"></textarea>
                    </div>
                {/if}
            </div>
        </div>

        <div class="control-group">
            <div class="controls">
                <button id="add-button" class="btn btn-link"><strong>+</strong> Add role</button>
            </div>
        </div>

        <div class="form-actions">
            <button type="button" class="btn" onclick="history.go(-1);return true;">Cancel</button>
            <button type="submit" class="btn btn-primary">
                {if $update}
                    Update department
                {else}
                    Create department
                {/if}
            </button>
        </div>
    </fieldset>
</form>
