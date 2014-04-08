<div id="feedback-form">
    <form class="form-horizontal" action="{$smarty.const.BASE_URI}feedback/edit/{$reviewee.id}" method="post">

        <fieldset>
            <legend>{t}Competencies{/t}</legend>

            <table class="table table-striped table-hover">
                <thead>
                <tr>
                    <th class="span2">{t}Rating{/t}</th>
                    <th class="span3">{t}Competencies{/t}</th>
                    <th class="span7">{t}Comments{/t}</th>
                </tr>
                </thead>
                <tbody>
                {foreach $reviews as $review}
                    <tr>
                        {if $review.selection == 3}
                        <td colspan="2">
                             {t}I can't review role specific competencies{/t}
                        </td>
                        {else}
                        <td>
                            {if $review.selection == 1}
                            <span class="smile-active"></span>
                            {elseif $review.selection == 2}
                            <span class="meh-active"></span>
                            {/if}
                        </td>
                        <td>{$review.competency.name}</td>
                        {/if}
                        <td>
                            <input type="hidden" name="reviews[{$review.id}][type]" value="review" />
                            <input type="hidden" name="reviews[{$review.id}][id]" value="{$review.id}" />
                            <textarea class="input-block-level" name="reviews[{$review.id}][comment]" placeholder="{t competency=$competency.name}Add a comment for the competency %1 here{/t}">{$review.comment}</textarea>
                        </td>
                    </tr>
                {/foreach}
                </tbody>
            </table>
        </fieldset>

        <fieldset>
            <legend>{t}Agreements{/t}</legend>

            <table class="table table-striped table-hover">
                <thead>
                <tr>
                    <th class="span2">{t}Rating{/t}</th>
                    <th class="span3">{t}Agreements{/t}</th>
                    <th class="span7">{t}Comments{/t}</th>
                </tr>
                </thead>
                <tbody>
                {foreach $agreement_reviews as $agreement_review}
                    <tr>
                        <td>
                            {if $agreement_review.selection == 1}
                                <span class="smile-active"></span>
                            {elseif $agreement_review.selection == 2}
                                <span class="meh-active"></span>
                            {/if}
                        </td>
                        <td>{$agreements.{$agreement_review.type}.label} <br />
                            <small class="muted">{$agreements.{$agreement_review.type}.value}</small>
                        </td>
                        <td>
                            <input type="hidden" name="agreement_reviews[{$agreement_review.id}][type]" value="agreementreview" />
                            <input type="hidden" name="agreement_reviews[{$agreement_review.id}][id]" value="{$agreement_review.id}" />
                            <textarea class="input-block-level" name="agreement_reviews[{$agreement_review.id}][comment]" placeholder="{t type=$type}Add a comment for %1 agreement here{/t}">{$agreement_review.comment}</textarea>
                        </td>
                    </tr>
                {/foreach}
                </tbody>
            </table>
        </fieldset>

        <fieldset>
            <legend>{t}Extra question{/t}</legend>
            <div class="control-group">
                {if $reviewee.id == $current_user.id}
                    <label>{t}In what way have you contributed to the success of the organisation?{/t}</label>
                {else}
                    <label>{t firstname=$reviewee.firstname lastname=$reviewee.lastname}In what way has %1 %2 contributed to the success of the organisation?{/t}</label>
                {/if}
                <input type="hidden" name="roundinfo[type]" value="roundinfo">
                <input type="hidden" name="roundinfo[id]" value="{$roundinfo.id}">
                <textarea name="roundinfo[answer]" class="input-xxlarge">{$roundinfo.answer}</textarea>
            </div>
        </fieldset>

        <div class="form-actions">
            <a href="{$smarty.const.BASE_URI}feedback" class="btn">{t}Previous{/t}</a>
            <button type="submit" class="btn btn-primary" id="submit" >{t}Submit{/t}</button>
        </div>
    </form>
</div>
