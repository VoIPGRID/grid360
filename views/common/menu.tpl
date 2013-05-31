{function check_active extra_css_classes=""}
    {if $request_uri == $smarty.const.BASE_URI && $SERVER_REQUEST_URI == $request_uri}
        class="active{$extra_css_classes}"
    {elseif strpos($SERVER_REQUEST_URI, "{$smarty.const.BASE_URI}$request_uri") === 0}
        class="active{$extra_css_classes}"
    {elseif isset($extra_css_classes)}
        class="{$extra_css_classes|replace:' ':''}"
    {/if}
{/function}
<div class="container">
    <div class="navbar">
        <div class="navbar-inner">
                <a class="brand" href="//www.voys.nl" target="_blank"><img class="logo" src="{$smarty.const.ASSETS_URI}images/logo_voys.png" /></a>
            <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                <span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span>
            </a>

            <div class="nav-collapse collapse">
                <ul class="nav">
                    <li {check_active request_uri={$smarty.const.BASE_URI}}><a href="{$smarty.const.BASE_URI}"><i class="icon-home"></i> Dashboard</a></li>
                    <li {check_active request_uri="report"}><a href="{$smarty.const.BASE_URI}report"><i class="icon-file-alt"></i> {$smarty.const.MENU_ITEM_REPORT}</a></li>
                    <li {check_active request_uri="feedback"}><a href="{$smarty.const.BASE_URI}feedback"><i class="icon-bullhorn"></i> Feedback</a></li>
                </ul>
                <ul class="nav pull-right">
                    {if $current_user.userlevel.level == $smarty.const.ADMIN || $current_user.userlevel.level == $smarty.const.MANAGER}
                        {if $current_user.userlevel.level == $smarty.const.ADMIN}
                            {$dropdown_text = "Admin"}
                        {else}
                            {$dropdown_text = "Manager"}
                        {/if}
                        <li {check_active request_uri="admin" extra_css_classes=" dropdown"}>
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown"> <i class="icon-wrench"></i> {$dropdown_text} <b class="caret"></b> </a>

                            <ul class="dropdown-menu">
                                {if $current_user.userlevel.id == $smarty.const.ADMIN}
                                    <li><a href="{$smarty.const.ADMIN_URI}departments">{$smarty.const.MENU_ITEM_DEPARTMENTS}</a></li>
                                    <li><a href="{$smarty.const.ADMIN_URI}users">{$smarty.const.MENU_ITEM_USERS}</a></li>
                                {/if}
                                <li><a href="{$smarty.const.MANAGER_URI}roles">{$smarty.const.MENU_ITEM_ROLES}</a></li>
                                <li><a href="{$smarty.const.MANAGER_URI}competencies">{$smarty.const.MENU_ITEM_COMPETENCIES}</a></li>
                                {if $current_user.userlevel.id == $smarty.const.ADMIN}
                                    <li class="divider"></li>
                                    <li><a href="{$smarty.const.ADMIN_URI}rounds">{$smarty.const.MENU_ITEM_ROUNDS}</a></li>
                                {/if}
                            </ul>
                        </li>
                    {/if}
                    <li><a href="{$smarty.const.BASE_URI}logout">Logout</a></li>
                </ul>
            </div>
        </div>
    </div>
</div>
