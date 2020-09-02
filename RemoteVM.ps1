#Get-VM  #to get list of VM's available

$VmName = "TestMachine"
#$VmName = $args[0]
$UserName = "User"
#$UserName = $args[1]
$Password = "rohit"
#$Password = $args[2]
$EncryptedPwd = ConvertTo-SecureString $Password -AsPlainText -Force

$creds = New-Object System.Management.Automation.PSCredential ($UserName, $EncryptedPwd)
if($creds)
{
    Write-Host "Credentials added"
    # Get Powershell Session on VM
    $Server = New-PSSession -VMName $VmName -Credential $creds
    if($Server)
    {
        Write-Host "New PS Session Created on VM with UserName: $UserName"
        #return $Server
        Enter-PSSession $Server
        Write-Host "Remote PSSession on VM started"
        #Install JBOSS
        Get-ComputerInfo -Property "CsDNSHostName" 
        Exit-PSSession
        Write-Host "Remote PSSession on VM Ended"
    } else
    {
        Write-Host "Error creating PS Session"
    }
} else 
{
    Write-Host "Credentials not found"
}

#Enter-PSSession -VMName TestMachine
#Exit-PSSession
#Get-PSSession  #returns a list of PSSessions
#Remove-PSSession -Id Id #removes a particular PSSession by Id