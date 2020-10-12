$_options = $args[0]
#$_ResultlogText = ""

function checkFileExistence() {
    param (
        $ParameterName
    )
    $ParameterName
    "checkFileExistence"
    $_logText = ""
    $_backupFolder = $ParameterName[0]
    $_backupFile = $ParameterName[1]
    $_logText = $_logText + "File already exists `n"
    "File already exists"
	if (Test-Path $_backupFolder) {
		if (Test-Path $_backupFile) {
			Remove-Item $_backupFile
            $_logText = $_logText + "Backup file removed `n"
			"Backup file removed"
		}
	}
    else {
		mkdir $_backupFolder
        $_logText = $_logText + "Backup folder created `n"
		"Backup folder created"
	}
    return $_logText
}

function checkTodayBackupFolder() {
    param (
        $ParameterName
    )
    $_logText = ""
    $_todayBackupFolder = $ParameterName[0]
    $_filePathList = $ParameterName[1]
    if (Test-Path $_todayBackupFolder) {
        $_logText = $_logText + "Today folder already created `n"
        "Today folder already created"
    } else {
        mkdir $_todayBackupFolder
    }
    foreach ($_file in $_filePathList) {
        Move-Item -Path $_file -Destination $_todayBackupFolder
	    $_logText = $_logText + "New Backup file created `n"
        "New Backup file created"
    }
    return $_logText
}

function checkTodayDestinationFolder() {
    param (
        $ParameterName
    )
    $_logText = ""
    $_todayDestinationPath = $ParameterName
    if (Test-Path $_todayDestinationPath) {
        $_logText = $_logText + "Destination folder exists `n"
        "Destination folder exists"
    } else {
        $_logText = $_logText + "Destination folder not existed at remote machine `n"
        "Destination folder not existed at remote machine"
        $_tempTodayDestinationPath = mkdir $_todayDestinationPath
        $_logText = $_logText + "Destination Folder created at remote machine `n"
        "Destination Folder created at remote machine"
    }
    return $_logText
}


if ($_options -eq 1) {
    #Check file call before copying file from local system to remote system
    $_logText = ""
    $_filePathList = $args[1]
    $_backupFolder = $args[2]
    $_backupFilePathList = $args[3]
    $_currentBackupFolder = $args[4]
    $_currentDestinationFolder = $args[5]
    $_totalFiles = $_filePathList.Count
    <#$_filePathList
    $_backupFolder
    $_backupFilePathList
    $_currentBackupFolder
    $_currentDestinationFolder
    $_totalFiles#>
    "start"
    for ($_start = 0; $_start -lt $_totalFiles; $_start++) {
        if (Test-Path $_filePathList[$_start]) {
            $_tempLogText = checkFileExistence -ParameterName $_backupFolder, $_backupFilePathList[$_start]
            $_logText = $_logText + $_tempLogText
            $_tempLogText = checkTodayBackupFolder -ParameterName $_currentBackupFolder, $_filePathList[$_start]
            $_logText = $_logText + $_tempLogText
        }
        $_tempLogText = checkTodayDestinationFolder -ParameterName $_currentDestinationFolder
        $_logText = $_logText + $_tempLogText
    }
    return $_logText
}
elseif ($_options -eq 2) {
    #Check file before running sql file on remote system
    $_logText = ""
    $_currentDestinationFolder = $args[1]
    $_tempLogText = checkTodayDestinationFolder -ParameterName $_currentDestinationFolder
    $_logText = $_logText + $_tempLogText
    return $_logText
}
elseif ($_options -eq 3) {
    #"Check file before deploying war file on remote system"
    $_logText = ""
    $_warFileCheck = "False"
    $_deployedFileCheck = "False"
    $_undeployedFileCheck = "False"
    $_filePath = $args[1]
    $_backupFolder = $args[2]
    $_backupFile = $args[3]
    $_currentBackupFolder = $args[4]
    if (Test-Path $_filePath) {
        $_tempLogText = checkFileExistence -ParameterName $_backupFolder, $_backupFile
        $_logText = $_logText + $_tempLogText
        $_tempLogText = checkTodayBackupFolder -ParameterName $_currentBackupFolder, $_filePath
        $_logText = $_logText + $_tempLogText
    }
    if (Test-Path $_filePath".deployed") {
        $_deployedFileCheck = "True"
        Remove-Item $_filePath".deployed"
    }
    if (Test-Path $_filePath".undeployed") {
        $_undeployedFileCheck = "True"
        Remove-Item $_filePath".undeployed"
        $_logText = $_logText + "Undeloyed File Removed `n"
        "Undeloyed File Removed"
    }
    if(($_warFileCheck -eq "True" -or $_deployedFileCheck -eq "True") -and $_undeployedFileCheck -eq "False") {
        $_checkUndeployedFile = Test-Path $_filePath".undeployed"
        $_logText = $_logText + "Waiting for undeployed file to get created `n"
        "Waiting for undeployed file to get created"
        while (!$_checkUndeployedFile) {
            $_checkUndeployedFile = Test-Path $_filePath".undeployed"
        }
        $_logText = $_logText + "Undeployed Successfully created `n"
        "Undeployed Successfully created"
        Remove-Item $_filePath".undeployed"
    }
    return $_logText
}