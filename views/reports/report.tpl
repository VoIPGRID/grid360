<script type="text/javascript">
    $('.page-header {$pageTitleSize}').append(' for {$currentUser.firstname} {$currentUser.lastname} of {$round.description|escape:'html'}');
</script>
<fieldset>
    <div class="row-fluid">
        <span class="span12">
            <label id="optionsLabel">
                <p class="lead">Options<i class="icon-plus-sign"></i>
                    <small class="muted">(show)</small>
                </p>
            </label>
            <div id="options">
                <strong>Competencies</strong>

                <div id="competencyBoxes" class="well">
                    {foreach $averages as $key => $average}
                        <div class="controls">
                            <label class="checkbox">
                                <input type="checkbox" name="{$average.name}" value="{$key}" />{$average.name}
                            </label>
                        </div>
                    {/foreach}
                    <div>
                        <button id="selectAll" class="btn btn-link">Select all</button>
                        /
                        <button id="deselectAll" class="btn btn-link">Deselect all</button>
                    </div>
                </div>

                <strong>Graph options</strong>

                <div class="well">
                    <div class="controls">
                        <label class="checkbox">
                            <input type="checkbox" name="checkAverage" value="1" />Show average
                        </label>
                    </div>
                    <div class="controls">
                        <label class="checkbox">
                            <input type="checkbox" name="checkSelf" value="2" />Show self
                        </label>
                    </div>
                    <div class="controls">
                        <label class="checkbox">
                            <input type="checkbox" id="checkComparisons" name="checkComparison" value="4" />Show comparisons
                        </label>
                    </div>
                </div>
            </div>
        </span>
    </div>
</fieldset>

<div class="row-fluid">
    <span class="span12">
         <div id="chart_div" class="reportChart"></div>
    </span>
</div>

<fieldset>
    <legend>Comments</legend>
    <div class="row-fluid">
        <span class="span12">
             <div class="tabbable">
                 <ul class="nav nav-tabs">
                     <li class="active"><a href="#tabAll" data-toggle="tab">All comments</a></li>
                     <li><a href="#tabAnswers" data-toggle="tab">Open question</a></li>
                     {foreach $averages as $key => $average}
                         <li><a href="#tab{$key}" data-toggle="tab">{$average.name}</a></li>
                     {/foreach}
                 </ul>
                 <div class="commentBox">
                     <div class="tab-content">
                         <div class="tab-pane active" id="tabAll">
                             <table class="table table-striped">
                                 <tbody></tbody>
                             </table>
                         </div>
                         <div class="tab-pane" id="tabAnswers">
                             <table class="table table-striped">
                                 <tbody></tbody>
                             </table>
                         </div>
                         {foreach $averages as $key => $average}
                             <div class="tab-pane fade" id="tab{$key}">
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

<script type="text/javascript" src="//www.google.com/jsapi"></script>
<script type="text/javascript">

    {foreach $reviews as $review}
        {if !empty($review.comment)}
            $('#tabAll').find('tbody').append($('<tr>').append($('<td>').append('{$review.comment|escape:'html'}')));
            $('#tab{$review.competency.id}').find('tbody').append($('<tr>').append($('<td>').append('{$review.comment|escape:'html'}')));
        {/if}
    {/foreach}

    {foreach $roundinfo as $info}
        {if !empty($info.answer)}
        $('#tabAnswers table').find('tbody').append($('<tr>').append($('<td>').append('{$info.answer|escape:'html'}')));
        {/if}
    {/foreach}

    {literal}
    google.load('visualization', '1', {packages: ['corechart']});
    function drawChart()
    {
        var showAnimations = true;
        if(!showAnimations)
        {
            chart = new google.visualization.BarChart(document.getElementById('chart_div'));
        }
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Competency name');
        data.addColumn('number', 'Average');
        data.addColumn('number', 'Self');

        for(var i in averages)
        {
            average = averages[i];
            if(average.enabled == 1)
            {
                if(state == 2)
                {
                    data.addRow([average.name, 0, average.self]);
                }
                else if(state == 1)
                {
                    data.addRow([average.name, average.average, null]);
                }
                else if(state == 0)
                {

                }
                else if(state == 4)
                {
                    if(!isNaN(average.self))
                    {
                        data.addRow([average.name, average.average, average.self]);
                    }
                }
                else
                {
                    data.addRow([average.name, average.average, average.self]);
                }
            }
        }
        chart.draw(data, options);
    };
    {/literal}
