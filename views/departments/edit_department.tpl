<script type="text/javascript" src="{$base_uri}assets/js/add_role.js"></script>

<div class="container">
    <form action="{$admin_uri}/department/submit" method="post" class="form-horizontal">
        <fieldset>
            <legend>Editing department {$department.name}</legend>

            <div class="control-group">
                <input type="hidden" name="type" value="department" />
                <input type="hidden" name="id" value={$department.id} />
                <label class="control-label" for="departmentName">Department name</label>

                <div class="controls">
                    <input id="departmentName" name="name" type="text" placeholder="Department name" class="input-large" value="{$department.name}" />
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
                        <input type="hidden" name="user[id]" value=" " />
                    {/if}
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">Role(s)</label>

                <div id="roleList">
                    {assign "index" 0}
                    {foreach $department.ownRole as $role}
                        <div class="controls">
                            <input type="hidden" name="ownRoles[{$index}][type]" value="role" />
                            <input type="hidden" name="ownRoles[{$index}][id]" value={$role.id} />
                            <input name="ownRoles[{$index}][name]" type="text" placeholder="Role name" class="input-xlarge" value="{$role.name}" />
                            <textarea name="ownRoles[{$index}][description]" type="text" placeholder="Role description" class="input-xxlarge">{$role.description}</textarea>
                        </div>
                        {assign "index" {counter}}
                    {/foreach}
                </div>
            </div>

            <div class="control-group">
                <div class="controls">
                    <button class="btn btn-link"><strong>+</strong> Add role</button>
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