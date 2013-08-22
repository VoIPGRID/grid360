{include file="lib/functions.tpl"}

{function print_user_info}
    <tr>
        <td>{$user.firstname|capitalize:true}</td>
        <td>{$user.lastname}</td>
        <td>{$user.email}</td>
        <td>{$user.department.name|capitalize:true}</td>
        <td>{$user.role.name|capitalize:true}</td>
        <td><ul><li>{$user.role.competencygroup.name|capitalize:true}</li><li>{$general_competencies}</li></ul></td>
        <td>
            {if $user.status == 0}
                {t}No{/t}
            {elseif $user.status == 1}
                {t}Yes{/t}
            {/if}
        </td>
        {call print_actions type="user" level="admin"}
    </tr>
{/function}

{if !empty($users)}
    <table class="table table-striped">
        <thead>
        <tr>
            <th>{t}First name{/t}</th>
            <th>{t}Last name{/t}</th>
            <th>{t}Email{/t}</th>
            <th>{t}Department{/t}</th>
            <th>{t}Role{/t}</th>
            <th>{t}Competency groups{/t}</th>
            <th>
                {t}Included? {/t}
                <span>
                    <i class="icon-question-sign" data-toggle="tooltip" title="{t}This column shows if a person is included in the feedback round.{/t}" data-placement="right"></i>
                </span>
            </th>
            <th>{t}Actions{/t}</th>
        </tr>
        </thead>
        <tbody>
        {foreach $users as $user}
            {print_user_info}
        {/foreach}
        </tbody>
    </table>
{else}
    {t}No users found!{/t}
{/if}

<br />

{if isset($round)}
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
                <tr>
                    <td>{t}Minimum to be reviewed by{/t}</td>
                    <td>{$round.min_reviewed_by}</td>
                </tr>
                <tr>
                    <td>{t}Minimum to review{/t}</td>
                    <td>{$round.min_to_review}</td>
                </tr>
            </table>
        </span>
        <span class="span6">
            <a href="{$smarty.const.BASE_URI}{$smarty.const.ADMIN_URI}round/end" class="btn btn-large btn-inverse">{t}End round{/t}</a>
        </span>
    </div>
{else}
    <div class="alert alert-info">
        {t}No feedback round currently in progress. You can start a feedback round by clicking the 'Start round' button.{/t}
    </div>
    <a href="{$smarty.const.BASE_URI}{$smarty.const.ADMIN_URI}round/create" class="btn btn-large btn-inverse pull-right">{t}Start round{/t}</a>
{/if}

<script type="text/javascript">
    $(document).ready(function()
    {
        var ignored_columns = [-1, -2]; // Stop the reports and actions columns from being sortable
        create_datatable($('.table.table-striped'), ignored_columns);
    });
</script>


