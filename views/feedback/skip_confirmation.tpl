<h4>{$smarty.const.FEEDBACK_SKIP_TEXT|sprintf:$reviewee.firstname:$reviewee.lastname}</h4>
<br />

<div class="alert">
    <strong>{$smarty.const.FEEDBACK_SKIP_WARNING_BOLD}</strong> {$smarty.const.FEEDBACK_SKIP_WARNING_TEXT}
</div>
<br />
<form action="{$smarty.const.BASE_URI}feedback/skip" method="post">
    <div class="form-actions">
        <input type="hidden" name="reviewee_id" value="{$reviewee.id}" />
        <button type="button" class="btn" onclick="history.go(-1);return true;">{$smarty.const.BUTTON_CANCEL}</button>
        <button type="submit" class="btn btn-primary">{$smarty.const.FEEDBACK_SKIP_BUTTON}</button>
    </div>
</form>
