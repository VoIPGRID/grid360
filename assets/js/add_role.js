/**
 * @author epasagic
 * @date 26-3-13
 */

$(document).ready(function ()
{
    $('.controls .btn').click(function(event)
    {
        add_role(event);
    });

    $('#roleList').on('click', 'button', function(event)
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
    var optionIndex = $('#roleList .controls').length;

    var inputType = $('<input type="hidden" name="ownRoles[' + optionIndex + '][type]" />').val('role');
    var newRole = $('<input type="text" name="ownRoles[' + optionIndex + '][name]" placeholder="Role name" class="input-xlarge" />');

    var newRoleDescription = $('<textarea name="ownRoles[' +  optionIndex + '][description]" placeholder="Role description" class="input-xxlarge"></textarea>');

    var roleDiv = $('<div class="controls"></div>');

    roleDiv.append(inputType);
    roleDiv.append(newRole);
    roleDiv.append('&nbsp;');
    roleDiv.append(newRoleDescription);

    var removeButton = $('<button class="btn btn-link"></button>');
    var image = $('<i class="icon-remove-sign"></i>');

    removeButton.append(image);
    roleDiv.append(removeButton);
    roleDiv.hide();

    $('#roleList').append(roleDiv);

    roleDiv.slideDown();

    return false;
}
