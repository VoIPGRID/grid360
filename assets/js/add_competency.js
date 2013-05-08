$(document).ready(function()
{
    $('.controls .btn').click(function(event)
    {
        add_competency(event);
    });

    $('#competency-list').on('click', 'button', function(event)
    {
        event.preventDefault();
        $(this).parent().slideUp('medium', function()
        {
            $(this).remove();
        });
    });

    $('[data-toggle="tooltip"]').tooltip();
});

function add_competency(event)
{
    event.preventDefault();
    var option_index = $('#competency-list .controls').length;

    var input_type = $('<input type="hidden" name="ownCompetencies[' + option_index + '][type]" />').val('role');
    var new_competency = $('<input type="text" name="ownCompetencies[' + option_index + '][name]" placeholder="Competency name" class="input-xlarge" />');

    var new_competency_description = $('<textarea name="ownCompetencies[' +  option_index + '][description]" placeholder="Competency description" class="input-xxlarge"></textarea>');

    var competency_div = $('<div class="controls"></div>');

    competency_div.append(input_type);
    competency_div.append(new_competency);
    competency_div.append('&nbsp;');
    competency_div.append(new_competency_description);

    var remove_button = $('<button class="btn btn-link"></button>');
    var image = $('<i class="icon-remove-sign"></i>');

    remove_button.append(image);
    competency_div.append(remove_button);
    competency_div.hide();

    $('#competency-list').append(competency_div);

    competency_div.slideDown();

    return false;
}

