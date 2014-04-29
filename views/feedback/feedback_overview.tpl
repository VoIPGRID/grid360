<div class="page-header">
    <h3>{t}Round overview{/t}</h3>
</div>
<div class="row-fluid">
    <span class="span12">
        {foreach $roundinfo as $info}
            {if $info.reviewee.id != $current_user.id && $info.status == 0}
                <div class="alert alert-info">
                    {t}You have pending reviews! Click the review button next to an open review to review that person.{/t}
                </div>
                {break}
            {/if}
        {/foreach}

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
            {if $own_review.status == $smarty.const.REVIEW_COMPLETED}
                <div>
                    {if $meeting.id == 0}
                        {t}You have not stated that you do not want to have a meeting with someone.{/t}
                    {else}
                        {t}You stated that you want to have a meeting with{/t} <strong>{$meeting.manager.firstname} {$meeting.manager.lastname}</strong> {t}about{/t} <strong>{$meeting.subject}</strong>.
                    {/if}
                    <a href="{$smarty.const.BASE_URI}feedback/meeting">{t}Edit meeting{/t}</a>
                </div>
            {/if}
        {else}
            {t}No round in progress{/t}
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

<script type="text/javascript">
    $(document).ready(function()
    {
        $('#info-box-button').click(function(event)
        {
            if($('#field-info').is(':visible'))
            {
                $(this).find('h4').text('+ {t}Click here for more information about this feedback round{/t}');
            }
            else
            {
                $(this).find('h4').text('- {t}Click to hide{/t}');
            }

            $('#field-info').slideToggle();
            event.preventDefault();
        });

        // Not using the create_datatable function I made because I want some extra options

        $('#feedback-overview').dataTable({
            "sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
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
