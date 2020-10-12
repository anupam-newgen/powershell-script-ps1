$_sqlServerInstance = $global:config.SQLServerInstance
$_sqlUserName = $global:config.SQLServerUserName
$_sqlPassword = $global:config.SQLServerPassword
$_sqlDatabase = $global:config.DatabaseName
$_logsFileName = "query.log"
$_sqlFilePath = $global:config.SourcePath
$_sqlFileName = $global:config.FileName
$_filePath = $_sqlFilePath + $_sqlFileName
$_logFilePath = $_sqlFilePath + $_logsFileName
$Error.Clear()
if (Test-Path $_filePath) {
    $_extension = $_filePath.Split("{.}")[-1]
    if ($_extension -eq "sql") {
        "SQL"
        if (($_sqlUserName -eq "" -and $_sqlPassword -eq "") -or ($_sqlUserName -eq $null -and $_sqlPassword -eq $null)) {
            "Authentication type is Windows Authentication"
            if ($_sqlDatabase -eq "" -or $_sqlDatabase -eq $null) {
                "Database name not passed passed using query.sql"
                Invoke-Sqlcmd -ServerInstance $_sqlServerInstance -InputFile $_filePath | Out-File -FilePath $_logFilePath
            } else {
                "Database name passed using config.ps1"
                Invoke-Sqlcmd -ServerInstance $_sqlServerInstance -Database $_sqlDatabase -InputFile $_filePath | Out-File -FilePath $_logFilePath
            }
        } else {
            "Authentication type is SQL Server Authentication"
            if ($_sqlDatabase -eq "" -or $_sqlDatabase -eq $null) {
                "Database name not passed passed using query.sql"
                Invoke-SQLCmd -ServerInstance $_sqlServerInstance -Username $_sqlUserName -Password $_sqlPassword -InputFile $_filePath | Out-File -FilePath $_logFilePath
            } else {
                "Database name passed using config.ps1"
                Invoke-SQLCmd -ServerInstance $_sqlServerInstance -Database $_sqlDatabase -Username $_sqlUserName -Password $_sqlPassword -InputFile $_filePath | Out-File -FilePath $_logFilePath
            }
        }
        if ($Error.Count -gt 0) {
            Out-File -FilePath $_logFilePath -InputObject $Error
            "Error occured while executing the Query"
        } else {
            "SQL Query Execution Done"
        }
    } else {
        "File is invalid"
    }
} else {
    "File not found"
}