<!DOCTYPE html>
<html lang="{$locale}">
<head>
{include file="layout/head.tpl"}
{include file="lib/functions.tpl"}
</head>
<body>

{include file="common/menu.tpl"}

<div class="container">
{if isset($page_header)}
    <div class="page-header">
        <{$page_header_size|default:'h1'}>
            {$page_header|ucfirst}
            {if isset($page_subheader)}
                <br /><small>{$page_subheader}</small>
            {/if}
        </{$page_header_size|default:'h1'}>
    </div>
{/if}

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

{$content nofilter}
</div>
</body>
<footer>
{include file="layout/footer.tpl"}
</footer>
</html>
