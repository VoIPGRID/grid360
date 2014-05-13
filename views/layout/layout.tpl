<!DOCTYPE html>
<html lang="{$locale}">
<head>
{include file="layout/head.tpl"}
{include file="lib/functions.tpl"}
</head>
<body>

{include file="common/menu.tpl"}

<div class="container">
{include file="layout/page_header.tpl"}

{if !empty($success)}
    {call print_alert type="success" text="{$success}"}
{/if}
{if !empty($error)}
    {call print_alert type="error" text="{$error}"}
{/if}
{if !empty($warning)}
    {call print_alert type="warning" text="{$warning}"}
{/if}
{if !empty($info)}
    {call print_alert type="info" text="{$info}"}
{/if}

{if $display_info_message}
    <div id="info-message-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal-header" aria-hidden="true">
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

    <script type="text/javascript">
        $('#info-message-modal').modal('show');
    </script>
{/if}

{$content nofilter}
</div>
</body>
<footer>
{include file="layout/footer.tpl"}
</footer>
</html>
