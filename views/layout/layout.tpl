<!DOCTYPE html>
<html>
<head>
{include file="layout/head.tpl"}
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

{if isset($smarty.get.success)}
    {call show_alert type="success" text="{$smarty.get.success}"}
{elseif isset($smarty.get.error)}
    {call show_alert type="error" text="{$smarty.get.error}"}
{/if}

{$content}
</div>
</body>
<footer>
{include file="layout/footer.tpl"}
</footer>
</html>
