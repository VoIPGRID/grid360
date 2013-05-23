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
    {if isset($page_header_size)}
        <{$page_header_size}>{$page_header}</{$page_header_size}>
    {else}
        <h1>{$page_header}</h1>
    {/if}
</div>
{/if}
{$content}
</div>
</body>
<footer>
{include file="layout/footer.tpl"}
</footer>
</html>
