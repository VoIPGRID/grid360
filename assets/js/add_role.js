/**
 * @author epasagic
 * @date 26-3-13
 */

$(document).ready(function ()
{
    $('.controls .btn').bind('click', function()
    {
        add_role();
        return false;
    });
});

function add_role()
{
    var optionIndex = $('#roleList .controls').length;
    var roleList = document.getElementById('roleList');

    var inputType = document.createElement('input');
    inputType.name = 'ownRoles[' + optionIndex + '][type]';
    inputType.type = 'hidden';
    inputType.value = 'role';

    var newRole = document.createElement('input');
    newRole.name = 'ownRoles[' + optionIndex + '][name]';
    newRole.type = 'text';
    newRole.placeholder = 'Role name';
    newRole.className = 'input-xlarge';

    var newRoleDescription = document.createElement('textarea');
    newRoleDescription.name = 'ownRoles[' + optionIndex + '][description]';
    newRoleDescription.type = 'text';
    newRoleDescription.placeholder = 'Role description';
    newRoleDescription.className = 'input-xxlarge';

    var image = document.createElement('i');
    image.className = 'icon-remove-sign';

    var roleDiv = document.createElement('div')
    roleDiv.className = 'controls';

    roleList.appendChild(roleDiv);
    roleDiv.appendChild(inputType);
    roleDiv.appendChild(newRole);
    roleDiv.innerHTML += ' ';
    roleDiv.appendChild(newRoleDescription);

    var link = document.createElement('a');
    link.class = 'removeRoleButton';
    link.href = '#';

    link.appendChild(image);
    roleDiv.appendChild(link);

    $(link).bind('click', function()
    {
        $(this).parent().remove();
    });

    return false;
}
