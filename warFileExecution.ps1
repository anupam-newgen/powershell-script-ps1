$_warLogs = ""
$_jbossServerPath = $args[0]
$_fileName = $args[1]
$_job = $args[2]
$_backupfile = $args[3] + $args[1]
$_serverLogsPath = $args[4]
$_source = $_jbossServerPath + $_filename + ".deployed"
#$_source
$_checkDeployedFile = Test-Path $_source
#$_checkDeployedFile
$_warLogs = $_warLogs + "Deploying... `n"
"Deploying..."
while (!$_checkDeployedFile) {
    $_checkDeployedFile = Test-Path $_source
}
$_warLogs = $_warLogs + "Deployed Successfully `n"
"Deployed Successfully"
#$_job
Stop-Job -Id $_job.Id
Get-Content $_serverLogsPath -Tail 2 | Add-Content -Path C:\CopyToFile.txt
$_logsResult = Get-Content -Path "C:\CopyToFile.txt"
$_logsResult
$_warLogs = $_warLogs + $_logsResult + "`n"
$_logsResult = $_logsResult | Where-Object {$_ -like ‘*ERROR*’}
if ($_logsResult -eq $null) {
    $_warLogs = $_warLogs + "Backup not required `n"
    "Backup not required"
} else {
    $_warLogs = $_warLogs + "Backup required `n"
    "Backup required"
    Move-Item -Path $_backupfile -Destination $_jbossServerPath
}
Remove-Item C:\CopyToFile.txt

return $_warLogs