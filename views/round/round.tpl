<script type="text/javascript" src="{$ASSETS_URI}js/base.js"></script>

<form action="{$ADMIN_URI}round/submit" method="post" class="form-horizontal">
    <fieldset>
        <legend>Create round</legend>

        <div class="control-group">
            {if isset($round)}
                <input type="hidden" name="id" value={$round.id} />
            {/if}
            <input type="hidden" name="type" value="round" />
            <label class="control-label" for="round-description">Round description</label>

            <div class="controls">
                <textarea id="round-description" name="description" type="text" placeholder="Round description" class="input-xlarge">{if isset($round)}{$round.description}{/if}</textarea>
            </div>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-primary">
                {if $update}
                    Update round
                {else}
                    Create round
                {/if}
            </button>
            <button type="button" class="btn" onclick="history.go(-1);return true;">Cancel</button>
        </div>
    </fieldset>
</form>
