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
    // Create a new row in which a new competency or role can be entered
    var row = $('<div class="controls">' +
                        '<input type="hidden" name="own' + capitalize(type) + '[' + option_index + '][type]" value="' + type + '"/>' +
                        '<input type="text" name="own' + capitalize(type) + '[' + option_index + '][name]" placeholder="' + name_placeholder + '" class="input-xlarge" />' +
                        '&nbsp;' +
                        '<textarea name="own' + capitalize(type) + '[' + option_index + '][description]" placeholder="' + description_placeholder + '" class="input-xxlarge"></textarea>' +
                        '<button class="btn btn-link"><i class="icon-remove-sign"></i></button>' +
                   '</div>');

    $('#' + type + '-list').append(row);

    row.hide();
    row.slideDown();

    option_index++;
}

function capitalize(string)
{
    return string.charAt(0).toUpperCase() + string.slice(1);
}
