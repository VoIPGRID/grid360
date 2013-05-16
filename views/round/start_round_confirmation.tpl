<h4>Are you sure you want to start a round with the following info?</h4>
<br />
<form class="form form-horizontal" action="{$ADMIN_URI}round/start" method="post">
    <div class="row-fluid">
        <div class="span4">
            <table class="table">
                <tr>
                    <input type="hidden" name="description" value="{$description}"/>
                    <td>Description</td>
                    <td>{$description}</td>
                </tr>
                <tr>
                    <input type="hidden" name="min_own" value="{$min_own}"/>
                    <td>Min. own department</td>
                    <td>{if !empty({$min_own})}{$min_own}%{else}50%{/if}</td>
                </tr>
                <tr>
                    <input type="hidden" name="max_own" value="{$max_own}"/>
                    <td>Max. own department</td>
                    <td>{if !empty({$max_own})}{$max_own}%{else}100%{/if}</td>
                </tr>
                <tr>
                    <input type="hidden" name="min_other" value="{$min_other}"/>
                    <td>Min. other department</td>
                    <td>{if !empty({$min_other})}{$min_other}%{else}25%{/if}</td>
                </tr>
                <tr>
                    <input type="hidden" name="max_other" value="{$max_other}"/>
                    <td>Max. other department</td>
                    <td>{if !empty({$max_other})}{$max_other}%{else}50%{/if}</td>
                </tr>
            </table>
        </div>
    </div>

    <div class="form-actions">
        <button type="button" class="btn" onclick="history.go(-1);return true;">Cancel</button>
        <button type="submit" class="btn btn-primary">Start round</button>
    </div>
</form>
