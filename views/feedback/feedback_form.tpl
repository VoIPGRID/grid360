{function name="createRadiobuttons"}
    {for $index=1 to 5}
        {if $index >= $disabledFrom && $index <= $disabledTo}
            <div class="span2"><input type="radio" name="{$competency.id}" disabled="disabled"></div>
        {else}
            <div class="span2"><input type="radio" name="{$competency.id}" value="{$index}"></div>
        {/if}
    {/for}
{/function}

<div class="container">
    <form class="form-horizontal" action="{$base_uri}feedback/3" method="post">

        <fieldset>
            <legend>General competencies</legend>
        </fieldset>
        <div class="row-fluid">
            <div class="span2 offset2">Underdeveloped</div>
            <div class="span2">Moderatly developed</div>
            <div class="span2">Neutral</div>
            <div class="span2">Well developed</div>
            <div class="span2">Very well developed</div>
        </div>

        {foreach $positiveCompetencies as $competency}
            <div class="row-fluid">
                <div class="control-group">
                    <div class="span2">
                        {$competency.name}
                    </div>
                    {createRadiobuttons competency=$competency disabledFrom=0 disabledTo=2}
                </div>
            </div>
        {/foreach}

        <br>

        <fieldset>
            <legend>Points of improvement</legend>
        </fieldset>
        {foreach $negativeCompetencies as $competency}
            <div class="row-fluid">
                <div class="control-group">
                    <div class="span2">
                        {$competency.name}
                    </div>
                    {createRadiobuttons competency=$competency disabledFrom=4 disabledTo=5}
                </div>
            </div>
        {/foreach}

        <div class="control-group">
            <label>
                In welke zin heeft {$currentUser.firstname} {$currentUser.lastname} bijgedragen aan het success van de organisatie?
            </label>
            <textarea class="input-xxlarge">

            </textarea>
        </div>

        <div class="form-actions">
            <button type="button" class="btn" onClick="history.go(-1);return true;">Previous</button>
            <button type="submit" class="btn btn-primary">Submit</button>
        </div>
    </form>
</div>