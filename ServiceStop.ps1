$serviceName = "Print Spooler"
$service = Get-Service $serviceName

if ($service.Status -eq "Running") {
    Stop-Service -Name $serviceName
    Write-Host "$service service stopped"
} else {
    Write-Host "$service already stopped"
}


