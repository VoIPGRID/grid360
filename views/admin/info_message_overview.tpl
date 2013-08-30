{if !empty($info_message)}
    <a href="{$smarty.const.BASE_URI}{$smarty.const.ADMIN_URI}infomessage/view"></a>

    <a href="#info-message-modal" role="button" class="btn" data-toggle="modal">{t}View info message{/t}</a>

    <div id="info-message-modal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="modal-header" aria-hidden="true">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
            <h3 id="modal-header">{t}Info message{/t}</h3>
        </div>
        <div class="modal-body">
            <p>{$info_message.message nofilter}</p>
        </div>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">{t}Close{/t}</button>
        </div>
    </div>

    <a href="{$smarty.const.BASE_URI}{$smarty.const.ADMIN_URI}infomessage/edit" class="btn">{t}Edit info message{/t}</a>
{else}
    {t}No info message found{/t}
    <br />
    <br />
    <a href="{$smarty.const.BASE_URI}{$smarty.const.ADMIN_URI}infomessage/create">{t}Create info message{/t}</a>
{/if}