<script type="text/javascript" src="{$base_uri}assets/js/add_role.js"></script>

<div class="container">
    <form action="{$admin_uri}/department/submit" method="POST" class="form-horizontal">
        <fieldset>
            <legend>New department</legend>

            <div class="control-group">
                <input type="hidden" name="type" value="department" />
                <label class="control-label" for="departmentName">Department name</label>

                <div class="controls">
                    <input id="departmentName" name="name" type="text" placeholder="Department name" class="input-large" />
                </div>
            </div>

            <div class="control-group">
                <input type="hidden" name="user[type]" value="user" />
                <label class="control-label">Manager</label>

                <div class="controls">
                    {if isset($managerOptions) && count($managerOptions) >= 1}
                        {html_options name="user[id]" options=$managerOptions}
                    {else}
                        No managers/admins found
                        <input type="hidden" name="user[id]" value=" " />
                    {/if}
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">Role(s)</label>

                <div id="roleList">
                    <div class="controls">
                        <input type="hidden" name="ownRoles[0][type]" value="role" />
                        <input name="ownRoles[0][name]" type="text" placeholder="Role name" class="input-xlarge" />
                        <textarea name="ownRoles[0][description]" type="text" placeholder="Role description" class="input-xxlarge"></textarea>
                    </div>
                </div>
            </div>

            <div class="control-group">
                <div class="controls">
                    <button class="btn btn-link"><strong>+</strong> Add role</button>
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