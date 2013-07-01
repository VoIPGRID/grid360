{include file="lib/functions.tpl"}
<h4>{t type=$type name=$name}Are you sure you want to delete the %1 %2{/t}</h4>
<br />

{call print_alert type="warning" text="{t}You won't be able to undo this action.{/t}" show_close_button=false show_bolded_type=true}

<br />
<form action="{$smarty.const.BASE_URI}{$level_uri}{$type_var}/{${$type_var}.id}" method="post">
    <input type="hidden" name="_method" value="DELETE" id="_method" />
    <div class="form-actions">
        <button type="button" class="btn" onclick="history.go(-1);return true;">{t}Cancel{/t}</button>
        <button type="submit" class="btn btn-danger">{t}Delete{/t} {$type}</button>
    </div>
</form>
