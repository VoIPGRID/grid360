<!DOCTYPE html>
<html>
<head>
    {include file="head.tpl"}
</head>
<body>
    {include file="menu.tpl"}

    <div class="container">
        {if isset($pageTitle)}
            <div class="page-header">
                {if isset($pageTitleSize)}
                    <{$pageTitleSize}>{$pageTitle}</{$pageTitleSize}>
                {else}
                    <h1>{$pageTitle}</h1>
                {/if}
            </div>
        {/if}
        {$content}
    </div>
</body>
<footer>
    {include file="footer.tpl"}
</footer>
</html>
