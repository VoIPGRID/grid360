<div class="page-header">
    <h3>{t}Meeting overview{/t}</h3>
    <small class="muted">{t}Click a round to view the meetings for that round{/t}</small>
</div>

<div class="row-fluid">
    {foreach $rounds as $round}
        <a href="{$smarty.const.BASE_URI}{$smarty.const.ADMIN_URI}meetings/{$round.id}">{$round.description}</a><br />
    {/foreach}
</div>