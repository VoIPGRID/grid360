<form action="{$MANAGER_URI}role/submit" method="POST" class="form-horizontal">
    <fieldset>
        {if $update && isset($role)}
            <legend>Editing role {$role.name}</legend>
        {else}
            <legend>New role</legend>
        {/if}


        <div class="control-group">
            {if isset($role)}
                <input type="hidden" name="id" value={$role.id} />
            {/if}
            <input type="hidden" name="type" value="role" />
            <label class="control-label" for="role-name">Role name</label>

            <div class="controls">
                <input id="role-name" name="name" type="text" placeholder="Role name" class="input-large" {if isset($role)}value="{$role.name}"{/if} />
            </div>
        </div>

        <div class="control-group">
            <input type="hidden" name="type" value="role" />
            <label class="control-label" for="role-description">Role description</label>

            <div class="controls">
                <textarea id="role-description" name="description" placeholder="Role description" class="input-xxlarge">{if isset($role)}value="{$role.description}"{/if}</textarea>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">Department</label>
            <input type="hidden" name="department[type]" value="department" />

            <div class="controls">
                {if isset($department_options) && count($department_options) >= 1}
                    {html_options name="department[id]" options=$department_options}
                {else}
                    No departments found
                    <input type="hidden" name="department[id]" value=" " />
                {/if}
            </div>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-primary">
                {if $update}
                    Update role
                {else}
                    Create role
                {/if}
            </button>
            <button type="button" class="btn" onclick="history.go(-1);return true;">Cancel</button>
        </div>
    </fieldset>
</form>
