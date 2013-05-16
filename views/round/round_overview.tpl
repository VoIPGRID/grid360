{if isset($round)}
    <form action="{$ADMIN_URI}round/end">
        <div class="skip-button"><button class="btn-large btn-inverse">End round</button></div>
    </form>
    <div class="row">
        <span class="span4">
            <table class="table">
                <tr>
                    <td>Round name</td>
                    <td>{$round.description}</td>
                </tr>
                <tr>
                    <td>Date started</td>
                    <td>{$round.created|date_format:"%e-%m-%Y"}</td>
                </tr>
                <tr>
                    <td>Status</td>
                    <td>{if $completed_reviews == $round.ownRoundinfo|@count}Completed{elseif $round.status == 1}In progress{/if}</td>
                </tr>
                <tr>
                    <td>Review count</td>
                    <td>{$completed_reviews} / {$round.ownRoundinfo|@count}</td>
                </tr>
            </table>
        </span>
    </div>
{else}
    <div class="alert alert-info">
        No feedback round currently in progress. You can start a feedback round by clicking the 'Start round' button.
    </div>
    <form action="{$ADMIN_URI}round/create">
        <button class="btn-large btn-inverse pull-right">Start round</button>
    </form>
{/if}


