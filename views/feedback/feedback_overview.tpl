<div class="page-header">
    <h3>{t}Feedback overview{/t}</h3>
</div>

{if !empty($reviews_completed_message)}
    <div id="info-message-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal-header" aria-hidden="true">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
            <h3 id="modal-header">{t}Congratulations{/t}!</h3>
        </div>
        <div class="modal-body">
            <p>{$reviews_completed_message}</p>
        </div>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">{t}Close{/t}</button>
        </div>
    </div>

    <script type="text/javascript">
        $('#info-message-modal').modal('show');
    </script>
{/if}

{if $round.status == $smarty.const.ROUND_IN_PROGRESS}
    {if $own_review.status == $smarty.const.REVIEW_COMPLETED}
        {foreach $roundinfo as $info}
            {if $info.reviewee.id != $current_user.id && $info.status == 0}
                <div class="alert alert-info">
                    {t}You have pending reviews! Click the review button next to an open review to review that person.{/t}
                </div>
                {break}
            {/if}
        {/foreach}
    {/if}

    <div class="row-fluid own-review-row">
        <h4>{t}Review yourself{/t}</h4>
        <table id="own-review-table" class="table table-striped">
            <tbody>
            <tr>
                <td>{$current_user.firstname} {$current_user.lastname}</td>
                <td>
                    {if $info.status == $smarty.const.REVIEW_IN_PROGRESS}
                        {t}Pending{/t}
                    {else}
                        {t}Completed{/t}
                    {/if}
                </td>
                <td>
                    {if !empty($own_review) && $own_review.status == $smarty.const.REVIEW_IN_PROGRESS}
                        <a href="{$smarty.const.BASE_URI}feedback/{$current_user.id}">{t}Review{/t}</a>
                    {else}
                        <a href="{$smarty.const.BASE_URI}feedback/edit/{$current_user.id}">{t}Edit comments{/t}</a>
                    {/if}
                </td>
            </tr>
            </tbody>
        </table>
    </div>

    {if $own_review.status == $smarty.const.REVIEW_COMPLETED}
        <div class="row-fluid">
            <span class="span12">
                <h4>{t}Review status{/t}</h4>
                {if !empty($roundinfo)}
                    <table id="feedback-overview" class="table table-striped">
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
                    <br />
                    {if $own_review.status == $smarty.const.REVIEW_COMPLETED}
                        <div>
                            {if $meeting.id == 0}
                                {t}You have not stated that you do not want to have a meeting with someone.{/t}
                            {else}
                                {t}You stated that you want to have a meeting with{/t} <strong>{$meeting.with.firstname} {$meeting.with.lastname}</strong> {t}about{/t} <strong>{$meeting.subject}</strong>.
                            {/if}
                            <a href="{$smarty.const.BASE_URI}feedback/meeting">{t}Edit meeting{/t}</a>
                        </div>
                    {/if}
                {/if}

                {if isset($skipped_roundinfo)}
                    <fieldset>
                        <legend>{t}Skipped{/t}</legend>
                        <form action="{$smarty.const.BASE_URI}feedback/skip/add" method="post">
                        <table id="skipped-roundinfo" class="table table-striped">
                            <thead>
                            <tr>
                                <th></th>
                                <th>{t}Name reviewee{/t}</th>
                                <th>{t}Department{/t}</th>
                                <th>{t}Role{/t}</th>
                                <th></th>
                            </tr>
                            </thead>
                            <tbody>
                            {foreach $skipped_roundinfo as $skipped}
                                <tr>
                                    <td><input type="checkbox" name="skipped[]" value="{$skipped.reviewee.id}" /></td>
                                    <td>{$skipped.reviewee.firstname} {$skipped.reviewee.lastname}</td>
                                    <td>{$skipped.reviewee.department.name}</td>
                                    <td>{$skipped.reviewee.role.name}</td>
                                    <td><a href="{$smarty.const.BASE_URI}feedback/{$skipped.reviewee.id}">{t}Review{/t}</a></td>
                                </tr>
                            {/foreach}
                            </tbody>
                        </table>
                            <button type="submit" class="btn btn-primary" id="submit">{t}Add to reviewees{/t}</button>
                        </form>
                    </fieldset>
                {/if}
            </span>
        </div>
    {/if}
{else}
    {t}No round in progress{/t}
{/if}

<script type="text/javascript">
    $(document).ready(function()
    {
        // Not using the create_datatable function I made because I want some extra options
        $('#feedback-overview').dataTable({
            "sDom": "",
            "bStateSave": true, // Save the state of the table to localStorage
            "aoColumnDefs": [
                { "bSortable": false, "bSearchable": false, "aTargets": [-1]}
            ],
            oLanguage: get_language_object(),
            "bPaginate": false,
            "bLengthChange": false,
            "bFilter": false,
            "bSort": true,
            "bInfo": false,
            "bAutoWidth": false
        });

        $('#skipped-roundinfo').dataTable({
            "sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
            "bStateSave": true, // Save the state of the table to localStorage
            "aoColumnDefs": [
                { "bSortable": false, "bSearchable": false, "aTargets": [0, -1]}
            ],
            oLanguage: get_language_object(),
            "bPaginate": false,
            "bLengthChange": false,
            "bFilter": false,
            "bSort": true,
            "bInfo": false,
            "bAutoWidth": false
        });
    });
</script>
