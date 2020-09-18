$_session = &".\connectToVM.ps1"
$_filename = $global:config.FileName
$_sourcePath = $global:config.SourcePath
$_source = $_sourcePath + $_filename
$_destination = $global:config.Destination
$_timestamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }
if ($_session) {
    Write-Host "Authentication Done"
    Write-Host "Remote Session Started"
    Write-Host "1. Copy File 2. Run SQL Query"
    $_options = Read-Host "Select the option"
    Invoke-Command -Session $_session -FilePath .\stopService.ps1 -ArgumentList $global:config.ServiceName
    if (Test-Path $_source) {
        if ($_options -eq 1) {
            Invoke-Command -Session $_session -FilePath .\checkFile.ps1 -ArgumentList $global:config.FileName, $global:config.Destination, $global:config.BackupFolderPath
            "Copy Started"
            Copy-Item -ToSession $_session -Path $_source -Destination $_destination
            "Copy Done"
            "File updated"
        }
        if ($_options -eq 2) {
            "Copy Started"
            Copy-Item -ToSession $_session -Path $_source -Destination $_destination$_timestamp".sql"
            "Copy Done"
            "File updated"
            "Execution of SQL Query Started"
            Invoke-Command -Session $_session -FilePath .\startService.ps1 -ArgumentList "MSSQLSERVER"
            Invoke-Command -Session $_session -FilePath .\sqlQuery.ps1 -ArgumentList $_timestamp, $global:config.SQLServerInstance
        }
    }
    else {
        Write-Error "File not found"
    }
    Invoke-Command -Session $_session -FilePath .\startService.ps1 -ArgumentList $global:config.ServiceName
    "Remote Session Ended"
    Remove-PSSession -Session $_session
}
else {
    Write-Error "The credential is invalid"
}