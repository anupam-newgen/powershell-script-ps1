$result = Get-Service -Name $args[0]
if ($result.Status -eq "Stopped") {
	Start-Service -Name $args[0]
	$args[0] + " Service Started"
}
else {
	$args[0] + " already running"
}