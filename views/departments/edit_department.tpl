<script type="text/javascript" src="{$base_uri}lib/js/add_role.js"></script>

<div class="container">
    <form action="{$admin_uri}/department/submit" method="post" class="form-horizontal">
        <fieldset>
            <div id="legend">
                <legend class="">Editing department {$department.name}</legend>
            </div>

            <div class="control-group">
                <input type="hidden" name="type" value="department">
                <input type="hidden" name="id" value={$department.id}>
                <label class="control-label" for="departmentName">Department name</label>
                <div class="controls">
                    <input id="departmentName" name="name" type="text" placeholder="Department name" class="input-large" value={$department.name}>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="departmentName">Manager</label>
                <input type="hidden" name="user[type]" value="user">
                <div class="controls">
                    {if isset($managerOptions) && count($managerOptions) >= 1}
                        {html_options name="user[id]" options=$managerOptions selected=$department.user.id}
                    {else}
                        No managers/admins found
                        <input type="hidden" name="user[id]" value=" ">
                    {/if}
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">Role(s)</label>
                <div class="controls" id="roleList">
                    {counter start=0 print=false}
                    {foreach $department.ownRole as $role}
                        {$index = {counter}}
                        <input type="hidden" name="ownRoles[{$index}][type]" value="role">
                        <input type="hidden" name="ownRoles[{$index}][id]" value={$role.id}>
                        <div>
                            <label></label>
                            <input id="name" name="ownRoles[{$index}][name]" type="text" placeholder="Role name" class="input-large" value="{$role.name}">
                            <input id="description" name="ownRoles[{$index}][description]" type="text" placeholder="Role description" class="input-large" value="{$role.description}">
                        </div>
                    {/foreach}
                </div>
            </div>

            <div class="control-group">
                <div class="controls" id="roleList">
                    <a id="addRoleButton" href="javascript:add_role();"><strong>+</strong> Add role</a>
                </div>
            </div>

            <div class="control-group">
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Update department</button>
                    <button type="button" class="btn" onClick="history.go(-1);return true;">Cancel</button>
                </div>
            </div>
        </fieldset>
    </form>
</div>