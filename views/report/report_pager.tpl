<ul class="pager">
    <li class="previous {if $previous_round_id == 0 || $round.id - 1 < 1}disabled{/if}">
        <a href="{if $previous_round_id != 0 && $previous_round_id < $round.id}
                     {$smarty.const.BASE_URI}report/{$previous_round_id}{if $user.id != $current_user.id}/{$user.id}{/if}
                 {/if}">&larr; {t}Previous report{/t}
        </a>
    </li>
    <li class="next {if $next_round_id == 0 || $next_round_id < $round.id}disabled{/if}">
        <a href="{if $next_round_id != 0 && $next_round_id > $round_id}
                 {$smarty.const.BASE_URI}report/{$next_round_id}{if $user.id != $current_user.id}/{$user.id}{/if}
                 {/if}">{t}Next report{/t} &rarr;</a>
    </li>
</ul>