</script>

<script type="text/javascript">
    $(document).ready()
    {
        var state = 3;
        {literal}
        var options =
        {
            title: 'Average ratings',
            fontSize: 12,
            animation: {
                duration: 500
            },
            vAxis: {title: 'Competenties'},
            hAxis: {
                viewWindowMode: 'explicit',
                viewWindow: {
                    max: 5.1, // Set to 5.1 so the number 5 shows on the chart as well
                    min: 0
                },
                title: 'Punten'
            }
        };

        var chart = new google.visualization.BarChart(document.getElementById('chart_div'));
        {/literal}

        var averages = new Array();

        {foreach $averages as $key => $average}
            var average = new Object();
            average.id = '{$key}';
            average.name = '{$average.name|escape:'html'}';
            average.average = parseFloat(parseFloat('{$average.average}').toFixed(2));
            average.self = parseFloat('{$average.self}');
            average.enabled = 1;
            averages[{$key}] = average;
        {/foreach}

        $('.commentBox').bind('mousewheel DOMMouseScroll', function (e)
        {
            var delta = e.wheelDelta || -e.detail;
            this.scrollTop += ( delta < 0 ? 1 : -1 ) * 30;
        });

        $('.tabbable a').click(function (e)
        {
            e.preventDefault();
            $(this).tab('show');
        });

        $('#selectAll').click(function ()
        {
            $('#competencyBoxes input:checkbox:not(:checked)').click();
            $('#competencyBoxes input:checkbox:not(:checked)').attr('checked', true);
            checkChecked();
        });

        $('#deselectAll').click(function ()
        {
            $('#competencyBoxes input:checked').attr('checked', false);
            checkChecked();
        });

        $('input[name="checkSelf"]').click(function()
        {
            $('input[name="checkComparison"]').attr('checked', false);
        });

        $('input[name="checkAverage"]').click(function()
        {
            $('input[name="checkComparison"]').attr('checked', false);
        });

        $('#optionsLabel').click(function ()
        {
            $('#options').slideToggle();
            if ($('#optionsLabel i').attr('class') == 'icon-minus-sign')
            {
                $('#optionsLabel i').attr('class', 'icon-plus-sign');
                $('#optionsLabel small').text('(show)');
            }
            else
            {
                $('#optionsLabel i').attr('class', 'icon-minus-sign');
                $('#optionsLabel small').text('(hide)');
            }
        });

        function checkChecked()
        {
            state = 0;
            $('input[type="checkbox"]').each(function ()
            {
                if (($(this).attr('name') == 'checkAverage' || $(this).attr('name') == 'checkSelf') || $(this).attr('name') == 'checkComparison')
                {
                    if($(this).attr('name') == 'checkComparison')
                    {
                        if($(this).is(':checked'))
                        {
                            state = 4;
                            $('input[name="checkAverage"]').attr('checked', false);
                            $('input[name="checkSelf"]').attr('checked', false);
                            return;
                        }
                    }
                    if ($(this).is(':checked'))
                        state += parseInt($(this).val());
                }
                else if ($(this).is(':checked'))
                {
                    averages[$(this).val()].enabled = 1;
                }
                else
                {
                    averages[$(this).val()].enabled = 0;
                }
            });

            drawChart();
        }

        $('input[type=checkbox]').not('input[name="checkComparison"]').attr('checked', true);
        $('input[type=checkbox]').on('click', checkChecked);
        drawChart();
    }
</script>
