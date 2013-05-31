<h4>Are you sure you want to delete {if $type == "user"}{$type} {$user.firstname} {$user.lastname}{else}{$type} {${$type}.name}{/if}</h4>
<br />

<div class="alert">
    <strong>Warning!</strong> You won't be able to undo this action.
</div>
<br />
<form action="{$level_uri}{$type}/{${$type}.id}" method="post">
    <input type="hidden" name="_method" value="DELETE" id="_method" />
    <div class="form-actions">
        <button type="button" class="btn" onclick="history.go(-1);return true;">Cancel</button>
        <button type="submit" class="btn btn-danger">Delete {$type}</button>
    </div>
</form>
