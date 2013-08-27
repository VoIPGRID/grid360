<!DOCTYPE html>
<html>
<head>
    {include file="layout/head.tpl"}
    {include file="lib/functions.tpl"}
</head>
<body>
<div class="container login">
    {if isset($page_header)}
        {if isset($page_header_size)}
            <{$page_header_size}>{$page_header}</{$page_header_size}>
        {else}
            <h1>{$page_header}</h1>
        {/if}
    {/if}

{if !empty($success)}
    {call print_alert type="success" text="{$success}"}
{/if}
{if !empty($error)}
    {call print_alert type="error" text="{$error}"}
{/if}

{$content nofilter}
</div>
</body>
<footer>
</footer>
</html>
