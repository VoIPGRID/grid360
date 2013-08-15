<h4>{t}Are you sure you want to start a round with the following info?{/t}</h4>
<br />
<form class="form form-horizontal" action="{$smarty.const.BASE_URI}{$smarty.const.ADMIN_URI}round/start" method="post">
    <div class="row-fluid">
        <div class="span4">
            <table class="table">
                <tr>
                    <input type="hidden" name="description" value="{$form_values.description.value}"/>
                    <td>{t}Description{/t}</td>
                    <td>{$form_values.description.value}</td>
                </tr>
                <tr>
                    <input type="hidden" name="total_amount_to_review" value="{$form_values.total_amount_to_review.value}"/>
                    <td>{t}Total amount to review{/t}</td>
                    <td>{$form_values.total_amount_to_review.value|default:{$count_users}}</td>
                </tr>
                <tr>
                    <input type="hidden" name="own_amount_to_review" value="{$form_values.own_amount_to_review.value}"/>
                    <td>{t}Amount to review from own department{/t}</td>
                    <td>{$form_values.own_amount_to_review.value|default:{{$count_users * 0.66}|ceil}}</td>
                </tr>
                <tr>
                    <input type="hidden" name="min_reviewed_by" value="{$form_values.min_reviewed_by.value}"/>
                    <td>{t}Minimum to be reviewed by{/t}</td>
                    <td>{$form_values.min_reviewed_by.value|default:{{$count_users * 0.50}|ceil}}</td>
                </tr>
                <tr>
                    <input type="hidden" name="min_to_review" value="{$form_values.min_to_review.value}"/>
                    <td>{t}Minimum to review{/t}</td>
                    <td>{$form_values.min_to_review.value|default:{{$count_users * 0.50}|ceil}}</td>
                </tr>
            </table>
        </div>
    </div>

    <div class="form-actions">
        <button type="button" class="btn" onclick="history.go(-1);return true;">{t}Cancel{/t}</button>
        <button type="submit" class="btn btn-primary">{t}Start round{/t}</button>
    </div>
</form>
