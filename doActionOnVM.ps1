.".\services.ps1"
$_logs = ".\abc.txt"
$_logDate = Get-Date
Write-Host $_logDate
Add-Content -Path $_logs $_logDate
$_filename = $global:config.FileName
$_sourcePath = $global:config.SourcePath
$_source = $_sourcePath + $_filename
$_destination = $global:config.Destination
$_jbossServerLocation = $global:config.JBossServerPath
$_timestamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }
$_extension = $_filename.Split("{.}")[-1]
if ($_session) {
    Write-Host "Authentication Done"
    Write-Host "Remote Session Started"
    Add-Content -Path $_logs "Authentication Done"
    Add-Content -Path $_logs "Remote Session Started"
    Write-Host "1.Copy File 2.Run SQL Query 3.Deploy WAR file on JBOSS"
    $_options = Read-Host "Select the option"
    Invoke-Command -Session $_session -FilePath .\stopService.ps1 -ArgumentList $global:config.ServiceName
    $_totalFiles = $_filename.length
    $_check = "True"
    $_source = New-Object System.Collections.ArrayList
    foreach($_file in $_filename) {
        $_temp = $_source.Add($_sourcePath + $_file)
        if (Test-Path $_source[$_temp]) {
            $_check = "True"
        } else {
            $_check = "False"
            break
        }
    }
    if ($_check -eq "True") {
        if ($_options -eq 1) {
            Add-Content -Path $_logs "Copy-File on VM"
            Copy-File -ParameterName $global:config.FileName, $global:config.Destination, $global:config.BackupFolderPath, $_options, $_source
        }
        elseif ($_options -eq 2 -and $_extension -eq "sql") {
            # Execute-SQL on VM
            Add-Content -Path $_logs "Execute-SQL on VM"
            Execute-SQL -ParameterName $global:config.FileName, $global:config.Destination, $global:config.BackupFolderPath,$_options , $_source, $_timestamp, $global:config.SQLServerInstance, $global:config.SQLServerUserName, $global:config.SQLServerPassword, $global:config.DatabaseName
        }
        elseif ($_options -eq 3 -and $_extension -eq "war") {
            # Deploy-WAR on VM
            Add-Content -Path $_logs "Deploy-WAR on VM"
            Deploy-WAR -ParameterName $global:config.FileName, $global:config.JBossServerPath, $global:config.BackupFolderPath, $_options, $_source
        }
        else {
            Add-Content -Path $_logs "Either invalid file or invalid option selected"
            "Either invalid file or invalid option selected"
        }
    }
    else {
        Add-Content -Path $_logs "File not found"
        Write-Error "File not found"
    }
    Invoke-Command -Session $_session -FilePath .\startService.ps1 -ArgumentList $global:config.ServiceName
    Add-Content -Path $_logs "Remote Session Ended"
    "Remote Session Ended"
    Remove-PSSession -Session $_session
}
else {
    Add-Content -Path $_logs "The credential is invalid"
    Write-Error "The credential is invalid"
}

# log File handling

if (Test-Path .\Logs) {
    "Logs folder not created"
} else {
    "Logs folder created"
    mkdir .\Logs
}
$_todayDate = Get-Date -Format "dd-MM-yyyy"
$_value = Get-Content -Path .\abc.txt
Add-Content -Path .\Logs\$_todayDate".txt" -Value $_value
Remove-Item .\abc.txt