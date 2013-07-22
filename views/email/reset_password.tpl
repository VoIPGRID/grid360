{t firstname={$user.firstname} lastname={$user.lastname}}Dear %1 %2,{/t}
<br />
<br />
{t}A password reset was requested for your GRID360 account.{/t}<br />
{capture name="link"}
    <a href="{$smarty.server.HTTP_HOST}/{$smarty.const.BASE_URI}reset?uuid={$reset_password_id}&email={$user.email}">{t}click here{/t}</a>
{/capture}

{assign "text" "{t escape=no link=$smarty.capture.link}Please %1 to reset your password.{/t}"}
{$text|ucfirst}