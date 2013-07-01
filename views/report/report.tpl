<script type="text/javascript" src="{$smarty.const.ASSETS_URI}js/bootstrap-tabdrop.js"></script>

<ul class="pager">
    <li class="previous {if $previous_round.id == 0 || $round.id - 1 < 1}disabled{/if}">
        <a href="{if $previous_round.id == 0 || $round.id - 1 < 1}#{else}{$smarty.const.BASE_URI}report/{$round.id - 1}{if $user.id != $current_user.id}/{$user.id}{/if}{/if}">&larr; {t}Previous report{/t}</a>
    </li>
    <li class="next {if $round.id + 1 > $current_round_id}disabled{/if}">
        <a href="{if $round.id + 1 > $current_round_id}#{else}{$smarty.const.BASE_URI}report/{$round.id + 1}{if $user.id != $current_user.id}/{$user.id}{/if}{/if}">{t}Next report{/t} &rarr;</a>
    </li>
</ul>
{if !empty($averages)}
    <fieldset>
        <div class="row-fluid">
        <span class="span12">
            <label id="options-label">
                <p class="lead">{t}Options{/t}<i class="icon-plus-sign"></i>
                    <small class="muted">({t}show{/t})</small>
                </p>
            </label>
            <div id="options">
                <strong>{t}Competencies{/t}</strong>

                <div id="competency-boxes" class="well">
                    {foreach $averages as $competency_id => $average}
                        <div class="controls">
                            <label class="checkbox">
                                <input type="checkbox" value="{$competency_id}"/>{$average.name}
                            </label>
                        </div>
                    {/foreach}
                    <div>
                        <button id="select-all" class="btn btn-link">{t}Select all{/t}</button>
                        /
                        <button id="deselect-all" class="btn btn-link">{t}Deselect all{/t}</button>
                    </div>
                </div>

                <strong>{t}Ratings{/t}</strong>

                <div class="well">
                    <div class="controls">
                        <label class="checkbox">
                            <input type="checkbox" name="check_average" value="1"/>{t}Show average{/t}
                        </label>
                    </div>
                    <div class="controls">
                        <label class="checkbox">
                            <input type="checkbox" name="check_own" value="2" {if !$has_own_ratings}disabled{/if}/>{t}Show own{/t}
                        </label>
                    </div>
                    <div class="controls">
                        <label class="checkbox">
                            <input type="checkbox" name="check_comparison" value="4" {if !$has_own_ratings}disabled{/if}/>{t}Show comparisons{/t}
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
    <div class="row-fluid">
        <span class="span6">
             <div id="positive-chart-div" class="report-chart"></div>
        </span>
        <span class="span6">
             <div id="negative-chart-div" class="report-chart"></div>
        </span>
    </div>
    <fieldset>
        <legend>{t}Comments{/t}</legend>
        <div class="row-fluid">
        <span class="span12">
            <div class="tabbable">
                <ul class="nav nav-tabs">
                    <li class="active"><a href="#tab-all" data-toggle="tab">{t}All comments{/t}</a></li>
                    {foreach $averages as $competency_id => $average}
                        {if array_key_exists($competency_id, $comment_counts)}
                            <li><a href="#tab-{$competency_id}" data-toggle="tab">{$average.name}</a></li>
                        {/if}
                    {/foreach}
                    <li><a href="#tab-answers" data-toggle="tab">{t}Extra question{/t}</a></li>
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

        positive_averages = new Array();

        {foreach $positive_averages as $competency_id => $average}
            var average = new Array();
            average['id'] = '{$competency_id}';
            average['name'] = '{$average.name|escape:'quotes'}';
            // parseFloat() twice because toFixed only works on numbers and returns a string, but a float is needed for the chart
            average['average'] = parseFloat(parseFloat('{$average.average}').toFixed(2));
            average['count_reviews'] = parseInt('{$average.count_reviews}');
            average['own_rating'] = parseFloat('{$average.own_rating}');
            average['enabled'] = true;
            positive_averages[{$competency_id}] = average;
        {/foreach}

        negative_averages = new Array();

        {foreach $negative_averages as $competency_id => $average}
            var average = new Array();
            average['id'] = '{$competency_id}';
            average['name'] = '{$average.name|escape:'quotes'}';
            // parseFloat() twice because toFixed only works on numbers and returns a string, but a float is needed for the chart
            average['average'] = parseFloat(parseFloat('{$average.average}').toFixed(2));
            average['count_reviews'] = parseInt('{$average.count_reviews}');
            average['own_rating'] = parseFloat('{$average.own_rating}');
            average['enabled'] = true;
            negative_averages[{$competency_id}] = average;
        {/foreach}

        {foreach $reviews as $review}
            {if !empty($review.comment)}
                var own_text = '';
                {if $review.reviewer.id == $smarty.session.current_user.id}
                    own_text = '<strong>[{t}Own{/t}]</strong>';
                {/if}

                $('#tab-all').find('tbody').append($('<tr>').append($('<td>').append(own_text + '[{$review.competency.name}]' + ' {$review.comment|escape:'quotes'}')));
                $('#tab-{$review.competency.id}').find('tbody').append($('<tr>').append($('<td>').append(own_text + ' {$review.comment|escape:'quotes'}')));
            {/if}
        {/foreach}

        {foreach $roundinfo as $info}
            {if !empty($info.answer)}
            var own_text = '';
            {if $info.reviewer.id == $smarty.session.current_user.id}
                own_text = '<strong>[{t}Own{/t}]</strong>';
            {/if}
                $('#tab-answers table').find('tbody').append($('<tr>').append($('<td>').append(own_text + ' {$info.answer|escape:'quotes'}')));
            {/if}
        {/foreach}

        text_show = '{t}show{/t}';
        text_hide = '{t}hide{/t}';
        graph_header = '{t}Ratings{/t}';
        graph_text_average = '{t}Average{/t}';
        graph_text_own = '{t}Own{/t}';
        graph_text_competencies = '{t}Competencies{/t}';
        graph_text_points = '{t}Points{/t}';
        graph_text_tooltip_single = '{t}review{/t}';
        graph_text_tooltip = '{t}reviews{/t}';
        $('.nav-pills, .nav-tabs').tabdrop();
    </script>
    <script type="text/javascript" src="//www.google.com/jsapi"></script>
    <script type="text/javascript" src="{$smarty.const.ASSETS_URI}js/report.js"></script>
{else}
    {t}No reviews found for this round{/t}
{/if}
