<div class="container">
    <h3>Are you sure you want to reset the database?</h3>
    <br>
    <div class="alert">
        <strong>Warning!</strong> This will clear your previous data.
    </div>
    <br>
    <div class="form-actions">
        <form action="{$admin_uri}/reset" method="post">
            <button type="submit" class="btn btn-danger">Reset database</button>
            <button type="button" class="btn">Cancel</button>
        </form>
    </div>
</div>