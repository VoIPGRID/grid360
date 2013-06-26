<div class="page-header">
    <h1>{t}Round overview{/t}</h1>
</div>
<div class="row-fluid">
<span class="span7">
    {foreach $roundinfo as $info}
        {if $info.reviewee.id == $current_user.id && $info.status == 0}
            <div class="alert alert-info">
                {t}You haven't reviewed yourself yet!{/t} <a href="{$smarty.const.BASE_URI}feedback/{$current_user.id}">{t}Click here to review yourself.{/t}</a>
            </div>
        {break}
        {/if}
    {/foreach}

    {foreach $roundinfo as $info}
        {if $info.reviewee.id != $current_user.id && $info.status == 0}
            <div class="alert alert-info">
                {t}You have pending reviews! Click the review button next to an open review to review that person.{/t}
            </div>
            {break}
        {/if}
    {/foreach}

    {if isset($roundinfo) && !empty($roundinfo)}
        <table class="table table-striped">
            <thead>
            <tr>
                <th>{t}Name reviewee{/t}</th>
                <th>{t}Department{/t}</th>
                <th>{t}Role{/t}</th>
                <th>{t}Status{/t}</th>
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
                                {t}Pending{/t}
                            {else}
                                {t}Completed{/t}
                            {/if}
                        </td>
                        <td>
                            {if $info.status == $smarty.const.REVIEW_IN_PROGRESS}
                                <a href="{$smarty.const.BASE_URI}feedback/{$info.reviewee.id}">{t}Review{/t}</a>
                            {elseif $info.status == $smarty.const.REVIEW_COMPLETED}
                                <a href="{$smarty.const.BASE_URI}feedback/edit/{$info.reviewee.id}">{t}Edit comments{/t}</a>
                            {/if}
                        </td>
                    </tr>
                {/if}
            {/foreach}
            </tbody>
        </table>
    {else}
        {t}No round in progress{/t}
    {/if}
    </span>
</div>
