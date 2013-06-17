{function print_actions}
    {if $type == "user"}
        <td class="actions-user">
    {else}
        <td class="actions">
    {/if}
    <form action="{${$level|upper}_URI}{$type}/{${$type}.id}">
        <button data-toggle="tooltip" title="{t}Edit{/t}" data-placement="bottom" type="submit" class="btn btn-link">
            <i class="icon-pencil"></i>
        </button>
    </form>
    {if {$type} == "user"}
        <form action="{${$level|upper}_URI}{$type}/{${$type}.id}">
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
    <form action="{${$level|upper}_URI}{$type}/delete/{${$type}.id}">
        <button data-toggle="tooltip" title="{t}Delete{/t}" data-placement="bottom" type="submit" class="btn btn-link">
            <i class="icon-trash"></i>
        </button>
    </form>
    </td>
{/function}

{function print_add_link}
    <div class="pull-right">
        <a href="{${$level|upper}_URI}{$type_var}/create"><strong>+</strong> {t type=$type|ucfirst}Add %1{/t}</a>
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
