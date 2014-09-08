{t firstname=$user.firstname lastname=$user.lastname}Dear %1 %2{/t},
<br />
<br />
{capture name="link"}
    <a href="{$smarty.server.HTTP_HOST}{$smarty.const.BASE_URI}">{t}Click here{/t}</a>
{/capture}

{assign "text" "{t escape=no link=$smarty.capture.link}Someone in your organisation started a feedback round. %1 to go to GRID360 and start reviewing.{/t}"}
{$text nofilter}