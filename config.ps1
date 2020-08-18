$global:config = @{
	UserName         = "vm-windows10"
	Password         = "vmwindows"
	VMName           = "windows10"
	SourcePath       = "E:\powershell_scripts\deployment_files\"
	FileName         = "smbc-web-services.war"
	Destination      = "C:\jboss\target\"
	BackupFolderPath = "C:\backup\"
	ServiceName      = "Print Spooler"
}