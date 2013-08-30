<form action="{$smarty.const.BASE_URI}{$smarty.const.ADMIN_URI}infomessage/create" method="post" class="form-horizontal" data-persist="garlic">
    {if !empty($info_message)}
        <legend>{t}Updating info message{/t}</legend>
    {else}
        <legend>{t}Creating info message{/t}</legend>
    {/if}

    <button id="info-box-button" class="btn btn-link">+ {t}Show info{/t}</button>
    <div id="field-info" class="alert alert-info">
        {t}This text area can be used to setup an info message. This info message will be shown the first time somebody logs in and can be used to display any information you would like to show to your employees.{/t}
        <br />
        <br />
        <strong>{t}Note:{/t} </strong>{t}Unlike the rest of the application, most HTML that you use in this text area does not get escaped or removed. Only JavaScript, and external links and resources will be removed.{/t}
    </div>

    <br />

    <textarea name="info_message" class="input-block-level" id="info-message" rows="30">{$info_message.message}</textarea>

    <div class="form-actions">
        <a href="{$smarty.const.BASE_URI}{$smarty.const.ADMIN_URI}infomessage/overview" class="btn">{t}Cancel{/t}</a>
        <button type="submit" class="btn btn-primary">
            {if !empty($info_message)}
                {t}Update info message{/t}
            {else}
                {t}Create info message{/t}
            {/if}
        </button>
    </div>
</form>

<script type="text/javascript">
    $(document).ready(function()
    {
        $('#info-box-button').click(function(event)
        {
            if($('#field-info').is(':visible'))
            {
                $(this).text('+ {t}Show info{/t}');
            }
            else
            {
                $(this).text('- {t}Hide info{/t}');
            }

            $('#field-info').slideToggle();
            event.preventDefault();
        });
    });
</script>