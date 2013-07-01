{if isset($round)}
    <form action="{$smarty.const.BASE_URI}{$smarty.const.ADMIN_URI}round/end">
        <div class="skip-button">
            <button class="btn-large btn-inverse">{t}End round{/t}</button>
        </div>
    </form>
    <div class="row">
        <span class="span4">
            <table class="table">
                <tr>
                    <td>{t}Round description{/t}</td>
                    <td>{$round.description}</td>
                </tr>
                <tr>
                    <td>{t}Date started{/t}</td>
                    <td>{$round.created|date_format:"%e-%m-%Y"}</td>
                </tr>
                <tr>
                    <td>Status</td>
                    <td>{if $completed_reviews == $total_reviews}
                            {t}Completed{/t}
                        {elseif $round.status == 1}
                            {t}In progress{/t}
                        {/if}
                    </td>
                </tr>
                <tr>
                    <td>{t}Review count{/t}</td>
                    <td>{$completed_reviews} / {$total_reviews}</td>
                </tr>
            </table>
        </span>
    </div>
{else}
    <div class="alert alert-info">
        {t}No feedback round currently in progress. You can start a feedback round by clicking the 'Start round' button.{/t}
    </div>
    <form action="{$smarty.const.BASE_URI}{$smarty.const.ADMIN_URI}round/create">
        <button class="btn-large btn-inverse pull-right">{t}Start round{/t}</button>
    </form>
{/if}


