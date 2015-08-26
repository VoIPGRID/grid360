{if $reviewee.id == $smarty.session.current_user.id}
    <h3>{t}In what way have you contributed to the success of the organisation?{/t}</h3>
{else}
    <h3>{t firstname=$reviewee.firstname lastname=$reviewee.lastname}In what way has %1 %2 contributed to the success of the organisation?{/t}</h3>
{/if}

<h4>{$step_text}</h4>

<div id="feedback-form">
    <form class="form-horizontal" action="{$smarty.const.BASE_URI}feedback/{$reviewee.id}/3" method="post" data-persist="garlic" data-destroy="false">
        <fieldset>
            <legend>{t}Extra question{/t}</legend>
            <div class="control-group">
                {if $reviewee.id == $current_user.id}
                    <label>{t}In what way have you contributed to the success of the organisation?{/t}</label>
                {else}
                    <label>{t firstname=$reviewee.firstname lastname=$reviewee.lastname}In what way has %1 %2 contributed to the success of the organisation?{/t}</label>
                {/if}
                <textarea name="extra_question" class="input-xxlarge"></textarea>
            </div>
        </fieldset>

        <div class="form-actions">
            <a href="{$smarty.const.BASE_URI}feedback/{$reviewee.id}/2" class="btn">{t}Previous{/t}</a>
            <button type="submit" class="btn btn-primary" id="submit" >{t}Submit{/t}</button>
        </div>
    </form>
</div>
