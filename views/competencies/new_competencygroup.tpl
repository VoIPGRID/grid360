<script type="text/javascript" src="{$base_uri}assets/js/add_competency.js"></script>

<div class="container">
    <form action="{$manager_uri}/competencygroup/submit" method="POST" class="form-horizontal">
        <fieldset>
            <legend>New competency group</legend>

            <div class="control-group">
                <input type="hidden" name="type" value="competencygroup" />
                <label class="control-label" for="groupName">Group name</label>

                <div class="controls">
                    <input id="groupName" name="name" type="text" placeholder="Group name" class="input-large" />
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="groupDescription">Group description</label>

                <div class="controls">
                    <input id="groupDescription" name="description" type="text" placeholder="Group description" class="input-large" />
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">Role</label>
                <input type="hidden" name="role[type]" value="role" />

                <div class="controls">
                    {html_options name="role[id]" options=$roleOptions}
                </div>
            </div>

            <div class="control-group">
                <label id="competencyLabel" class="control-label">Competencies</label>

                <div id="competencyList">
                    <div class="controls" >
                        <input type="hidden" name="ownCompetencies[0][type]" value="competency" />
                        <input name="ownCompetencies[0][name]" type="text" placeholder="Competency name" class="input-xlarge" />
                        <textarea class="input-xxlarge" name="ownCompetencies[0][description]" type="text" placeholder="Competency description"></textarea>
                    </div>
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