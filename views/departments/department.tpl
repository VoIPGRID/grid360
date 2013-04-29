<script type="text/javascript" src="{$BASE_URI}assets/js/add_role.js"></script>

<form action="{$ADMIN_URI}department/submit" method="post" class="form-horizontal">
    <fieldset>
        {if $update && isset($department)}
            <legend>Editing department {$department.name}</legend>
        {else}
            <legend>New department</legend>
        {/if}

        <div class="control-group">
            <input type="hidden" name="type" value="department" />
            {if isset($department)}
                <input type="hidden" name="id" value="{$department.id}" />
            {/if}

            <label class="control-label" for="departmentName">Department name</label>

            <div class="controls">
                {if isset($department)}
                    <input id="departmentName" name="name" type="text" placeholder="Department name" class="input-large" value="{$department.name}" />
                {else}
                    <input id="departmentName" name="name" type="text" placeholder="Department name" class="input-large" />
                {/if}
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="departmentName">Manager</label>
            <input type="hidden" name="user[type]" value="user" />

            <div class="controls">
                {if isset($managerOptions) && count($managerOptions) >= 1}
                    {html_options name="user[id]" options=$managerOptions selected=$department.user.id}
                {else}
                    No managers/admins found
                {/if}
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">Role(s)</label>

            <div id="roleList">
                {if isset($department) && count($department.ownRole) >= 1}
                    {assign "index" 0}
                    {foreach $department.ownRole as $role}
                        <div class="controls">
                            <input type="hidden" name="ownRoles[{$index}][type]" value="role" />
                            <input type="hidden" name="ownRoles[{$index}][id]" value="{$role.id}" />
                            <input name="ownRoles[{$index}][name]" type="text" placeholder="Role name" class="input-xlarge" value="{$role.name}" />
                            <textarea name="ownRoles[{$index}][description]" placeholder="Role description" class="input-xxlarge">{$role.description}</textarea>
                        </div>
                        {assign "index" {counter}}
                    {/foreach}
                {else}
                    <div class="controls">
                        <input type="hidden" name="ownRoles[0][type]" value="role" />
                        <input name="ownRoles[0][name]" type="text" placeholder="Role name" class="input-xlarge" />
                        <textarea name="ownRoles[0][description]" placeholder="Role description" class="input-xxlarge"></textarea>
                    </div>
                {/if}
            </div>
        </div>

        <div class="control-group">
            <div class="controls">
                <button class="btn btn-link"><strong>+</strong> Add role</button>
            </div>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-primary">
                {if $update}
                    Update department
                {else}
                    Create department
                {/if}
            </button>
            <button type="button" class="btn" onclick="history.go(-1);return true;">Cancel</button>
        </div>
    </fieldset>
</form>
