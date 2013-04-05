<script type="text/javascript" src="{$base_uri}lib/js/add_role.js"></script>

<div class="container">
    <form action="{$admin_uri}/department/submit" method="POST" class="form-horizontal">
        <fieldset>
            <div id="legend">
                <legend class="">New department</legend>
            </div>

            <div class="control-group">
                <input type="hidden" name="type" value="department">
                <label class="control-label" for="departmentName">Department name</label>
                <div class="controls">
                    <input id="departmentName" name="name" type="text" placeholder="Department name" class="input-large">
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">Manager</label>
                <input type="hidden" name="user[type]" value="user">
                <div class="controls">
                    {if isset($managerOptions) && count($managerOptions) >= 1}
                        {html_options name="user[id]" options=$managerOptions}
                    {else}
                        No managers/admins found
                        <input type="hidden" name="user[id]" value=" ">
                    {/if}
                </div>
            </div>

            <div class="control-group">
                <input type="hidden" name="ownRoles[0][type]" value="role">
                <label class="control-label">Role(s)</label>
                <div class="controls" id="roleList">
                    <div>
                        <input id="name" name="ownRoles[0][name]" type="text" placeholder="Role name" class="input-large">
                        <input id="description" name="ownRoles[0][description]" type="text" placeholder="Role description" class="input-large">
                    </div>
                </div>
            </div>

            <div class="control-group">
                <div class="controls">
                    <a id="addRoleButton" href="javascript:add_role();"><strong>+</strong> Add role</a>
                </div>
            </div>

            <div class="control-group">
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Create department</button>
                    <button type="button" class="btn" onClick="history.go(-1);return true;">Cancel</button>
                </div>
            </div>
        </fieldset>
    </form>
</div>