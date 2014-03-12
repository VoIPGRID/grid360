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
