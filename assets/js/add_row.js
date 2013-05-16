$(document).ready(function()
{
    option_index = $('#' + type + '-list .controls').length;

    $('#add-button').click(function(event)
    {
        add_row();
        event.preventDefault();
    });

    $('#' + type + '-list').on('click', 'button', function(event)
    {
        $(this).parent().slideUp('medium', function()
        {
            $(this).remove();
        });

        event.preventDefault();
    });
});

function add_row()
{
    var input_type = $('<input type="hidden" name="own' + capitalize(type) + '[' + option_index + '][type]" />').val(type);
    var name_input = $('<input type="text" name="own' + capitalize(type) + '[' + option_index + '][name]" placeholder="' + capitalize(type) + ' name" class="input-xlarge" />');

    var row_description = $('<textarea name="own' + capitalize(type) + '[' + option_index + '][description]" placeholder="' + capitalize(type) + ' description" class="input-xxlarge"></textarea>');

    var controls = $('<div class="controls"></div>');

    controls.append(input_type);
    controls.append(name_input);
    controls.append('&nbsp;');
    controls.append(row_description);

    var remove_button = $('<button class="btn btn-link"></button>');
    var image = $('<i class="icon-remove-sign"></i>');

    remove_button.append(image);
    controls.append(remove_button);
    controls.hide();

    $('#' + type + '-list').append(controls);

    controls.slideDown();

    option_index++;
}

function capitalize(string)
{
    return string.charAt(0).toUpperCase() + string.slice(1);
}
