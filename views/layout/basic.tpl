<!DOCTYPE html>
<html>
<head>
{include file="layout/head.tpl"}
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
{$content}
</div>
</body>
<footer>
</footer>
</html>
