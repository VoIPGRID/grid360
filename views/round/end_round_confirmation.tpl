<h4>{t}Are you sure you want to end the current round{/t}?</h4>
<br />

<div class="alert">
    <strong>{t}Warning!{/t}</strong> {t}This will end the current round.{/t}
</div>
<br />
<form action="{$smarty.const.ADMIN_URI}round/end" method="post">
    <div class="form-actions">
        <button type="button" class="btn" onclick="history.go(-1);return true;">{t}Cancel{/t}</button>
        <button type="submit" class="btn btn-primary">{t}End round{/t}</button>
    </div>
</form>
