#file to check whether JBOSS Server running or not

$_startLogs = Get-Content "C:\Users\asus\EAP-7.3.0\standalone\log\server.log" | Where-Object {$_ -like '*Started * of * services*'}
#$_startLogs
$_startLogsArr = $_startLogs.Split("{`r`n}")
$_latestStartLog = $_startLogsArr[$_startLogsArr.Length - 1]
#$_latestStartLog
$_startLogsArr2 = $_latestStartLog.Split("{ }")
#$_startLogsArr2
$_start = $_startLogsArr2[0] + " " + $_startLogsArr2[1]
$_latestStartTime = $_start.Split("{,}")[0]
$_latestStartTime

$_stopLogs = Get-Content "C:\Users\asus\EAP-7.3.0\standalone\log\server.log" | Where-Object {$_ -like '*stopped in*'}
#$_stopLogs
$_stopLogsArr = $_stopLogs.Split("{`r`n}")
$_latestStopLog = $_stopLogsArr[$_stopLogsArr.Length - 1]
#$_latestStopLog
$_stopLogsArr2 = $_latestStopLog.Split("{ }")
#$_stopLogsArr2
$_stop = $_stopLogsArr2[0] + " " + $_stopLogsArr2[1]
$_latestStopTime = $_stop.Split("{,}")[0]
$_latestStopTime

if ($_latestStartTime -gt $_latestStopTime) {
    'JBOSS Server running'
} else {
    'JBOSS Server not running'
}