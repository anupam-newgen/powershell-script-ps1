$serviceName = "Print Spooler"
$service = Get-Service $serviceName

if ($service.Status -eq "Stopped") {
    Start-Service -Name $serviceName
    Write-Host "$service service started"
} else {
    Write-Host "$service already running"
}


