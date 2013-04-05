/**
 * @author epasagic
 * @date 26-3-13
 */

var optionIndex = 1;
function add_competency()
{
    var competencyList = document.getElementById("competencyList");

    var roleLabel = document.createElement("label");
    roleLabel.class = "control-label";

    var inputType = document.createElement('input');
    inputType.name = "ownCompetencies["+optionIndex+"][type]";
    inputType.type = "hidden";
    inputType.value = "competency";

    var newRole = document.createElement("input");
    newRole.name = "ownCompetencies["+optionIndex+"][name]";
    newRole.type = "text";
    newRole.placeholder = "Competency name";
    newRole.setAttribute("class", "input-large");

    var newRoleDescription = document.createElement("textarea");
    newRoleDescription.name = "ownCompetencies["+optionIndex+"][description]";
    newRoleDescription.type = "text";
    newRoleDescription.placeholder = "Competency description";
    newRoleDescription.setAttribute("class", "input-large");

    var image = document.createElement("i");
    image.setAttribute('class', 'icon-remove-sign');

    var competencyDiv = document.createElement("div")

    competencyList.appendChild(competencyDiv);
    competencyDiv.appendChild(inputType);
    competencyDiv.appendChild(roleLabel);
    competencyDiv.appendChild(newRole);
    competencyDiv.innerHTML += " ";
    competencyDiv.appendChild(newRoleDescription);

    var link = document.createElement("a");
    link.class = 'removeCompetencyButton';
    link.href = '#';
    link.style.marginLeft = '5px';

    link.appendChild(image);
    competencyDiv.appendChild(link);

    $(link).bind('click', function()
    {
        $(this).parent().remove();
    });

    optionIndex++;

    return false;
}
