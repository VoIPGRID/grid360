<!DOCTYPE html>
<html>
<head>
{include file="layout/head.tpl"}
</head>
<body>
{include file="common/menu.tpl"}
<div class="container">
{if isset($page_title)}
    <div class="page-header">
    {if isset($page_title_size)}
        <{$page_title_size}>{$page_title}</{$page_title_size}>
    {else}
        <h1>{$page_title}</h1>
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
