/**
 * @author epasagic
 * @date 26-3-13
 */

$(document).ready(function ()
{
    $('.controls .btn').click(function(event)
    {
        add_competency(event);
    });

    $('#competencyList').on('click', 'button', function(event)
    {
        event.preventDefault();
        $(this).parent().slideUp('medium', function()
        {
            $(this).remove();
        });
    });
});

function add_competency(event)
{
    event.preventDefault();
    var optionIndex = $('#competencyList .controls').length;

    var inputType = $('<input type="hidden" name="ownCompetencies[' + optionIndex + '][type]" />').val('role');
    var newCompetency = $('<input type="text" name="ownCompetencies[' + optionIndex + '][name]" placeholder="Competency name" class="input-xlarge" />');

    var newCompetencyDescription = $('<textarea name="ownCompetencies[' +  optionIndex + '][description]" placeholder="Competency description" class="input-xxlarge"></textarea>');

    var competencyDiv = $('<div class="controls"></div>');

    competencyDiv.append(inputType);
    competencyDiv.append(newCompetency);
    competencyDiv.append('&nbsp;');
    competencyDiv.append(newCompetencyDescription);

    var removeButton = $('<button class="btn btn-link"></button>');
    var image = $('<i class="icon-remove-sign"></i>');

    removeButton.append(image);
    competencyDiv.append(removeButton);
    competencyDiv.hide();

    $('#competencyList').append(competencyDiv);

    competencyDiv.slideDown();

    return false;
}

