$(document).ready(function()
{
    $('[data-toggle="tooltip"]').tooltip();
    $('input[type=checkbox]').click(count_checked);

    $('#submit').click(function()
    {
        var count = $('input:checked').length;
        if(step == 2)
        {
            if(!(count >= 2))
            {
                return false;
            }
        }
        else
        {
            if(!(count >= 3))
            {
                return false;
            }
        }
    });

    function count_checked()
    {
        var count = $('input:checked').length;
        if(step == 2)
        {
            if(count >= 2)
            {
                $('input:not(:checked)').attr('disabled', true);
            }
            else
            {
                $('input:not(:checked)').attr('disabled', false);
            }
        }
        else
        {
            if(count >= 3)
            {
                $("input:not(:checked)").attr('disabled', true);
            }
            else
            {
                $("input:not(:checked)").attr('disabled', false);
            }
        }
    };
});
