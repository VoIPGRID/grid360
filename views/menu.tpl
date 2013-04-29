{function check_active extra_css_classes=""}
    {if $requestUri eq $BASE_URI && $SERVER_REQUEST_URI eq $requestUri}
        class="active{$extra_css_classes}"
    {elseif strpos($SERVER_REQUEST_URI, "$BASE_URI$requestUri") === 0}
        class="active{$extra_css_classes}"
    {elseif isset($extra_css_classes)}
        class="{$extra_css_classes|replace:' ':''}"
    {/if}
{/function}

<div class="container">
    <div class="navbar">
        <div class="navbar-inner">
            <a class="brand" href="//www.voipgrid.nl"><img class="logo" src="{$ASSETS_URI}images/logo.png" /></a>
            <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                <span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span>
            </a>

            <div class="nav-collapse collapse">
                <ul class="nav">
                    <li {check_active requestUri={$BASE_URI}}><a href="{$BASE_URI}"><i class="icon-home"></i> Dashboard</a></li>
                    <li {check_active requestUri="report"}><a href="{$BASE_URI}report"><i class="icon-file-alt"></i> Report</a></li>
                    <li {check_active requestUri="feedback"}><a href="{$BASE_URI}feedback"><i class="icon-bullhorn"></i> Feedback</a></li>
                </ul>
                <ul class="nav pull-right">
                    <li {check_active requestUri="admin" extra_css_classes=" dropdown"}>
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown"> <i class="icon-wrench"></i> Admin <b class="caret"></b> </a>

                        <ul class="dropdown-menu">
                            <li><a href="{$ADMIN_URI}departments">Departments</a></li>
                            <li><a href="{$ADMIN_URI}users">Users</a></li>
                            <li><a href="{$MANAGER_URI}roles">Roles</a></li>
                            <li><a href="{$MANAGER_URI}competencies">Competencies</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>
