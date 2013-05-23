<h4>Are you sure you want to start a round with the following info?</h4>
<br />
<form class="form form-horizontal" action="{$smarty.const.ADMIN_URI}round/start" method="post">
    <div class="row-fluid">
        <div class="span4">
            <table class="table">
                <tr>
                    <input type="hidden" name="description" value="{$values.description}"/>
                    <td>Description</td>
                    <td>{$values.description}</td>
                </tr>
                <tr>
                    <input type="hidden" name="min_own" value="{$values.min_own}"/>
                    <td>Min. own department</td>
                    <td>{if !empty({$values.min_own})}{$values.min_own}%{else}50%{/if}</td>
                </tr>
                <tr>
                    <input type="hidden" name="max_own" value="{$values.max_own}"/>
                    <td>Max. own department</td>
                    <td>{if !empty({$values.max_own})}{$values.max_own}%{else}100%{/if}</td>
                </tr>
                <tr>
                    <input type="hidden" name="min_other" value="{$values.min_other}"/>
                    <td>Min. other department</td>
                    <td>{if !empty({$values.min_other})}{$values.min_other}%{else}25%{/if}</td>
                </tr>
                <tr>
                    <input type="hidden" name="max_other" value="{$values.max_other}"/>
                    <td>Max. other department</td>
                    <td>{if !empty({$values.max_other})}{$values.max_other}%{else}50%{/if}</td>
                </tr>
            </table>
        </div>
    </div>

    <div class="form-actions">
        <button type="button" class="btn" onclick="history.go(-1);return true;">Cancel</button>
        <button type="submit" class="btn btn-primary">Start round</button>
    </div>
</form>
