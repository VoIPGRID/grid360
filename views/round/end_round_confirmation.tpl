<h4>Are you sure you want to end the current round?</h4>
<br />

<div class="alert">
    <strong>Warning!</strong> This will end the current round.
</div>
<br />
<form action="{$ADMIN_URI}round/end" method="post">
    <div class="form-actions">
        <button type="button" class="btn" onclick="history.go(-1);return true;">Cancel</button>
        <button type="submit" class="btn btn-primary">Yes</button>
    </div>
</form>
