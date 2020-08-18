$_filepath = $args[1] + $args[0]
$_backupfolder = $args[2]
$_backupfile = $_backupfolder + $args[0]
if (Test-Path $_filepath) {
	"File already exists"
	if (Test-Path $_backupfolder) {
		if (Test-Path $_backupfile) {
			Remove-Item $_backupfile
			"Backup file removed"
		}
	}
 else {
		mkdir $_backupfolder
		"Backup folder created"
	}
	Move-Item -Path $_filepath -Destination $_backupfolder
	"New Backup file created"
}