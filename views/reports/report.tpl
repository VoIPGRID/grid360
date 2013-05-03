<script type="text/javascript">
    $('.page-header {$page_title_size}').append(' for {$current_user.firstname} {$current_user.lastname} of {$round.description|escape:'html'}');
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
                                <input type="checkbox" name="{$average.name}" value="{$key}" />{$average.name}
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

<script type="text/javascript" src="//www.google.com/jsapi"></script>
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

    {literal}
    google.load('visualization', '1', {packages: ['corechart']});
    function draw_chart()
    {
//        var show_animations = true;
//        if(!show_animations)
//        {
//            chart = new google.visualization.BarChart(document.getElementById('chart-div'));
//        }
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
                    if(!isNaN(average.self))
                    {
                        data.addRow([average.name, null, average.self]);
                    }
                }
                else if(state == 1)
                {
                    if(!isNaN(average.average))
                    {
                        data.addRow([average.name, average.average, null]);
                    }
                }
                else if(state == 4)
                {
                    if(!isNaN(average.self) && !isNaN(average.average))
                    {
                        data.addRow([average.name, average.average, average.self]);
                    }
                }
                else if(state == 0)
                {

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

        var chart = new google.visualization.BarChart(document.getElementById('chart-div'));
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

        $('.comment-box').bind('mousewheel DOMMouseScroll', function (e)
        {
            var delta = e.wheelDelta || -e.detail;
            this.scrollTop += ( delta < 0 ? 1 : -1 ) * 30;
        });

        $('.tabbable a').click(function (e)
        {
            e.preventDefault();
            $(this).tab('show');
        });

        $('#select-all').click(function ()
        {
            $('#competency-boxes input:checkbox:not(:checked)').click();
            $('#competency-boxes input:checkbox:not(:checked)').attr('checked', true);
            check_checked();
        });

        $('#deselect-all').click(function ()
        {
            $('#competency-boxes input:checked').attr('checked', false);
            check_checked();
        });

        $('input[name="check_self"]').click(function()
        {
            $('input[name="check_comparison"]').attr('checked', false);
        });

        $('input[name="check_average"]').click(function()
        {
            $('input[name="check_comparison"]').attr('checked', false);
        });

        $('#options-label').click(function ()
        {
            $('#options').slideToggle();
            if ($('#options-label i').attr('class') == 'icon-minus-sign')
            {
                $('#options-label i').attr('class', 'icon-plus-sign');
                $('#options-label small').text('(show)');
            }
            else
            {
                $('#options-label i').attr('class', 'icon-minus-sign');
                $('#options-label small').text('(hide)');
            }
        });

        function check_checked()
        {
            state = 0;
            $('input[type="checkbox"]').each(function()
            {
                if(($(this).attr('name') == 'check_average' || $(this).attr('name') == 'check_self') || $(this).attr('name') == 'check_comparison')
                {
                    if($(this).attr('name') == 'check_comparison')
                    {
                        if($(this).is(':checked'))
                        {
                            state = 4;
                            $('input[name="check_average"]').attr('checked', false);
                            $('input[name="check_self"]').attr('checked', false);
                            return;
                        }
                    }
                    if($(this).is(':checked'))
                        state += parseInt($(this).val());
                }
                else if($(this).is(':checked'))
                {
                    averages[$(this).val()].enabled = 1;
                }
                else
                {
                    averages[$(this).val()].enabled = 0;
                }
            });

            draw_chart();
        }

        $('input[type=checkbox]').not('input[name="check_comparison"]').attr('checked', true);
        $('input[type=checkbox]').on('click', check_checked);
        draw_chart();
    }
</script>
