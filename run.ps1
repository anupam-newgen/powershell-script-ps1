$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$_isPowershell = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if($_isPowershell) {
    .\config.ps1
    .\doActionOnVM.ps1
} else {
    "Powershell must be running as administrator"
}