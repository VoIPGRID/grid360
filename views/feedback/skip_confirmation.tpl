<h4>Are you sure you don't want to review {$reviewee.firstname} {$reviewee.lastname}?</h4>
<br />

<div class="alert">
    <strong>Warning!</strong> You won't be able to review this person again.
</div>
<br />
<form action="{$BASE_URI}feedback/skip" method="post">
    <div class="form-actions">
        <input type="hidden" name="reviewee_id" value="{$reviewee.id}" />
        <button type="button" class="btn" onclick="history.go(-1);return true;">Cancel</button>
        <button type="submit" class="btn btn-primary">Skip person</button>
    </div>
</form>
