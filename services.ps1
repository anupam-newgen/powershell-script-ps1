$_session = &".\connectToVM.ps1"
$_todayDate = Get-Date -Format "yyyy-MM-dd"

function Copy-File () {
    param (
        $ParameterName
    )
    <#$_fileNameList = $ParameterName[0]
    $_destination = $ParameterName[1]
    $_backupFolderPath = $ParameterName[2]
    $_options = $ParameterName[3]
    $_sourceList = $ParameterName[4]#>
    $_filePathList = New-Object System.Collections.ArrayList
    $_backupFilePathList = New-Object System.Collections.ArrayList
    foreach ($_file in $ParameterName[0]) {
        $_filePath = $_filePathList.Add($ParameterName[1] + $_todayDate + "/" + $_file)
        $_backupFilePath = $_backupFilePathList.Add($ParameterName[2] + $_todayDate + "/" + $_file)
    }
    $_backupFolder = $ParameterName[2]
    $_currentBackupFolder = $ParameterName[2] + $_todayDate
    $_currentDestinationFolder = $ParameterName[1] + $_todayDate
    $_res = Invoke-Command -Session $_session -FilePath .\checkFile.ps1 -ArgumentList $ParameterName[3], $_filePathList, $_backupFolder, $_backupFilePathList, $_currentBackupFolder, $_currentDestinationFolder
    $_res
    Invoke-Command -Session $_session -FilePath .\checkFile.ps1 -ArgumentList $ParameterName[3], $_filePathList, $_backupFolder, $_backupFilePathList, $_currentBackupFolder, $_currentDestinationFolder
    Add-Content -Path $_logs $_res
    Add-Content -Path $_logs "Copy Started"
    "Copy Started"
    $_currentDestination = $ParameterName[1] + $_todayDate
    foreach ($_file in $ParameterName[4]) {
        Copy-Item -ToSession $_session -Path $_file -Destination $_currentDestination
    }
    Add-Content -Path $_logs "Copy Done"
    Add-Content -Path $_logs "File updated"
    "Copy Done"
    "File updated"
}

function Execute-SQL {
    param (
        $ParameterName
    )
    <#$_filenameList = $ParameterName[0]
    $_destination = $ParameterName[1]
    $_backupFolderPath = $ParameterName[2]
    $_options = $ParameterName[3]
    $_sourceList = $ParameterName[4]
    $_timestamp = $ParameterName[5]
    $_sqlServerInstance = $ParameterName[6]
    $_sqlServerUserName = $ParameterName[7]
    $_sqlServeruserPassword = $ParameterName[8]
    $_databaseName = $ParameterName[9]#>
    $_destinationFolderPath = $ParameterName[1] + $_todayDate + "/" + $ParameterName[5] + "/"
    $_res = Invoke-Command -Session $_session -FilePath .\checkFile.ps1 -ArgumentList $ParameterName[3] ,$_destinationFolderPath
    Add-Content -Path $_logs $_res
    Add-Content -Path $_logs "Copy Started"
    "Copy Started"
    foreach ($_file in $ParameterName[4]) {
        Copy-Item -ToSession $_session -Path $_file -Destination $_destinationFolderPath
    }
    Add-Content -Path $_logs "Copy Done"
    Add-Content -Path $_logs "Execution of SQL Query Started"
    "Copy Done"
    "Execution of SQL Query Started"
    Invoke-Command -Session $_session -FilePath .\startService.ps1 -ArgumentList "MSSQLSERVER"
    $_tempQueryLogs = Invoke-Command -Session $_session -FilePath .\sqlQuery.ps1 -ArgumentList $ParameterName[0], $ParameterName[5], $ParameterName[6], $ParameterName[7], $ParameterName[8], $ParameterName[9], $_destinationFolderPath
    Add-Content -Path $_logs $_tempQueryLogs
}

function Deploy-WAR {
    param (
        $ParameterName
    )
    <#$_fileName = $ParameterName[0]
    $_JBOSSServerPath = $ParameterName[1]
    $_backupFolderPath = $ParameterName[2]
    $_options = $ParameterName[3]
    $_source = $ParameterName[4]#>
    $_filePath = $ParameterName[1] + $ParameterName[0]
    $_backupFolder = $ParameterName[2]
    $_backupFilePath = $ParameterName[2] + $_todayDate + "/" + $ParameterName[0]
    $_currentBackupFolder = $ParameterName[2] + $_todayDate
    $_JBOSSServerLogPathArray = $ParameterName[1].Split("{/}")
    $_JBOSSServerLogPathArrayLength = $_JBOSSServerLogPathArray.length - 2
    $_JBOSSServerLogPath = ""
    for ($_start = 0; $_start -lt $_JBOSSServerLogPathArrayLength; $_start++) {
        $_JBOSSServerLogPath = $_JBOSSServerLogPath + $_JBOSSServerLogPathArray[$_start] + "/"
    }
    $_JBOSSServerLogPath = $_JBOSSServerLogPath + "log/server.log"
    $_res = Invoke-Command -Session $_session -FilePath .\checkFile.ps1 -ArgumentList $ParameterName[3], $_filePath, $ParameterName[2], $_backupFilePath, $_currentBackupFolder
    Add-Content -Path $_logs $_res
    Invoke-Command -Session $_session -ScriptBlock { param($p1)
        $_serverLogsPath = $p1
        $_job = Start-Job -ScriptBlock { param($p2)
            Get-Content $_serverLogsPath -Wait -Tail 1 | Add-Content -Path C:\CopyToFile.txt;
        } -ArgumentList $_serverLogsPath
    } -ArgumentList $_JBOSSServerLogPath
    <#Invoke-Command -Session $_session -ScriptBlock {$_job = Start-Job -ScriptBlock {$_serverLogsPath = "C:\Users\AdityaVPC\EAP-7.3.0\standalone\log\server.log"; Get-Content $_serverLogsPath -Wait -Tail 1 | Add-Content -Path C:\CopyToFile.txt;}}#>
    $_childJob = Invoke-Command -Session $_session -ScriptBlock {$_job}
    Add-Content -Path $_logs "WAR file copy started"
    "WAR file copy started"
    Copy-Item -ToSession $_session -Path $ParameterName[4] -Destination $ParameterName[1]
    Add-Content -Path $_logs "WAR file copy successful"
    "WAR file copy successful"
    $_tempWarLogs = Invoke-Command -Session $_session -FilePath .\warFileExecution.ps1 -ArgumentList $ParameterName[1], $ParameterName[0], $_childJob, $ParameterName[2], $_JBOSSServerLogPath
    Add-Content -Path $_logs $_tempWarLogs
}