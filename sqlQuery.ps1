$_queryLogs = ""
$_timestamp = $args[1]
$_sqlServerInstance = $args[2]
$_destination = $args[6]
$_sqlUserName = $args[3]
$_sqlPassword = $args[4]
$_sqlDatabase = $args[5]
$_sqlFileName = $args[0]
#$_logsFileNameList = $args[0].Split("{.}")[0]+".rpt"
#$_sqlFilePath = $_destination + $_sqlFileName
#$_logsFilePath = $_destination + $_logsFileName
"SQL Query"
<#$_timestamp
$_sqlServerInstance
$_destination
$_sqlUserName
$_sqlPassword
$_sqlDatabase#>
$_sqlFileNameList = New-Object System.Collections.ArrayList
$_logsFileNameList = New-Object System.Collections.ArrayList
$_sqlFilePathList = New-Object System.Collections.ArrayList
$_logsFilePathList = New-Object System.Collections.ArrayList
$_start = 0
foreach ($_file in $_sqlFileName) {
    $_tempSQL = $_sqlFileNameList.Add($_file)
    $_tempLogs = $_logsFileNameList.Add($_file.Split("{.}")[0]+".rpt")
    $_tempSQLPath = $_sqlFilePathList.Add($_destination + $_sqlFileNameList[$_start])
    $_tempLogsPath = $_logsFilePathList.Add($_destination + $_logsFileNameList[$_start])
    $_start++
}
<#$_sqlFileNameList
$_logsFileNameList
$_sqlFilePathList
$_logsFilePathList#>
Import-Module "sqlps" -DisableNameChecking
Set-ExecutionPolicy Unrestricted
$Error.Clear()
if (($_sqlUserName -eq "" -and $_sqlPassword -eq "") -or ($_sqlUserName -eq $null -and $_sqlPassword -eq $null)) {
    if ($_sqlDatabase -eq "" -or $_sqlDatabase -eq $null) {
        $_start = 0
        foreach($_tempSQLFilePath in $_sqlFilePathList) {
            Invoke-Sqlcmd -ServerInstance $_sqlServerInstance -InputFile $_tempSQLFilePath | Out-File -FilePath $_logsFilePathList[0]
            $_start++
        }
    } else {
        $_start = 0
        foreach($_tempSQLFilePath in $_sqlFilePathList) {
            Invoke-Sqlcmd -ServerInstance $_sqlServerInstance -Database $_sqlDatabase -InputFile $_tempSQLFilePath | Out-File -FilePath $_logsFilePathList[0]
            $_start++
        }
    }
} else {
    if ($_sqlDatabase -eq "" -or $_sqlDatabase -eq $null) {
        $_start = 0
        foreach($_tempSQLFilePath in $_sqlFilePathList) {
            Invoke-SQLCmd -ServerInstance $_sqlServerInstance -Username $_sqlUserName -Password $_sqlPassword -InputFile $_tempSQLFilePath | Out-File -FilePath $_logsFilePathList[0]
            $_start++
        }
    } else {
        $_start = 0
        foreach($_tempSQLFilePath in $_sqlFilePathList) {
            Invoke-SQLCmd -ServerInstance $_sqlServerInstance -Database $_sqlDatabase -Username $_sqlUserName -Password $_sqlPassword -InputFile $_tempSQLFilePath | Out-File -FilePath $_logsFilePathList[0]
            $_start++
        }
    }
}

if ($Error.Count -gt 0) {
    Out-File -FilePath $_logsFilePath -InputObject $Error
    $_queryLogs = $_queryLogs + "Error occured while executing the Query `n"
    Write-Host "Error occured while executing the Query"
} else {
    $_queryLogs = $_queryLogs + "SQL Query Execution Done `n"
    Write-Host "SQL Query Execution Done"
}

return $_queryLogs