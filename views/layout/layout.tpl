<!DOCTYPE html>
<html>
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
            {if isset($page_header_subtext)}
                <br /><small>{$page_header_subtext}</small>
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

{$content}
</div>
</body>
<footer>
{include file="layout/footer.tpl"}
</footer>
</html>
