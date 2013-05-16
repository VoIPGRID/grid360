$(document).ready(function()
{
    $('input').numeric({decimal: false});
    $('input').blur(check_inputs);
    $('textarea').blur(check_description);
    $('[type="submit"]').click(check_inputs);

    function check_inputs()
    {
        var form_valid = check_description();

        var min_own = parseInt($('#min-own').val());
        var max_own = parseInt($('#max-own').val());
        var min_other = parseInt($('#min-other').val());
        var max_other = parseInt($('#max-other').val());

        if(!isNaN(min_own) && min_own < 0)
        {
            $('#min-own-group').addClass('error');
            $('#min-own-group .help-inline').text('Minimum can\'t be less than 0!');
            form_valid = false;
        }
        else
        {
            $('#min-own-group').removeClass('error');
            $('#min-own-group .help-inline').empty();
        }

        // Check if min_own greater than max_own if max_own has a value
        if(!isNaN(max_own))
        {
            if(max_own > 0 && min_own > max_own)
            {
                $('#min-own-group').addClass('error');
                $('#min-own-group .help-inline').text('Minimum can\'t be greater than maximum!');
                form_valid = false;
            }
            else if(max_own < 0)
            {
                $('#max-own-group').addClass('error');
                $('#max-own-group .help-inline').text('Maximum can\'t be less than 0!');
                form_valid = false;
            }
            else
            {
                $('#max-own-group').removeClass('error');
                $('#max-own-group .help-inline').empty();
            }
        }

        if(!isNaN(min_other) && min_other < 0)
        {
            $('#min-other-group').addClass('error');
            $('#min-other-group .help-inline').text('Minimum can\'t be less than 0!');
            form_valid = false;
        }
        else
        {
            $('#min-other-group').removeClass('error');
            $('#min-other-group .help-inline').empty();
        }

        // Check if min_other greater than max_other if max_other has a value
        if(!isNaN(max_other))
        {
            if(max_other > 0 && min_other > max_other)
            {
                $('#min-other-group').addClass('error');
                $('#min-other-group .help-inline').text('Minimum can\'t be greater than maximum!');
                form_valid = false;
            }
            else if(max_other < 0)
            {
                $('#max-other-group .help-inline').text('Maximum can\'t be less than 0!');
                $('#max-other-group').addClass('error');
                form_valid = false;
            }
            else
            {
                $('#max-other-group').removeClass('error');
                $('#max-other-group .help-inline').empty();
            }
        }

        return form_valid;
    }

    function check_description()
    {
        if($.trim($('#round-description').val()).length == 0)
        {
            $('#description-group').addClass('error');
            $('#description-group .help-inline').text('Round description can\'t be empty!');
            return false;
        }
        else
        {
            $('#description-group').removeClass('error');
            $('#description-group .help-inline').empty();
        }

        return true;
    }

    $('#info-box-button').click(function(event)
    {
        if($('#field-info').is(':visible'))
        {
            $(this).text('+ Show info');
        }
        else
        {
            $(this).text('- Hide info');
        }
        $('#field-info').slideToggle();
        event.preventDefault();
        return false;
    });
});
