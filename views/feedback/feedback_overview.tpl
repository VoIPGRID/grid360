{if isset($smarty.get.success)}
    <div class="alert alert-success">
        <button type="button" class="close" data-dismiss="alert">&times;</button>
        {$smarty.get.success}
    </div>
{/if}

<div class="page-header"><h1>{$smarty.const.FEEDBACK_OVERVIEW_HEADER}</h1></div>
<div class="row-fluid">
<span class="span7">
    {foreach $roundinfo as $info}
        {if $info.reviewee.id == $current_user.id && $info.status == 0}
            <div class="alert alert-info">
                {$smarty.const.FEEDBACK_INFO_SELF} <a href="{$smarty.const.BASE_URI}feedback/{$current_user.id}">{$smarty.const.FEEDBACK_INFO_SELF_BUTTON}</a>
            </div>
            {break}
        {/if}
    {/foreach}

    {foreach $roundinfo as $info}
        {if $info.reviewee.id != $current_user.id && $info.status == 0}
            <div class="alert alert-info">
                {$smarty.const.FEEDBACK_INFO_PENDING}
            </div>
            {break}
        {/if}
    {/foreach}

    {if isset($roundinfo) && !empty($roundinfo)}
        <table class="table table-striped">
            <thead>
            <tr>
                <th>{$smarty.const.FEEDBACK_REVIEWEE_NAME}</th>
                <th>{$smarty.const.TH_DEPARTMENT}</th>
                <th>{$smarty.const.TH_ROLE}</th>
                <th>Status</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            {foreach $roundinfo as $info}
                {if $info.reviewee.id != $current_user.id && $info.status != 2}
                    <tr>
                        <td>{$info.reviewee.firstname} {$info.reviewee.lastname}</td>
                        <td>{$info.reviewee.department.name}</td>
                        <td>{$info.reviewee.role.name}</td>
                        <td>
                            {if $info.status == $smarty.const.REVIEW_IN_PROGRESS}
                                {$smarty.const.TEXT_PENDING}
                            {else}
                                {$smarty.const.TEXT_COMPLETED}
                            {/if}
                        </td>
                        <td>
                            {if $info.status == $smarty.const.REVIEW_IN_PROGRESS}
                                <a href="{$smarty.const.BASE_URI}feedback/{$info.reviewee.id}">{$smarty.const.FEEDBACK_REVIEW_BUTTON}</a>
                            {elseif $info.status == $smarty.const.REVIEW_COMPLETED}
                                <a href="{$smarty.const.BASE_URI}feedback/edit/{$info.reviewee.id}">{$smarty.const.FEEDBACK_OVERVIEW_EDIT}</a>
                            {/if}
                        </td>
                    </tr>
                {/if}
            {/foreach}
            </tbody>
        </table>
    {else}
        {$smarty.const.FEEDBACK_OVERVIEW_NO_ROUND}
    {/if}
    </span>
</div>
