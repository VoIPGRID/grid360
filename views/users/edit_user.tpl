<div class="container">
    <form action="{$admin_uri}/user/submit" method="POST" class="form-horizontal">
        <fieldset>
            <legend>New user</legend>

            <div class="control-group">
                <input type="hidden" name="type" value="user" />
                <input type="hidden" name="id" value="{$user.id}" />
                <label class="control-label" for="firstName">First name</label>

                <div class="controls">
                    <input id="firstName" name="firstname" type="text" placeholder="First name" class="input-large" value="{$user.firstname}" />
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="lastName">Last name</label>

                <div class="controls">
                    <input id="lastName" name="lastname" type="text" placeholder="Last name" class="input-large" value="{$user.lastname}" />
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="email">Email</label>

                <div class="controls">
                    <input id="email" name="email" type="text" placeholder="example@email.com" class="input-large" value="{$user.email}" />
                </div>
            </div>

            <div class="control-group">
                <input type="hidden" name="department[type]" value="department" />
                <label class="control-label">Department</label>

                <div class="controls">
                    {html_options name="department[id]" options=$depOptions selected=$user.department.id}
                </div>
            </div>

            <div class="control-group">
                <input type="hidden" name="role[type]" value="role" />
                <label class="control-label">Role</label>

                <div class="controls">
                    {html_options name="role[id]" options=$roleOptions selected=$user.role.id}
                </div>
            </div>

            <div class="control-group">
                <input type="hidden" name="userlevel[type]" value="userlevel" />
                <label class="control-label">User level</label>

                <div class="controls">
                    {html_options name="userlevel[id]" options=$userLevelOptions|capitalize selected={$user.userlevel}}
                </div>
            </div>

            <div class="control-group">
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Update user</button>
                    <button type="button" class="btn" onClick="history.go(-1);return true;">Cancel</button>
                </div>
            </div>

        </fieldset>
    </form>
</div>
