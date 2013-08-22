<h4>{t firstname=$reviewee.firstname lastname=$reviewee.lastname}Are you sure you don't want to review %1 %2?{/t}</h4>
<br />

<div class="alert">
    <strong>{t}Warning{/t}!</strong> {t}You won't be able to review this person again this round.{/t}
</div>
<br />
<form action="{$smarty.const.BASE_URI}feedback/skip" method="post">
    <div class="form-actions">
        <input type="hidden" name="reviewee_id" value="{$reviewee.id}" />
        <a href="{$smarty.const.BASE_URI}feedback/{$reviewee.id}" class="btn">{t}Cancel{/t}</a>
        <button type="submit" class="btn btn-primary">{t}Skip person{/t}</button>
    </div>
</form>
