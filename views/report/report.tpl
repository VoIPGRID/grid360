{function print_review}
    {foreach $review_array[$selection] as $competency_name => $reviews}
        <div class="review-div">
            {if $selection == 1}
                <span class="smile-active"></span>
            {elseif $selection == 2}
                <span class="meh-active"></span>
            {/if}
            <div class="review-comments">
                <strong>{$competency_name}</strong><br />
                {foreach $reviews as $review}
                    <span class="review-info">
                        <strong>{if $review.reviewer.id == $smarty.session.current_user.id}[{t}Own{/t}]{else}[{$review.reviewer.firstname} {$review.reviewer.lastname}]{/if}</strong> {$review.comment}
                    </span>
                    <br />
                {/foreach}
            </div>
        </div>
    {/foreach}
{/function}

<script type="text/javascript" src="{$smarty.const.ASSETS_URI}js/bootstrap-tabdrop.js"></script>
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
{if !$insufficient_data}
    <fieldset>
        <div class="row-fluid">
        <span class="span12">
            <label id="options-label">
                <p class="lead">{t}Options{/t}<i class="icon-plus-sign"></i>
                    <small class="muted">({t}show{/t})</small>
                </p>
            </label>
            <div id="options">
                <strong>{t}Competencies{/t}</strong>

                <div id="competency-boxes" class="well">
                    {foreach $averages as $competency_id => $average}
                        <div class="controls">
                            <label class="checkbox">
                                <input type="checkbox" value="{$competency_id}"/>{$average.name}
                            </label>
                        </div>
                    {/foreach}
                    <div>
                        <button id="select-all" class="btn btn-link">{t}Select all{/t}</button>
                        /
                        <button id="deselect-all" class="btn btn-link">{t}Deselect all{/t}</button>
                    </div>
                </div>

                <strong>{t}Graph options{/t}</strong>

                <div class="well">
                    <div class="controls">
                        <label class="checkbox">
                            <input type="checkbox" name="check_average" value="1"/>{t}Show average{/t}
                        </label>
                    </div>
                    <div class="controls">
                        <label class="checkbox">
                            <input type="checkbox" name="check_own" value="2" {if !$has_own_ratings}disabled{/if}/>{t}Show own{/t}
                        </label>
                    </div>
                    <div class="controls">
                        <label class="checkbox">
                            <input type="checkbox" name="check_comparison" value="4" {if !$has_own_ratings}disabled{/if}/>{t}Show comparisons{/t}
                        </label>
                    </div>
                </div>
            </div>
        </span>
        </div>
    </fieldset>

    {if $review_count > 0}
        <h3>{t}Me about me{/t}</h3>
        <div class="row-fluid">
            <span class="span6" id="own-general-competencies">
                <legend>{t}General competencies{/t}</legend>
                {if count($own_general_reviews) > 0}
                    {print_review review_array=$own_general_reviews selection=1}
                    {print_review review_array=$own_general_reviews selection=2}
                {else}
                    {t}No reviews found{/t}
                {/if}
            </span>

            <span class="span6" id="own-role-competencies">
                <legend>{t}Role competencies{/t}</legend>
                {if count($own_role_reviews) > 0}
                    {print_review review_array=$own_role_reviews selection=1}
                    {print_review review_array=$own_role_reviews selection=2}
                {else}
                    {t}No reviews found{/t}
                {/if}
            </span>
        </div>

        <h3>{t}Others about me{/t}</h3>
        <div class="row-fluid">
            <span class="span6" id="other-general-competencies">
                <legend>{t}General competencies{/t}</legend>
                {if count($other_general_reviews) > 0}
                    {print_review review_array=$other_general_reviews selection=1}
                    {print_review review_array=$other_general_reviews selection=2}
                {else}
                    {t}No reviews found{/t}
                {/if}
            </span>

            <span class="span6" id="other-role-competencies">
                <legend>{t}Role competencies{/t}</legend>
                {if count($other_role_reviews) > 0}
                    {print_review review_array=$other_role_reviews selection=1}
                    {print_review review_array=$other_role_reviews selection=2}
                {else}
                    {t}No reviews found{/t}
                {/if}
            </span>
        </div>

        <h3>{t}Other comments{/t}</h3>
        <div class="row-fluid">
            <span class="span6" id="other-general-competencies">
                <legend>{t}Role competencies{/t}</legend>
                {if count($other_role_reviews[3]) > 0}
                    {print_review review_array=$other_role_reviews selection=3}
                {else}
                    {t}No reviews found{/t}
                {/if}
            </span>
            </span>
        </div>
    {else}
        {t}No reviews found for the current round{/t}
    {/if}
{else}
    {$insufficient_reviewed_by}
    <br />
    <br />
    {$insufficient_reviewed}
{/if}

<script type="text/javascript">
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
            $('#competency-boxes input:checkbox:not(:checked)').attr('checked', true);
        });

        $('#deselect-all').click(function()
        {
            $('#competency-boxes input:checked').attr('checked', false);
        });

        $('input[name="check_own"]').click(function()
        {
            $('input[name="check_comparison"]').attr('checked', false);
        });

        $('input[name="check_average"]').click(function()
        {
            $('input[name="check_comparison"]').attr('checked', false);
        });

        $('input[name="check_comparison"]').click(function()
        {
            if($('input[name="check_comparison"]').is(':not(:checked)'))
            {
                $('input[name="check_average"]').click();
                $('input[name="check_own"]').attr('checked', 'checked');
            }
        });

        $('#options-label').click(function()
        {
            $('#options').slideToggle();
            if($('#options-label i').attr('class') == 'icon-minus-sign')
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

        $('input[type=checkbox]').not('input[name="check_comparison"]').attr('checked', true);
    });
</script>
