$_session = &".\connectToVM.ps1"
$_filename = $global:config.FileName
$_sourcePath = $global:config.SourcePath
$_source = $_sourcePath + $_filename
$_destination = $global:config.Destination
if ($_session) {
    Write-Host "Authentication Done"
    Write-Host "Remote Session Started"
    Invoke-Command -Session $_session -FilePath .\stopService.ps1 -ArgumentList $global:config.ServiceName
    if (Test-Path $_source) {
        Invoke-Command -Session $_session -FilePath .\checkFile.ps1 -ArgumentList $global:config.FileName, $global:config.Destination, $global:config.BackupFolderPath
        "Copy Started"
        Copy-Item -ToSession $_session -Path $_source -Destination $_destination
        "Copy Done"
        "File updated"        
    }
    else {
        Write-Error "File not found"
    }
    Invoke-Command -Session $_session -FilePath .\startService.ps1 -ArgumentList $global:config.ServiceName
    "Remote Session Ended"
}
else {
    Write-Error "The credential is invalid"
}