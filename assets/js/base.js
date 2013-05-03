$(document).ready(function ()
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
            url: '/grid360/admin/user/status'
        }).done(function()
            {
                window.location.href = $(location).attr('href');
            });

        return false;
    });
});
