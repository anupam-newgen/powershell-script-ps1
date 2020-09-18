$_timestamp = $args[0]
$_sqlServerInstance = $args[1]
$_sqlFileName = $_timestamp+".sql"
$_logsFileName = $_timestamp+".rpt"
$_sqlPath = 'C:\qwerty\query.sql'
$_sqlUserName = $args[2]
$_sqlPassword = $args[3]
$_sqlDatabase = $args[4]
Import-Module "sqlps" -DisableNameChecking
Set-ExecutionPolicy RemoteSigned
$_sqlFileName
$Error.Clear()
if (($_sqlUserName -eq "" -and $_sqlPassword -eq "") -or ($_sqlUserName -eq $null -and $_sqlPassword -eq $null)) {
    "Authentication type is Windows Authentication"
    if ($_sqlDatabase -eq "" -or $_sqlDatabase -eq $null) {
        "Database name passed using query.sql"
        Invoke-Sqlcmd -ServerInstance $args[1] -InputFile C:\qwerty\$_sqlFileName | Out-File -FilePath C:\qwerty\$_logsFileName
    } else {
        "Database name passed using config.ps1"
        Invoke-Sqlcmd -ServerInstance $args[1] -Database $_sqlDatabase -InputFile C:\qwerty\$_sqlFileName | Out-File -FilePath C:\qwerty\$_logsFileName
    }
} else {
    "Authentication type is SQL Server Authentication"
    if ($_sqlDatabase -eq "" -or $_sqlDatabase -eq $null) {
        "Database name passed using query.sql"
        Invoke-SQLCmd -ServerInstance $Server -Username $_sqlUserName -Password $_sqlPassword -InputFile C:\qwerty\$_sqlFileName | Out-File -FilePath C:\qwerty\$_logsFileName
    } else {
        "Database name passed using config.ps1"
        Invoke-SQLCmd -ServerInstance $Server -Database $_sqlDatabase -Username $_sqlUserName -Password $_sqlPassword -InputFile C:\qwerty\$_sqlFileName | Out-File -FilePath C:\qwerty\$_logsFileName
    }
}
if ($Error.Count -gt 0) {
    Out-File -FilePath "C:\qwerty\$_logsFileName" -InputObject $Error
    "Error occured while executing the Query"
} else {
    "SQL Query Execution Done"
}