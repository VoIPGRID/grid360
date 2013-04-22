<script type="text/javascript" src="{$base_uri}assets/js/add_competency.js"></script>

<div class="container">
    <form action="{$manager_uri}/competencygroup/submit" method="POST" class="form-horizontal">
        <fieldset>
            <legend>Edit competency group</legend>

            <div class="control-group">
                <input type="hidden" name="type" value="competencygroup" />
                <input type="hidden" name="id" value={$competencygroup.id} />

                <label class="control-label" for="groupName">Group name</label>

                <div class="controls">
                    <input id="groupName" name="name" type="text" placeholder="Group name" class="input-large" value="{$competencygroup.name}" />
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="groupDescription">Group description</label>

                <div class="controls">
                    <input id="groupDescription" name="description" type="text" placeholder="Group description" class="input-large" value="{$competencygroup.description}" />
                </div>
            </div>

            <div class="control-group">
                <input type="hidden" name="role[id]" value={$competencygroup.role.id} />
                <input type="hidden" name="role[type]" value="role" />
                <label class="control-label">Role</label>

                <div class="controls">
                    {html_options name="role[id]" options=$roleOptions selected=$competencygroup.role.id}
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">Competencies</label>

                <div id="competencyList">
                    {assign "index" 0}
                    {foreach $competencygroup.ownCompetency as $competency}
                        <div class="controls">
                            <input type="hidden" name="ownCompetencies[{$index}][type]" value="competency" />
                            <input type="hidden" name="ownCompetencies[{$index}][id]" value={$competency.id} />
                            <input name="ownCompetencies[{$index}][name]" type="text" placeholder="Role name" class="input-xlarge" value="{$competency.name}" />
                            <textarea name="ownCompetencies[{$index}][description]" type="text" placeholder="Competency description" class="input-xxlarge">{$competency.description}</textarea>
                        </div>
                        {assign "index" {counter}}
                    {/foreach}
                </div>
            </div>

            <div class="control-group">
                <div class="controls">
                    <button class="btn btn-link"><strong>+</strong> Add competency</button>
                </div>
            </div>

            <div class="control-group">
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Create competency group</button>
                    <button type="button" class="btn" onClick="history.go(-1);return true;">Cancel</button>
                </div>
            </div>
        </fieldset>
    </form>
</div>