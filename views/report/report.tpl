<ul class="pager">
    <li class="previous {if $previous_round.id == 0 || $round.id - 1 < 1}disabled{/if}">
        <a href="{if $previous_round.id == 0 || $round.id - 1 < 1}#{else}{$smarty.const.BASE_URI}report/{$round.id - 1}{if $user.id != $current_user.id}/{$user.id}{/if}{/if}">&larr; {$smarty.const.REPORT_PREVIOUS}</a>
    </li>
    <li class="next {if $round.id + 1 > $current_round_id}disabled{/if}">
        <a href="{if $round.id + 1 > $current_round_id}#{else}{$smarty.const.BASE_URI}report/{$round.id + 1}{if $user.id != $current_user.id}/{$user.id}{/if}{/if}">{$smarty.const.REPORT_NEXT} &rarr;</a>
    </li>
</ul>
{if !empty($averages)}
    <fieldset>
        <div class="row-fluid">
        <span class="span12">
            <label id="options-label">
                <p class="lead">{$smarty.const.REPORT_OPTIONS_HEADER}<i class="icon-plus-sign"></i>
                    <small class="muted">({$smarty.const.REPORT_SHOW_OPTIONS})</small>
                </p>
            </label>
            <div id="options">
                <strong>{$smarty.const.REPORT_OPTIONS_COMPETENCIES_HEADER}</strong>

                <div id="competency-boxes" class="well">
                    {foreach $averages as $competency_id => $average}
                        <div class="controls">
                            <label class="checkbox">
                                <input type="checkbox" value="{$competency_id}"/>{$average.name}
                            </label>
                        </div>
                    {/foreach}
                    <div>
                        <button id="select-all" class="btn btn-link">{$smarty.const.REPORT_OPTIONS_SELECT_ALL}</button>
                        /
                        <button id="deselect-all" class="btn btn-link">{$smarty.const.REPORT_OPTIONS_DESELECT_ALL}</button>
                    </div>
                </div>

                <strong>{$smarty.const.REPORT_OPTIONS_RATINGS_HEADER}</strong>

                <div class="well">
                    <div class="controls">
                        <label class="checkbox">
                            <input type="checkbox" name="check_average" value="1"/>{$smarty.const.REPORT_OPTIONS_SHOW_AVERAGE}
                        </label>
                    </div>
                    <div class="controls">
                        <label class="checkbox">
                            <input type="checkbox" name="check_own" value="2" {if !$has_own_ratings}disabled{/if}/>{$smarty.const.REPORT_OPTIONS_SHOW_OWN}
                        </label>
                    </div>
                    <div class="controls">
                        <label class="checkbox">
                            <input type="checkbox" name="check_comparison" value="4" {if !$has_own_ratings}disabled{/if}/>{$smarty.const.REPORT_OPTIONS_SHOW_COMPARISONS}
                        </label>
                    </div>
                </div>
            </div>
        </span>
        </div>
    </fieldset>
    <div class="row-fluid">
    <span class="span12">
         <div id="chart-div" class="report-chart"></div>
    </span>
    </div>
    <fieldset>
        <legend>{$smarty.const.TEXT_COMMENTS}</legend>
        <div class="row-fluid">
        <span class="span12">
            <div class="tabbable">
                <ul class="nav nav-tabs">
                    <li class="active"><a href="#tab-all" data-toggle="tab">{$smarty.const.REPORT_ALL_COMMENTS}</a></li>
                    {foreach $averages as $competency_id => $average}
                        {if array_key_exists($competency_id, $comment_counts)}
                            <li><a href="#tab-{$competency_id}" data-toggle="tab">{$average.name}</a></li>
                        {/if}
                    {/foreach}
                    <li><a href="#tab-answers" data-toggle="tab">{$smarty.const.REPORT_EXTRA_QUESTION}</a></li>
                </ul>
                <div class="comment-box">
                    <div class="tab-content">
                        <div class="tab-pane active" id="tab-all">
                            <table class="table table-striped">
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="tab-pane" id="tab-answers">
                            <table class="table table-striped">
                                <tbody></tbody>
                            </table>
                        </div>
                        {foreach $averages as $competency_id => $average}
                            {if array_key_exists($competency_id, $comment_counts)}
                                <div class="tab-pane fade" id="tab-{$competency_id}">
                                    <table class="table table-striped">
                                        <tbody></tbody>
                                    </table>
                                </div>
                            {/if}
                        {/foreach}
                    </div>
                </div>
            </div>
        </span>
        </div>
    </fieldset>
    <script type="text/javascript">
        averages = new Array();

        {foreach $averages as $competency_id => $average}
            var average = new Array();
            average['id'] = '{$competency_id}';
            average['name'] = '{$average.name|escape:'quotes'}';
            // parseFloat() twice because toFixed only works on numbers and returns a string, but a float is needed for the chart
            average['average'] = parseFloat(parseFloat('{$average.average}').toFixed(2));
            average['count_reviews'] = parseInt('{$average.count_reviews}');
            average['own_rating'] = parseFloat('{$average.own_rating}');
            average['enabled'] = true;
            averages[{$competency_id}] = average;
        {/foreach}

        {foreach $reviews as $review}
            {if !empty($review.comment)}
                var own_text = '';
                {if $review.reviewer.id == $smarty.session.current_user.id}
                    own_text = '<strong>[{$smarty.const.REPORT_GRAPH_OWN}]</strong>';
                {/if}

                $('#tab-all').find('tbody').append($('<tr>').append($('<td>').append(own_text + '[{$review.competency.name}]' + ' {$review.comment|escape:'quotes'}')));
                $('#tab-{$review.competency.id}').find('tbody').append($('<tr>').append($('<td>').append(own_text + ' {$review.comment|escape:'quotes'}')));
            {/if}
        {/foreach}

        {foreach $roundinfo as $info}
            {if !empty($info.answer)}
            var own_text = '';
            {if $info.reviewer.id == $smarty.session.current_user.id}
                own_text = '<strong>[{$smarty.const.REPORT_GRAPH_OWN}]</strong>';
            {/if}
                $('#tab-answers table').find('tbody').append($('<tr>').append($('<td>').append(own_text + ' {$info.answer|escape:'quotes'}')));
            {/if}
        {/foreach}

        text_show = '{$smarty.const.REPORT_SHOW_OPTIONS}';
        text_hide = '{$smarty.const.REPORT_HIDE_OPTIONS}';
        graph_header = '{$smarty.const.REPORT_GRAPH_HEADER}';
        graph_text_average = '{$smarty.const.REPORT_GRAPH_AVERAGE}';
        graph_text_own = '{$smarty.const.REPORT_GRAPH_OWN}';
        graph_text_competencies = '{$smarty.const.TEXT_COMPETENCIES}';
        graph_text_points = '{$smarty.const.REPORT_GRAPH_POINTS}';
        graph_text_tooltip_single = '{$smarty.const.REPORT_GRAPH_REVIEW_TEXT_SINGLE}';
        graph_text_tooltip = '{$smarty.const.REPORT_GRAPH_REVIEW_TEXT}';
        $('.nav-pills, .nav-tabs').tabdrop();
    </script>
    <script type="text/javascript" src="//www.google.com/jsapi"></script>
    <script type="text/javascript" src="{$smarty.const.ASSETS_URI}js/report.js"></script>
{else}
    {$smarty.const.REPORT_NO_REVIEWS}
{/if}
