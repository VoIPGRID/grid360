<div class="container">
    <form action="{$manager_uri}/competency/submit" method="POST" class="form-horizontal">
        <fieldset>
            <legend>New competency</legend>

            <div class="control-group">
                <input type="hidden" name="type" value="competency" />
                <label class="control-label" for="competencyName">Competency name</label>

                <div class="controls">
                    <input id="competencyName" name="name" type="text" placeholder="Competency name" class="input-large" />
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="competencyDescription">Competency description</label>

                <div class="controls">
                    <input id="competencyDescription" name="description" type="text" placeholder="Competency name" class="input-large" />
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">Competency group</label>
                <input type="hidden" name="competencygroup[type]" value="competencygroup" />

                <div class="controls">
                    {if isset($groupOptions) && count($groupOptions) >= 1}
                        {html_options name="competencygroup[id]" options=$groupOptions}
                    {else}
                        No competency groups found
                        <input type="hidden" name="competencygroup[id]" value=" " />
                    {/if}
                </div>
            </div>

            <div class="control-group">
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Create competency</button>
                    <button type="button" class="btn" onClick="history.go(-1);return true;">Cancel</button>
                </div>
            </div>
        </fieldset>
    </form>
</div>