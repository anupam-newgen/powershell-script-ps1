$deploymentDir = "C:\TestDeployment"
$BackupDeploymentDir = "C:\TestDeployment_Backup\$((Get-Date).ToString('yyyy-MM-dd HHmm'))"

New-Item -ItemType Directory -Path $BackupDeploymentDir

Copy-Item -Path "$deploymentDir\*" -Destination "$BackupDeploymentDir" -Recurse

return $deploymentDir