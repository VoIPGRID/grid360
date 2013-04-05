{function name="showActions"}

    {if {$type} == "user"}
        <td class="actionsUser">
    {else}
        <td class="actions">
    {/if}
        <form action="{${$level}_uri}/{$type}/{${$type}.id}">
            <button data-toggle="tooltip" title="Edit" data-placement="bottom" type="submit" class="btn btn-link">
                <i class="icon-pencil"></i>
            </button>
        </form>

        {if {$type} == "user"}
            <form action="{${$level}_uri}/{$type}/{${$type}.id}">
                {if $user.status == 1}
                    <button data-toggle="tooltip" title="Pause feedback" data-placement="bottom" type="submit" class="btn btn-link">
                        <i class="icon-pause"></i>
                    </button>
                {else}
                    <button data-toggle="tooltip" title="Resume feedback" data-placement="bottom" type="submit" class="btn btn-link">
                        <i class="icon-play"></i>
                    </button>
                {/if}
            </form>
        {/if}

        <form action="{${$level}_uri}/{$type}/{${$type}.id}" method="post">
            <input type="hidden" name="_method" value="DELETE" id="_method">
            <button data-toggle="tooltip" title="Delete" data-placement="bottom" type="submit" class="btn btn-link">
                <i class="icon-trash"></i>
            </button>
        </form>
    </td>
{/function}

<script type="text/javascript">
$(document).ready(function() {
    $('[data-toggle="tooltip"]').tooltip();
});
</script>