{function show_actions}
    {if $type eq "user"}
        <td class="actions-user">
            {else}
        <td class="actions">
    {/if}
    <form action="{${$level|upper}_URI}{$type}/{${$type}.id}">
        <button data-toggle="tooltip" title="Edit" data-placement="bottom" type="submit" class="btn btn-link">
            <i class="icon-pencil"></i>
        </button>
    </form>
    {if {$type} == "user"}
        <form action="{${$level|upper}_URI}{$type}/{${$type}.id}">
            <input type="hidden" name="user_id" value="{${$type}.id}" />
            {if $user.status == 1}
                <button data-toggle="tooltip" title="Pause feedback" data-placement="bottom" type="submit" class="btn btn-link status">
                    <i class="icon-pause"></i>
                </button>
            {else}
                <button data-toggle="tooltip" title="Resume feedback" data-placement="bottom" type="submit" class="btn btn-link status">
                    <i class="icon-play"></i>
                </button>
            {/if}
        </form>
    {/if}
    <form action="{${$level|upper}_URI}{$type}/{${$type}.id}" method="post">
        <input type="hidden" name="_method" value="DELETE" id="_method" />
        <button data-toggle="tooltip" title="Delete" data-placement="bottom" type="submit" class="btn btn-link">
            <i class="icon-trash"></i>
        </button>
    </form>
    </td>
{/function}

{function print_add_link}
    <div class="pull-right">
        {if $type eq "competencygroup"}
            <a href="{${$level|upper}_URI}{$type}/create"><strong>+</strong> Add competency group</a>
        {else}
            <a href="{${$level|upper}_URI}{$type}/create"><strong>+</strong> Add {$type}</a>
        {/if}
    </div>
{/function}
