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
                        <td>
                            {if $review.selection == 1}
                            <span class="smile-active"></span>
                            {else if $review.selection == 2}
                            <span class="meh-active"></span>
                            {/if}
                        </td>
                        <td>{$review.competency.name}</td>
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
            <button type="button" class="btn" onclick="history.go(-1);return true;">{t}Previous{/t}</button>
            <button type="submit" class="btn btn-primary" id="submit" >{t}Submit{/t}</button><span id="help-text" style="display:none;" class="help-inline">Not all fields are filled in</span>
        </div>
    </form>
</div>
