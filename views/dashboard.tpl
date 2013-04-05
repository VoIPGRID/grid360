<html>
	<head>
		<title>Welcome</title>
        {literal}
            <script type="text/javascript" src="https://www.google.com/jsapi"></script>
            <script type="text/javascript">
                google.load("visualization", "1", {packages:["corechart"]});
                google.setOnLoadCallback(drawChart);
                function drawChart() {
                    var data = google.visualization.arrayToDataTable([
                        ['Date', 'Average', 'Self'],
                        ['January \'13', 6.7, 6.9],
                        ['July \'13',  7.2, 7.1],
                        ['January \'14', 6.9, 7.0],
                        ['July \'14', 7.2, 7.1]
                    ]);

                    var options = {
                        title: 'Previous reviews',
                        chartArea:{left:30},
                        fontSize: 9
                    };

                    var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
                    chart.draw(data, options);
                }
            </script>
        {/literal}
	</head>
	<body>
        <div class="container">
            <div class="page-header"><h1>Dashboard</h1></div>
            <div class="row">
            <div class="span5">
                <br>
                <h4>Review status</h4>
                <table class = "table table-striped">
                    <th>Name</th> <th>Role</th> <th>Status</th>
                    {foreach $users as $user}
                        <tr><td>{$user.firstname} {$user.lastname}</td><td>{$user.role.name}</td><td>Pending</td></tr>
                    {/foreach}
                </table>
            </div>

            <div class="span4 offset3">
                <table class = "table table-striped">
                    <br>
                    <h4>Reports</h4>
                    <th>Date</th> <th></th>
                    <tr><td>January '13</td><td><a href="#">View</a></td></tr>
                    <tr><td>July '13</td><td><a href="#">View</a></td></tr>
                    <tr><td>January '14</td><td><a href="#">View</a></td></tr>
                    <tr><td>July '14</td><td><a href="#">View</a></td></tr>
                    <tr><td>January '15</td><td>In progress</td></tr>
                </table>

                <div id="chart_div" style="width: 350px; height: 175px;"></div>
            </div>
            </div>
        </div>
	</body>
</html>