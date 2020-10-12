# to check that powershell running as administrator
$_logs = ".\abc.txt"
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$_isPowershell = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if($_isPowershell) {
    "1.Execution on local machine"
    "2.Execution on remote machine"
    $_options = Read-Host "Select the option"
    if ($_options -eq 1) {
        Add-Content -Path $_logs "commands execution on local machine"
        .\config.ps1
        .\doActionOnLocal.ps1
    } elseif ($_options -eq 2) {
        Add-Content -Path $_logs "commands execution on remote machine"
        .\config.ps1
        .\doActionOnVM.ps1
    } else {
        "Invalid option selected"
        Add-Content -Path $_logs "Invalid option selected"
    }
} else {
    "Powershell must be running as administrator"
    Add-Content -Path $_logs "Powershell must be running as administrator"
}