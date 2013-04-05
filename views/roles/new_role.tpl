<div class="container">
    <form action="{$manager_uri}/role/submit" method="POST" class="form-horizontal">
        <fieldset>
            <div id="legend">
                <legend class="">New role</legend>
            </div>

            <div class="control-group">
                <input type="hidden" name="type" value="role">
                <label class="control-label" for="roleName">Role name</label>
                <div class="controls">
                    <input id="roleName" name="name" type="text" placeholder="Role name" class="input-large">
                </div>
            </div>

            <div class="control-group">
                <input type="hidden" name="type" value="role">
                <label class="control-label" for="roleDescription">Role description</label>
                <div class="controls">
                    <input id="roleDescription" name="description" type="text" placeholder="Role description" class="input-large">
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="departmentName">Department</label>
                <input type="hidden" name="department[type]" value="department">
                <div class="controls">
                    {if isset($departmentOptions) && count($departmentOptions) >= 1}
                        {html_options name="department[id]" options=$departmentOptions}
                    {else}
                        No departments found
                        <input type="hidden" name="department[id]" value=" ">
                    {/if}
                </div>
            </div>

            <div class="control-group">
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Create role</button>
                    <button type="button" class="btn" onClick="history.go(-1);return true;">Cancel</button>
                </div>
            </div>
        </fieldset>
    </form>
</div>