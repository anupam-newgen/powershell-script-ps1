$result = Get-Service -Name $args[0]
if ($result.Status -eq "Running") {
	Stop-Service -Name $args[0]
	$args[0] + " Service Stoped"
}
else {
	$args[0] + " Service already not running"
}