/**
 * @author epasagic
 * @date 26-3-13
 */

$(document).ready(function ()
{
    $('.controls .btn').bind('click', function()
    {
        add_competency();
        return false;
    });
});

function add_competency()
{
    var optionIndex = $('#competencyList .controls').length;
    var competencyList = document.getElementById('competencyList');

    var inputType = document.createElement('input');
    inputType.name = 'ownCompetencies[' + optionIndex + '][type]';
    inputType.type = 'hidden';
    inputType.value = 'competency';

    var newRole = document.createElement('input');
    newRole.name = 'ownCompetencies[' + optionIndex + '][name]';
    newRole.type = 'text';
    newRole.placeholder = 'Competency name';
    newRole.className = 'input-xlarge';

    var newRoleDescription = document.createElement('textarea');
    newRoleDescription.name = 'ownCompetencies[' + optionIndex + '][description]';
    newRoleDescription.type = 'text';
    newRoleDescription.placeholder = 'Competency description';
    newRoleDescription.className = 'input-xxlarge';

    var image = document.createElement('i');
    image.setAttribute('class', 'icon-remove-sign');

    var competencyDiv = document.createElement('div')
    competencyDiv.className = 'controls';

    competencyList.appendChild(competencyDiv);
    competencyDiv.appendChild(inputType);
    competencyDiv.appendChild(newRole);
    competencyDiv.innerHTML += ' ';
    competencyDiv.appendChild(newRoleDescription);

    var link = document.createElement('a');
    link.class = 'removeCompetencyButton';
    link.href = '#';

    link.appendChild(image);
    competencyDiv.appendChild(link);

    $(link).bind('click', function()
    {
        $(this).parent().remove();
    });

    return false;
}
