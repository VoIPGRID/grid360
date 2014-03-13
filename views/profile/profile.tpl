{include file="lib/functions.tpl"}

<script type="text/javascript">
    type = 'agreement';
    name_placeholder = '{t}Agreement name{/t}';
    description_placeholder = '{t}Agreement description{/t}';
</script>
<script type="text/javascript" src="{$smarty.const.BASE_URI}assets/js/add_row.js"></script>

<form action="{$smarty.const.BASE_URI}profile" method="POST" class="form-horizontal" data-persist="garlic">
    <fieldset>
        <legend>{t}Updating profile{/t}</legend>

        <div class="control-group {if isset($form_values.firstname.error)}error{/if}">
            <input type="hidden" name="type" value="user" />
            {if isset($form_values.id.value)}
                <input type="hidden" name="id" value="{$form_values.id.value}" />
            {/if}

            <label class="control-label" for="firstname">{t}First name{/t}</label>

            <div class="controls">
                <input id="firstname" name="firstname" type="text" placeholder="{t}First name{/t}" class="input-large" required value="{$form_values.firstname.value}" />
                {call check_if_error var_name="firstname"}
            </div>
        </div>

        <div class="control-group {if isset($form_values.lastname.error)}error{/if}">
            <label class="control-label" for="lastname">{t}Last name{/t}</label>

            <div class="controls">
                <input id="lastname" name="lastname" type="text" placeholder="{t}Last name{/t}" class="input-large" required value="{$form_values.lastname.value}" />
                {call check_if_error var_name="lastname"}
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="email">{t}Email{/t}</label>

            <div class="controls">
                <input type="text" class="input-large" value="{$form_values.email.value}" disabled />
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">{t}Department{/t}</label>

            <div class="controls">
                <input type="text" class="input-large" value="{$form_values.department.value}" disabled />
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">{t}Role{/t}</label>

            <div class="controls">
                <input type="text" class="input-large" value="{$form_values.role.value}" disabled />
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="work_agreements">{t}Work agreement(s){/t}</label>

            <div class="controls">
                <textarea id="work_agreements" name="work" placeholder="{t}Work agreement(s){/t}" class="input-xxlarge">{$form_values.work.value}</textarea>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="training_agreements">{t}Training agreement(s){/t}</label>

            <div class="controls">
                <textarea id="training_agreements" name="training" placeholder="{t}Training agreement(s){/t}" class="input-xxlarge">{$form_values.training.value}</textarea>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="other_agreements">{t}Other agreement(s){/t}</label>

            <div class="controls">
                <textarea id="other_agreements" name="other" placeholder="{t}Other agreement(s){/t}" class="input-xxlarge">{$form_values.other.value}</textarea>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="personal_goals">{t}Personal goals{/t}</label>

            <div class="controls">
                <textarea id="personal_goals" name="goals" placeholder="{t}Personal goals{/t}" class="input-xxlarge">{$form_values.goals.value}</textarea>
            </div>
        </div>

        <div class="form-actions">
            <a href="{$smarty.const.BASE_URI}" class="btn">{t}Cancel{/t}</a>
            <button type="submit" class="btn btn-primary">
                {t}Update profile{/t}
            </button>
        </div>
    </fieldset>
</form>
