function create_datatable(table, ignored_columns)
{
    if(ignored_columns == undefined || ignored_columns.length == 0)
    {
        ignored_columns = [-1]; // Stop the last column from being sortable by default (usually the column action)
    }

    table.dataTable({
        "sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
        "bStateSave": true, // Save the state of the table to localStorage
        "aoColumnDefs": [
            {"bSortable": false, bSearchable: false, "aTargets": ignored_columns}
        ],
        oLanguage: get_language_object()
    });

    $.extend($.fn.dataTableExt.oStdClasses, {
        "sWrapper": "dataTables_wrapper form-inline"
    });
}

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

function get_language_object()
{
    var locale = $('html').attr('lang');
    var oLanguage;

    if(locale == 'nl')
    {
        oLanguage =
        {
            "sProcessing": "Bezig...",
            "sLengthMenu": "_MENU_ resultaten weergeven",
            "sZeroRecords": "Geen resultaten gevonden",
            "sInfo": "_START_ tot _END_ van _TOTAL_ resultaten",
            "sInfoEmpty": "Geen resultaten om weer te geven",
            "sInfoFiltered": " (gefilterd uit _MAX_ resultaten)",
            "sInfoPostFix": "",
            "sSearch": "Zoeken:",
            "sEmptyTable": "Geen resultaten aanwezig in de tabel",
            "sInfoThousands": ".",
            "sLoadingRecords": "Een moment geduld aub - bezig met laden...",
            "oPaginate":
            {
                "sFirst": "Eerste",
                "sLast": "Laatste",
                "sNext": "Volgende",
                "sPrevious": "Vorige"
            }
        }
    }
    else
    {
        oLanguage =
        {
            "sEmptyTable":     "No data available in table",
            "sInfo":           "Showing _START_ to _END_ of _TOTAL_ entries",
            "sInfoEmpty":      "Showing 0 to 0 of 0 entries",
            "sInfoFiltered":   "(filtered from _MAX_ total entries)",
            "sInfoPostFix":    "",
            "sInfoThousands":  ",",
            "sLengthMenu":     "Show _MENU_ entries",
            "sLoadingRecords": "Loading...",
            "sProcessing":     "Processing...",
            "sSearch":         "Search:",
            "sZeroRecords":    "No matching records found",
            "oPaginate":
            {
                "sFirst":    "First",
                "sLast":     "Last",
                "sNext":     "Next",
                "sPrevious": "Previous"
            }
        }
    }

    return oLanguage;
}
