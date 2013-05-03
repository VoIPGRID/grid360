$(document).ready(function ()
{
    $('.controls .btn').click(function(event)
    {
        add_role(event);
    });

    $('#role-list').on('click', 'button', function(event)
    {
        event.preventDefault();
        $(this).parent().slideUp('medium', function()
        {
            $(this).remove();
        });
    });
});

function add_role(event)
{
    event.preventDefault();
    var option_index = $('#role-list .controls').length;

    var input_type = $('<input type="hidden" name="ownRoles[' + option_index + '][type]" />').val('role');
    var new_role = $('<input type="text" name="ownRoles[' + option_index + '][name]" placeholder="Role name" class="input-xlarge" />');

    var new_role_description = $('<textarea name="ownRoles[' +  option_index + '][description]" placeholder="Role description" class="input-xxlarge"></textarea>');

    var role_div = $('<div class="controls"></div>');

    role_div.append(input_type);
    role_div.append(new_role);
    role_div.append('&nbsp;');
    role_div.append(new_role_description);

    var remove_button = $('<button class="btn btn-link"></button>');
    var image = $('<i class="icon-remove-sign"></i>');

    remove_button.append(image);
    role_div.append(remove_button);
    role_div.hide();

    $('#role-list').append(role_div);

    role_div.slideDown();

    return false;
}
