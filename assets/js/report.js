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

    $('#select-all-agreements').click(function()
    {
        $('#agreement-boxes input:checkbox:not(:checked)').click();
    });

    $('#deselect-all-agreements').click(function()
    {
        $('#agreement-boxes input:checkbox:checked').click();
    });

    $('#options-label').click(function()
    {
        $('#options').slideToggle();
        if($('#options-label i').hasClass('icon-minus-sign'))
        {
            $('#options-label i').attr('class', 'icon-plus-sign');
            $('#options-label small').text('(' + show_text + ')');
        }
        else
        {
            $('#options-label i').attr('class', 'icon-minus-sign');
            $('#options-label small').text('(' + hide_text + ')');
        }
    });

    function check_checked()
    {
        $('#competency-boxes input[type="checkbox"]').each(function()
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

        $('#agreement-boxes input[type="checkbox"]').each(function()
        {
            if($(this).is(':not(:checked)'))
            {
                $('[data-agreement-type="' + $(this).val() + '"]').slideUp();
            }
            else if($(this).is(':checked') && $('[data-agreement-type="' + $(this).val() + '"]').is(':not(:visible)'))
            {
                $('[data-agreement-type="' + $(this).val() + '"]').slideDown();
            }
        });
    }

    $('input[type=checkbox]').on('click', check_checked);
    $('input[type=checkbox]').attr('checked', 'checked');
});