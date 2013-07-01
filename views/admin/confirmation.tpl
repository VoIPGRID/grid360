<h4>Are you sure you want to reset the database?</h4>
<br />

<div class="alert">
    <strong>Warning!</strong> This will clear your current data.
</div>
<br />

<div class="form-actions">
    <form action="{$smarty.const.BASE_URI}{$smarty.const.ADMIN_URI}reset" method="post">
        <button type="submit" class="btn btn-danger">Reset database</button>
        <button type="button" class="btn">Cancel</button>
    </form>
</div>
