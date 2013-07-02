{include file="lib/functions.tpl"}

<form action="{$smarty.const.BASE_URI}{$smarty.const.MANAGER_URI}role/{$role.id}" method="POST" class="form-horizontal">
    <fieldset>
        {if $update && isset($form_values.id.value)}
            <legend>{t name=$role_name}Updating role %1{/t}</legend>
        {else}
            <legend>{t}Creating new role{/t}</legend>
        {/if}

        <div class="control-group {if isset($form_values.name.error)}error{/if}">
            {if isset($form_values.id.value)}
                <input type="hidden" name="id" value="{$form_values.id.value}" />
            {/if}
            <input type="hidden" name="type" value="role" />
            <label class="control-label" for="role-name">Role name</label>

            <div class="controls">
                <input id="role-name" name="name" type="text" placeholder="Role name" class="input-large" required value="{$form_values.name.value}" />
                {call check_if_error var_name="name"}
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="role-description">{t}Role description{/t}</label>

            <div class="controls">
                <textarea id="role-description" name="description" placeholder="{t}Role description{/t}" class="input-xxlarge">{$form_values.description.value}</textarea>
            </div>
        </div>

        <div class="control-group {if isset($form_values.department.error)}error{/if}">
            <label class="control-label">{t}Department{/t}</label>
            <input type="hidden" name="department[type]" value="department" />

            <div id="competency-list">
                <div class="controls">
                    {if !empty($department_options)}
                        {html_options name="department[id]" options=$department_options}
                    {else}
                        {t}No departments found{/t}
                    {/if}
                    {call check_if_error var_name="department"}
                </div>
            </div>
        </div>

        <div class="control-group {if isset($form_values.competencygroup.error)}error{/if}">
            <label class="control-label">{t}Competency group{/t}</label>
            <input type="hidden" name="competencygroup[type]" value="competencygroup" />

            <div id="competency-list">
                <div class="controls">
                    {if !empty($competencygroup_options)}
                        {html_options name="competencygroup[id]" options=$competencygroup_options}
                    {else}
                        {t}No competency groups found{/t}
                    {/if}
                    {*<button id="create-group" class="btn btn-link"><strong>+</strong> Create new competency group</button>*}
                    {call check_if_error var_name="competencygroup"}
                </div>
            </div>
        </div>

        <div class="form-actions">
            <button type="button" class="btn" onclick="history.go(-1);return true;">{t}Cancel{/t}</button>
            <button type="submit" class="btn btn-primary">
                {if $update}
                    {t}Update role{/t}
                {else}
                    {t}Create new role{/t}
                {/if}
            </button>
        </div>
    </fieldset>
</form>
