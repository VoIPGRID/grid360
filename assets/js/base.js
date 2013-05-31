$(document).ready(function()
{
    $('[data-toggle="tooltip"]').tooltip();

    $('.btn.btn-link.status').click(function(event)
    {
        event.preventDefault();

        var id = $(this).siblings('input[type="hidden"]').val();
        var icon_class = $(this).find('i').attr('class');
        var status = 0;

        if(icon_class == 'icon-play')
        {
            status = 1;
        }
        else if(icon_class == 'icon-pause')
        {
            status = 0;
        }

        $.ajax({
            type: 'POST',
            data: {id: id, status: status},
            url: base_uri + 'admin/user/status'
        }).done(function()
            {
                window.location.href = $(location).attr('href');
            });

        return false;
    });

    if (get_parameter_by_name('error') != '' ||
        get_parameter_by_name('warning') != '' ||
        get_parameter_by_name('success') != '' ||
        get_parameter_by_name('info') != '')
    {

        history.replaceState(null, document.title, get_raw_url());
    }

    function get_raw_url()
    {
        var url_parts = window.location.href.split('?');
        var url = url_parts[0];

        var regex_string = '^(.*)&(?:.*)$';
        var regex = new RegExp(regex_string);
        var results = regex.exec(url);
        if(results == null)
        {
            return url;
        }
        else
        {
            return results[1];
        }
    }

    function get_parameter_by_name(name)
    {
        name = name.replace(/[\[]/, '\\\[').replace(/[\]]/, '\\\]');
        var regex_string = '[\\?&]' + name + '=([^&#]*)';
        var regex = new RegExp(regex_string);
        var results = regex.exec(window.location.href);
        if(results == null)
        {
            return '';
        }
        else
        {
            return decodeURIComponent(results[1].replace(/\+/g, ' '));
        }
    }
});
