/**
 * @author epasagic
 * @date 26-3-13
 */

var optionIndex = 1;
function add_role()
{
    var roleList = document.getElementById("roleList");

    var roleLabel = document.createElement("label");
    roleLabel.class = "control-label";

    var inputType = document.createElement('input');
    inputType.name = "ownRoles["+optionIndex+"][type]";
    inputType.type = "hidden";
    inputType.value = "role";

    var newRole = document.createElement("input");
    newRole.name = "ownRoles["+optionIndex+"][name]";
    newRole.type = "text";
    newRole.placeholder = "Role name";
    newRole.setAttribute("class", "input-large");

    var newRoleDescription = document.createElement("input");
    newRoleDescription.name = "ownRoles["+optionIndex+"][description]";
    newRoleDescription.type = "text";
    newRoleDescription.placeholder = "Role description";
    newRoleDescription.setAttribute("class", "input-large");

    var image = document.createElement("i");
    image.setAttribute('class', 'icon-remove-sign');

    var roleDiv = document.createElement("div")

    roleList.appendChild(roleDiv);
    roleDiv.appendChild(inputType);
    roleDiv.appendChild(roleLabel);
    roleDiv.appendChild(newRole);
    roleDiv.innerHTML += " ";
    roleDiv.appendChild(newRoleDescription);

    var link = document.createElement("a");
    link.class = 'removeRoleButton';
    link.href = '#';
    link.style.marginLeft = '5px';

    link.appendChild(image);
    roleDiv.appendChild(link);

    $(link).bind('click', function()
    {
        $(this).parent().remove();
    });

    optionIndex++;

    return false;
}
