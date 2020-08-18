$_pswd = $global:config.Password
$_user = $global:config.UserName
$_vmname = $global:config.VMName
$_pword = ConvertTo-SecureString -String $_pswd -AsPlainText -Force
$_credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $_user, $_pword
Write-Host "Authentication Done"
$_session = New-PSSession -VMName $_vmname -Credential $_credential
Write-Host "Remote Session Started"
return $_session