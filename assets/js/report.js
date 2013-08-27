$(document).ready(function()
{
    $('.pager li').click(function()
    {
        if($(this).hasClass('disabled'))
        {
            return false;
        }
    });

    $('#select-all').click(function()
    {
        $('#competency-boxes input:checkbox:not(:checked)').click();
    });

    $('#deselect-all').click(function()
    {
        $('#competency-boxes input:checkbox:checked').click();
    });

    $('#options-label').click(function()
    {
        $('#options').slideToggle();
        if($('#options-label i').hasClass('icon-minus-sign'))
        {
            $('#options-label i').attr('class', 'icon-plus-sign');
            $('#options-label small').text('({t}show{/t})');
        }
        else
        {
            $('#options-label i').attr('class', 'icon-minus-sign');
            $('#options-label small').text('({t}hide{/t})');
        }
    });

    function check_checked()
    {
        $('input[type="checkbox"]').each(function()
        {
            if($(this).is(':not(:checked)'))
            {
                $('[data-competency-id="' + $(this).val() + '"]').slideUp();
            }
            else if($(this).is(':checked') && $('[data-competency-id="' + $(this).val() + '"]').is(':not(:visible)'))
            {
                $('[data-competency-id="' + $(this).val() + '"]').slideDown();
            }
        });
    }

    $('input[type=checkbox]').on('click', check_checked);

    $('input[type=checkbox]').not('input[name="check_comparison"]').attr('checked', 'checked');
});