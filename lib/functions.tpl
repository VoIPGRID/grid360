{function print_actions}
    {if $type == "user"}
        <td class="actions-user">
    {else}
        <td class="actions">
    {/if}
    {if $level == "admin"}
        {assign level_uri $smarty.const.ADMIN_URI}
    {elseif $level == "manager"}
        {assign level_uri $smarty.const.MANAGER_URI}
    {/if}
    <form action="{$smarty.const.BASE_URI}{$level_uri}{$type}/{${$type}.id}">
        <button data-toggle="tooltip" title="{t}Edit{/t}" data-placement="bottom" type="submit" class="btn btn-link">
            <i class="icon-pencil"></i>
        </button>
    </form>
    {if {$type} == "user"}
        <form action="{$smarty.const.BASE_URI}{$level_uri}{$type}/{${$type}.id}">
            <input type="hidden" name="user_id" value="{${$type}.id}" />
            {if $user.status == 1}
                <button data-toggle="tooltip" title="{t}Pause feedback{/t}" data-placement="bottom" type="submit" class="btn btn-link status">
                    <i class="icon-pause"></i>
                </button>
            {else}
                <button data-toggle="tooltip" title="{t}Resume feedback{/t}" data-placement="bottom" type="submit" class="btn btn-link status">
                    <i class="icon-play"></i>
                </button>
            {/if}
        </form>
    {/if}
    <form action="{$smarty.const.BASE_URI}{$level_uri}{$type}/delete/{${$type}.id}">
        <button data-toggle="tooltip" title="{t}Delete{/t}" data-placement="bottom" type="submit" class="btn btn-link">
            <i class="icon-trash"></i>
        </button>
    </form>
    </td>
{/function}

{function print_add_link}
    {if $level == "admin"}
        {assign level_uri $smarty.const.ADMIN_URI}
    {elseif $level == "manager"}
        {assign level_uri $smarty.const.MANAGER_URI}
    {/if}
    <div class="pull-right">
        {assign "button_text" "{t type=$type}Add %1{/t}"}
        <a href="{$smarty.const.BASE_URI}{$level_uri}{$type_var}/create"><strong>+</strong> {$button_text|ucfirst}</a>
    </div>
{/function}

{function print_alert show_close_button=true show_bolded_type=false}
    <div class="alert alert-{$type}">
        {if $show_close_button}
            <button type="button" class="close" data-dismiss="alert">&times;</button>
        {/if}
        {if $show_bolded_type}
            <strong>{$type|capitalize}!</strong>
        {/if}
        {$text|ucfirst}
    </div>
{/function}

{function check_if_error}
    {if isset($form_values.{$var_name}.error)}
        <span class="help-inline">{$form_values.{$var_name}.error|ucfirst}</span>
    {/if}
{/function}
