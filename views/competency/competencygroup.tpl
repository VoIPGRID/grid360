{include file="lib/functions.tpl"}

{function print_competency}
    <tr>
        <input type="hidden" name="ownCompetency[{$index}][type]" value="competency" />
        <input type="hidden" name="ownCompetency[{$index}][id]" value="{$competency.id}" />
        <td>
            <span class="table-text">{$competency.name}</span>
            <input name="ownCompetency[{$index}][name]" type="text" placeholder="{t}Competency name{/t}" class="input-xlarge hide" value="{$competency.name}" />
        </td>
        <td>
            <span class="table-text">{$competency.description}</span>
            <textarea name="ownCompetency[{$index}][description]" placeholder="{t}Competency description{/t}" class="input-xxlarge hide">{$competency.description}</textarea>
        </td>
        <td class="actions">
            <button data-toggle="tooltip" title="{t}Edit{/t}" data-placement="bottom" type="submit" class="btn btn-link">
                <i class="icon-pencil"></i>
            </button>
            <button data-toggle="tooltip" title="{t}Delete{/t}" data-placement="bottom" type="submit" class="btn btn-link" data-competency-id={$competency.id}>
                <i class="icon-trash"></i>
            </button>
        </td>
    </tr>
{/function}

<script type="text/javascript">
    type = 'competency';
    name_placeholder = '{t}Competency name{/t}';
    description_placeholder = '{t}Competency description{/t}';
</script>

<form action="{$smarty.const.BASE_URI}{$smarty.const.MANAGER_URI}competencygroup/{$form_values.id.value}" method="POST" class="form-horizontal" data-persist="garlic">
    <fieldset>
        {if $update && isset($form_values.id.value)}
            <legend>{t name=$competencygroup_name}Updating competency group %1{/t}</legend>
        {else}
            <legend>{t}Creating new competency group{/t}</legend>
        {/if}

        <div class="control-group">
            <label class="control-label" for="general">{t}Is general{/t}?</label>

            <div class="controls">
                <input type="checkbox" id="general" name="general" {if isset($form_values.general.value) && $form_values.general.value == 1 || $form_values.general.value == 'on'}checked{/if} />
                <span><i class="icon-question-sign" data-toggle="tooltip" title="{t}Checking this will display the current competency group for everybody{/t}" data-placement="right"></i></span>
            </div>
        </div>

        <div class="control-group {if isset($form_values.name.error)}error{/if}">
            <input type="hidden" name="type" value="competencygroup" />
            {if isset($form_values.id.value)}
                <input type="hidden" name="id" value="{$form_values.id.value}" />
            {/if}

            <label class="control-label" for="group-name">{t}Group name{/t}</label>

            <div class="controls">
                <input id="group-name" name="name" type="text" placeholder="{t}Group name{/t}" class="input-large" required value="{$form_values.name.value}" />
                {call check_if_error var_name="name"}
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="group_description">{t}Group description{/t}</label>

            <div class="controls">
                <textarea id="group_description" name="description" placeholder="{t}Group description{/t}" class="input-xxlarge">{$form_values.description.value}</textarea>
            </div>
        </div>

        {if !empty({$form_values.competencies.error})}
            <div class="alert alert-error">{$form_values.competencies.error}</div>
        {/if}

        <div class="control-group">
            <label class="control-label">{t}Competencies{/t}</label>

            <div class="controls">
                <div id="competency-list">
                    {if empty($form_values.competencies.value)}
                        <span id="info-text">{t}No competencies found{/t}</span>
                    {/if}
                    <table id="competencies" class="table table-striped {if empty($form_values.competencies.value)}hide{/if}">
                        <thead>
                        <tr>
                            <th>{t}Name{/t}</th>
                            <th>{t}Description{/t}</th>
                            <th>{t}Actions{/t}</th>
                        </tr>
                        </thead>
                        <tbody>
                        {assign "index" 0}
                        {foreach $form_values.competencies.value as $competency}
                            {print_competency}
                            {assign "index" {counter}}
                        {/foreach}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="control-group">
            <div class="controls">
                <button id="add-button" class="btn btn-link"><strong>+</strong> {t}Add competency{/t}</button>
            </div>
        </div>

        <div class="form-actions">
            <a href="{$smarty.const.BASE_URI}{$smarty.const.MANAGER_URI}competencies" class="btn">{t}Cancel{/t}</a>
            <button type="submit" class="btn btn-primary">
                {if $update}
                    {t}Update competency group{/t}
                {else}
                    {t}Create competency group{/t}
                {/if}
            </button>
        </div>
    </fieldset>
</form>

<script type="text/javascript">
    $(document).ready(function()
    {
        option_index = $('#competencies tr').length;

        $('#add-button').click(function(event)
        {
            if($('#info-text'))
            {
                $('#info-text').hide();
                $('#competencies').removeClass('hide');
            }

            add_row();

            event.preventDefault();
        });

        $('#competencies').on('click', 'button', function(event)
        {
            if($(this).children('i').hasClass('icon-pencil'))
            {
                // Find all the spans with the matching class, hide them and then show the matching input fields.
                $(this).parents('tr').find('.table-text').each(function()
                {
                    $(this).hide();
                    $(this).next().show();
                });
            }
            else if($(this).children('i').hasClass('icon-trash'))
            {
                // Check if it's an existing competency or a new one
                if($(this).data('competency-id') != 0 && typeof $(this).data('competency-id') != 'undefined')
                {
                    // Redirect to the delete confirmation page
                    window.location.href = '{$smarty.const.BASE_URI}{$smarty.const.MANAGER_URI}' + 'competency/delete/' + $(this).data('competency-id');
                }
                else
                {
                    // Remove this row
                    $(this).parents('tr').remove();

                    // Check if it's 1 because the first row contains the table headers
                    if($('#competencies tr').length == 1)
                    {
                        $('#info-text').show();
                        $('#competencies').addClass('hide');
                    }
                }
            }

            event.preventDefault();
        });

        function add_row()
        {
            // Create a new row in which a new competency can be entered
            var table_row = $('<tr>' +
                                '<input type="hidden" name="ownCompetency[' + option_index + '][type]" value="competency" />' +
                                '<td><input name="ownCompetency[' + option_index + '][name]" type="text" placeholder="{t}Competency name{/t}" class="input-xlarge" autofocus="autofocus" /></td>' +
                                '<td><textarea name="ownCompetency[' + option_index + '][description]" type="text" placeholder="{t}Competency description{/t}" class="input-xxlarge"></textarea></td>' +
                                '<td class="actions"><button data-toggle="tooltip" title="{t}Delete{/t}" data-placement="bottom" type="submit" class="btn btn-link"><i class="icon-trash"></i></button></td>' +
                              '</tr>');

            $('#competencies tbody').append(table_row);

            option_index++;
        }
    });
</script>
