<form class="form-vertical" action="{$smarty.const.BASE_URI}feedback/meeting" method="post" data-persist="garlic">

    <fieldset>
        <legend>{t}Meeting{/t}</legend>
        <div class="control-group">
            <span><strong>{t}Do you wish to have a meeting with someone to discuss the round?{/t}</strong></span>

            <label class="radio">
                <input type="radio" name="meeting_choice" value="1" data-storage="false">
                {t}Yes{/t}
            </label>
            <label class="radio">
                <input type="radio" name="meeting_choice" value="0" data-storage="false">
                {t}No{/t}
            </label>
        </div>

        <div class="meeting-inputs">
            <div class="control-group">
                <label class="control-label" for="name">{t}With who?{/t}</label>

                <div class="controls">
                    <input id="name" name="name" type="text" placeholder="{t}Name{/t}" class="input-large" value="{$meeting.name}" />
                </div>
            </div>

            <div class="control-group">
                <label>{t}What is the subject of the meeting?{/t}</label>
                <textarea name="subject" class="input-xxlarge">{$meeting.subject}</textarea>
            </div>
        </div>
    </fieldset>

    <div class="form-actions">
        <a href="{$smarty.const.BASE_URI}feedback" class="btn">{t}Cancel{/t}</a>
        <button type="submit" class="btn btn-primary" id="submit" >{t}Submit{/t}</button>
    </div>
</form>

<script type="text/javascript">
    $(document).ready(function()
    {
        $('input[name="meeting_choice"]:radio').change(function()
        {
            var choice = $(this).val();

            if(choice == 0)
            {
                $('.meeting-inputs').slideUp();
            }
            else
            {
                $('.meeting-inputs').slideDown();
            }
        });
    });
</script>