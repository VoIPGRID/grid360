{if isset($round)}
    Current round: {$round.description}
    <form action="{$ADMIN_URI}round/end">
        <button class="btn-large btn-inverse pull-right">End round</button>
    </form>
{else}
    <div class="alert alert-info">
        No feedback round currently in progress. You can start a feedback round by clicking the 'Start round' button.
    </div>
    <form action="{$ADMIN_URI}round/create">
        <button class="btn-large btn-inverse pull-right">Start round</button>
    </form>
{/if}


