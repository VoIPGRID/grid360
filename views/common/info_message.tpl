<div class="info-message-pre">
    {$info_message.message nofilter}
</div>

<form action="{$smarty.const.BASE_URI}infomessage" method="post" class="form-horizontal" data-persist="garlic">
    <button type="submit" class="btn btn-inverse pull-right">
        {t}Go to Dashboard{/t}
    </button>
</form>

{include file="layout/footer.tpl"}