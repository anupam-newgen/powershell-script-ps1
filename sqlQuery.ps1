$_timestamp = $args[0]
$_sqlServerInstance = $args[1]
$_sqlFileName = $_timestamp+".sql"
$_logsFileName = $_timestamp+".rpt"
$_sqlPath = 'C:\qwerty\query.sql'
Import-Module "sqlps" -DisableNameChecking
Set-ExecutionPolicy RemoteSigned
$_sqlFileName
Invoke-Sqlcmd -ServerInstance $args[1] -InputFile C:\qwerty\$_sqlFileName | Out-File -FilePath C:\qwerty\$_logsFileName
"SQL Query Execution Done"
#Invoke-Sqlcmd -Query "SELECT GETDATE() AS TimeOfQuery" -ServerInstance "DESKTOP-O9CEJJO"