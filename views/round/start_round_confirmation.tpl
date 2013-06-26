<h4>{t}Are you sure you want to start a round with the following info?{/t}</h4>
<br />
<form class="form form-horizontal" action="{$smarty.const.ADMIN_URI}round/start" method="post">
    <div class="row-fluid">
        <div class="span4">
            <table class="table">
                <tr>
                    <input type="hidden" name="description" value="{$values.description}"/>
                    <td>{t}Description{/t}</td>
                    <td>{$values.description}</td>
                </tr>
                <tr>
                    <input type="hidden" name="min_own" value="{$values.min_own}"/>
                    <td>Min. own department</td>
                    <td>{$values.min_own|default:50}%</td>
                </tr>
                <tr>
                    <input type="hidden" name="max_own" value="{$values.max_own}"/>
                    <td>Max. own department</td>
                    <td>{$values.max_own|default:100}%</td>
                </tr>
                <tr>
                    <input type="hidden" name="min_other" value="{$values.min_other}"/>
                    <td>Min. other department</td>
                    <td>{$values.min_other|default:25}%</td>
                </tr>
                <tr>
                    <input type="hidden" name="max_other" value="{$values.max_other}"/>
                    <td>Max. other department</td>
                    <td>{$values.max_other|default:50}%</td>
                </tr>
            </table>
        </div>
    </div>

    <div class="form-actions">
        <button type="button" class="btn" onclick="history.go(-1);return true;">{t}Cancel{/t}</button>
        <button type="submit" class="btn btn-primary">{t}Start round{/t}</button>
    </div>
</form>
