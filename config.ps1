$global:config = @{
    UserName          = "username"
    Password          = "password"
    VMName            = "VirtualMachine2"
    SourcePath        = "E:\Projects\PoweShell\00000\SMBC_devOps\"
    FileName          = "query.sql"
    Destination       = "C:\qwerty\"
    BackupFolderPath  = "C:\backup\"
    ServiceName       = "Print Spooler"
    SQLServerInstance = "DESKTOP-NFTKB1L"
    SQLServerUserName = "sa" #if not given Authentication type is windows Authentication else if given then sql server authentication
    SQLServerPassword = "admin123" #if not given Authentication type is windows Authentication else if given then sql server authentication
    DatabaseName = "BikeStores"
}