<h4>{t}Are you sure you want to delete the{/t} {if $type == "user"}{$type} {$user.firstname} {$user.lastname}{else}{$type} {${$type_var}.name}{/if}</h4>
<br />

{call print_alert type="warning" text="{t}You won't be able to undo this action.{/t}" show_close_button=false show_bolded_type=true}

<br />
<form action="{$level_uri}{$type_var}/{${$type_var}.id}" method="post">
    <input type="hidden" name="_method" value="DELETE" id="_method" />
    <div class="form-actions">
        <button type="button" class="btn" onclick="history.go(-1);return true;">Cancel</button>
        <button type="submit" class="btn btn-danger">{t}Delete{/t} {$type}</button>
    </div>
</form>
