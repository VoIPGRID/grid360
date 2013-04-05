<script type="text/javascript" src="{$base_uri}lib/js/add_competency.js"></script>

<div class="container">
    <form action="{$manager_uri}/competencygroup/submit" method="POST" class="form-horizontal">
        <fieldset>
            <div id="legend">
                <legend class="">Edit competency group</legend>
            </div>

            <div class="control-group">
                <input type="hidden" name="type" value="competencygroup">
                <input type="hidden" name="id" value={$competencygroup.id}>
                <label class="control-label" for="groupName">Group name</label>
                <div class="controls">
                    <input id="groupName" name="name" type="text" placeholder="Group name" class="input-large" value={$competencygroup.name}>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="groupDescription">Group description</label>
                <div class="controls">
                    <input id="groupDescription" name="description" type="text" placeholder="Group description" class="input-large" value={$competencygroup.description}>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">Role</label>
                <input type="hidden" name="role[id]" value={$competencygroup.role.id} />
                <input type="hidden" name="role[type]" value="role" />
                <div class="controls">
                    {html_options name="role[id]" options=$roleOptions selected=$competencygroup.role.id}
                </div>
            </div>

            <div class="control-group">
                <input type="hidden" name="ownCompetencies[0][type]" value="competency">
                <label id="competencyLabel" class="control-label">Competencies</label>
                <div class="controls" id="competencyList">
                    {foreach $competencygroup.ownCompetency as $competency}
                        <input type="hidden" name="ownCompetencies[0][type]" value="competency">
                        <div>
                            <label></label>
                            <input id="name" name="ownCompetencies[0][name]" type="text" placeholder="Role name" class="input-large" value="{$competency.name}">
                            <textarea id="description" name="ownCompetencies[0][description]" type="text" placeholder="Role description" style="width:300px;">{$competency.description}</textarea>
                        </div>
                    {/foreach}
                </div>
            </div>

            <div class="control-group">
                <div class="controls">
                    <a id="addCompetencyButton" href="javascript:add_competency();"><strong>+</strong> Add competency</a>
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