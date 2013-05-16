<script type="text/javascript">
    $('.page-header {$page_title_size}').append(' for {$user.firstname} {$user.lastname} of {$round.description|escape:'html'}');

    averages = new Array();

    {foreach $averages as $competency_id => $average}
        var average = new Array();
        average['id'] = '{$competency_id}';
        average['name'] = '{$average.name|escape:'html'}';
        average['average'] = parseFloat(parseFloat('{$average.average}').toFixed(2)); // parseFloat() twice because toFixed only works on numbers and returns a string, but a float is needed for chart
        average['self'] = parseFloat('{$average.self}');
        average['enabled'] = true;
        averages[{$competency_id}] = average;
    {/foreach}
</script>

<ul class="pager">
    <li class="previous {if $round.id - 1 < 1}disabled{/if}">
        <a href="{if $round.id - 1 < 1}#{else}{$BASE_URI}report/{$round.id - 1}{/if}">&larr; Previous report</a>
    </li>
    <li class="next {if $round.id + 1 > $current_round_id}disabled{/if}">
        <a href="{if $round.id + 1 > $current_round_id}#{else}{$BASE_URI}report/{$round.id + 1}{/if}">Next report &rarr;</a>
    </li>
</ul>
<fieldset>
    <div class="row-fluid">
        <span class="span12">
            <label id="options-label">
                <p class="lead">Options<i class="icon-plus-sign"></i>
                    <small class="muted">(show)</small>
                </p>
            </label>
            <div id="options">
                <strong>Competencies</strong>

                <div id="competency-boxes" class="well">
                    {foreach $averages as $competency_id => $average}
                        <div class="controls">
                            <label class="checkbox">
                                <input type="checkbox" value="{$competency_id}" />{$average.name}
                            </label>
                        </div>
                    {/foreach}
                    <div>
                        <button id="select-all" class="btn btn-link">Select all</button>
                        /
                        <button id="deselect-all" class="btn btn-link">Deselect all</button>
                    </div>
                </div>

                <strong>Graph options</strong>
                <div class="well">
                    <div class="controls">
                        <label class="checkbox">
                            <input type="checkbox" name="check_average" value="1" />Show average
                        </label>
                    </div>
                    <div class="controls">
                        <label class="checkbox">
                            <input type="checkbox" name="check_self" value="2" {if !$has_self}disabled{/if}/>Show self
                        </label>
                    </div>
                    <div class="controls">
                        <label class="checkbox">
                            <input type="checkbox" name="check_comparison" value="4" {if !$has_self}disabled{/if}/>Show comparisons
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
    <legend>Comments</legend>
    <div class="row-fluid">
        <span class="span12">
             <div class="tabbable">
                 <ul class="nav nav-tabs">
                     <li class="active"><a href="#tab-all" data-toggle="tab">All comments</a></li>
                     <li><a href="#tab-answers" data-toggle="tab">Extra question</a></li>
                     {foreach $averages as $competency_id => $average}
                         <li><a href="#tab-{$competency_id}" data-toggle="tab">{$average.name}</a></li>
                     {/foreach}
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
                             <div class="tab-pane fade" id="tab-{$competency_id}">
                                 <table class="table table-striped">
                                     <tbody></tbody>
                                 </table>
                             </div>
                         {/foreach}
                     </div>
                 </div>
             </div>
        </span>
    </div>
</fieldset>

<script type="text/javascript">
    {foreach $reviews as $review}
        {if !empty($review.comment)}
            $('#tab-all').find('tbody').append($('<tr>').append($('<td>').append('{$review.comment|escape:'html'}')));
            $('#tab-{$review.competency.id}').find('tbody').append($('<tr>').append($('<td>').append('{$review.comment|escape:'html'}')));
        {/if}
    {/foreach}

    {foreach $roundinfo as $info}
        {if !empty($info.answer)}
            $('#tab-answers table').find('tbody').append($('<tr>').append($('<td>').append('{$info.answer|escape:'html'}')));
        {/if}
    {/foreach}
</script>

<script type="text/javascript" src="//www.google.com/jsapi"></script>
<script type="text/javascript" src="{$ASSETS_URI}js/report.js"></script>
