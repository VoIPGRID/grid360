<h4>Are you sure you don't want to review {$reviewee.firstname} {$reviewee.lastname}?</h4>
<br />

<div class="alert">
    <strong>Warning!</strong> You won't be able to review this person again.
</div>
<br />

<div class="form-actions">
    <form action="{$BASE_URI}feedback/skip" method="post">
        <input type="hidden" name="reviewee_id" value="{$reviewee.id}" />
        <button type="button" class="btn">Cancel</button>
        <button type="submit" class="btn btn-primary">Yes</button>
    </form>
</div>
