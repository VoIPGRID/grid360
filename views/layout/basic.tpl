<!DOCTYPE html>
<html>
<head>
{include file="layout/head.tpl"}
</head>
<body>
<div class="container login">
    {if isset($page_title)}
            {if isset($page_title_size)}
            <{$page_title_size}>{$page_title}</{$page_title_size}>
    {else}
        <h1>{$page_title}</h1>
    {/if}
{/if}
{$content}
</div>
</body>
<footer>
</footer>
</html>
