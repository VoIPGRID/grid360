<script type="text/javascript">
    $('.page-header {$page_title_size}').append(' for {$current_user.firstname} {$current_user.lastname} of {$round.description|escape:'html'}');

    averages = new Array();

    {foreach $averages as $key => $average}
        var average = new Array();
        average['id'] = '{$key}';
        average['name'] = '{$average.name|escape:'html'}';
        average['average'] = parseFloat(parseFloat('{$average.average}').toFixed(2));
        average['self'] = parseFloat('{$average.self}');
        average['enabled'] = true;
        averages[{$key}] = average;
    {/foreach}
</script>

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
                    {foreach $averages as $key => $average}
                        <div class="controls">
                            <label class="checkbox">
                                <input type="checkbox" value="{$key}" />{$average.name}
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
                     {foreach $averages as $key => $average}
                         <li><a href="#tab-{$key}" data-toggle="tab">{$average.name}</a></li>
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
                         {foreach $averages as $key => $average}
                             <div class="tab-pane fade" id="tab-{$key}">
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
