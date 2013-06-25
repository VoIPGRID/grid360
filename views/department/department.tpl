{include file="lib/functions.tpl"}

<script type="text/javascript">
    type = 'role';
</script>
<script type="text/javascript" src="{$smarty.const.BASE_URI}assets/js/add_row.js"></script>

{if isset($form_values.error)}
    {call print_alert type="error" text="{$form_values.error}"}
{/if}

<form action="{$smarty.const.ADMIN_URI}department/{$form_values.id.value}" method="post" class="form-horizontal">
    <fieldset>
        {if $update && isset($form_values.id.value)}
            <legend>{t name=$competency_name}Updating department %1{/t}</legend>
        {else}
            <legend>{t}Creating new department{/t}</legend>
        {/if}

        <div class="control-group {if isset($form_values.name.error)}error{/if}">
            <input type="hidden" name="type" value="department" />
            {*<input type="hidden" name="id" value="{$form_values.id.value}" />*}

            <label class="control-label" for="department_name">{t}Department name{/t}</label>

            <div class="controls">
                <input id="department-name" name="name" type="text" placeholder="{t}Department name{/t}" class="input-large" required value="{$form_values.name.value}" />
                {call check_if_error var_name="name"}
            </div>
        </div>

        <div class="control-group {if isset($form_values.user.error)}error{/if}">
            <label class="control-label">Manager</label>
            <input type="hidden" name="user[type]" value="user" />

            <div class="controls">
                {if isset($manager_options) && !empty($manager_options)}
                    {html_options name="user[id]" options=$manager_options selected=$form_values.user.value}
                {else}
                    {t}No managers/admins found{/t}
                {/if}
                {call check_if_error var_name="user"}
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">{t}Role(s){/t}</label>

            <div id="role-list">
                {if isset($form_values.roles.value) && count($form_values.roles.value) > 0} {* Using count > 0 here because !empty doesn't work for some reason *}
                    {assign "index" 0}
                    {foreach $form_values.roles.value as $role}
                        <div class="controls">
                            <input type="hidden" name="ownRole[{$index}][type]" value="role" />
                            <input type="hidden" name="ownRole[{$index}][id]" value="{$role.id}" />
                            <input name="ownRole[{$index}][name]" type="text" placeholder="{t}Role name{/t}" class="input-xlarge" value="{$role.name}" />
                            <textarea name="ownRole[{$index}][description]" placeholder="{t}Role description{/t}" class="input-xxlarge">{$role.description}</textarea>
                        </div>
                        {assign "index" {counter}}
                    {/foreach}
                {else}
                    <div class="controls">
                        <input type="hidden" name="ownRole[0][type]" value="role" />
                        <input name="ownRole[0][name]" type="text" placeholder="{t}Role name{/t}" class="input-xlarge" />
                        <textarea name="ownRole[0][description]" placeholder="{t}Role description{/t}" class="input-xxlarge"></textarea>
                    </div>
                {/if}
            </div>
        </div>

        <div class="control-group">
            <div class="controls">
                <button id="add-button" class="btn btn-link"><strong>+</strong> {t}Add role{/t}</button>
            </div>
        </div>

        <div class="form-actions">
            <button type="button" class="btn" onclick="history.go(-1);return true;">{t}Cancel{/t}</button>
            <button type="submit" class="btn btn-primary">
                {if $update}
                    {t}Update department{/t}
                {else}
                    {t}Create new department{/t}
                {/if}
            </button>
        </div>
    </fieldset>
</form>
