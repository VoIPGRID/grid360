<div id="feedback-form">
    <form class="form-horizontal" action="{$smarty.const.BASE_URI}feedback/edit/{$reviewee.id}" method="post">

        <fieldset>
            <legend>{$smarty.const.TEXT_COMPETENCIES}</legend>

            <table class="table table-striped table-hover">
                <thead>
                <tr>
                    <th>{$smarty.const.TEXT_COMPETENCIES}</th>
                    <th>Beoordeling</th>
                    <th>{$smarty.const.TEXT_COMMENTS}</th>
                </tr>
                </thead>
                <tbody>
                {foreach $reviews as $review}
                    <tr>
                        <td>{$review.competency.name}</td>
                        <td>{$review.rating.id}</td>
                        <td>
                            <input type="hidden" name="reviews[{$review.id}][type]" value="review" />
                            <input type="hidden" name="reviews[{$review.id}][id]" value="{$review.id}" />
                            <textarea class="input-xlarge" name="reviews[{$review.id}][comment]" placeholder="{$smarty.const.FEEDBACK_FORM_COMMENT_PLACEHOLDER|sprintf:{$competency.name}}">{$review.comment}</textarea>
                        </td>
                    </tr>
                {/foreach}
                </tbody>
            </table>
        </fieldset>

        <fieldset>
            <legend>{$smarty.const.FEEDBACK_FORM_EXTRA_QUESTION_HEADER}</legend>
            <div class="control-group">
                {if $reviewee.id == $current_user.id}
                    <label>{$smarty.const.FEEDBACK_FORM_EXTRA_QUESTION_SELF}</label>
                {else}
                    <label>{$smarty.const.FEEDBACK_FORM_EXTRA_QUESTION|sprintf:{$reviewee.firstname}:{$reviewee.lastname}}</label>
                {/if}
                <input type="hidden" name="roundinfo[type]" value="roundinfo">
                <input type="hidden" name="roundinfo[id]" value="{$roundinfo.id}">
                <textarea name="roundinfo[answer]" class="input-xxlarge">{$roundinfo.answer}</textarea>
            </div>
        </fieldset>

        <div class="form-actions">
            <button type="button" class="btn" onclick="history.go(-1);return true;">{$smarty.const.BUTTON_PREVIOUS}</button>
            <button type="submit" class="btn btn-primary" id="submit" >{$smarty.const.BUTTON_SUBMIT}</button><span id="help-text" style="display:none;" class="help-inline">Not all fields are filled in</span>
        </div>
    </form>
</div>
