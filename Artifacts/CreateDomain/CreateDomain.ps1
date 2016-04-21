
Param(
    # comma or semicolon separated list of chocolatey packages.



    [Parameter(Mandatory=$True)]
    [string] $password,

    [Parameter(Mandatory=$True)]
    [string] $domain

)


Install-WindowsFeature -Name Ad-Domain-Services,DNS -IncludeManagementTools -Verbose

$DatabaseRoot = "C:\Windows"
$FQDN = $domain + ".com"
$NetBiosDomainName = "$domain"
$SecurePassword = ConvertTo-SecureString -String $password -AsPlainText -Force

# Configure Active Directory and DNS

Install-ADDSForest `
-CreateDnsDelegation:$true `
-DatabasePath "$DatabaseRoot\NTDS" `
-DomainMode "WIN2012R2" `
-DomainName $FQDN `
-DomainNetbiosName $NetBiosDomainName `
-ForestMode "WIN2012R2" `
-InstallDns:$true `
-SafeModeAdministratorPassword $SecurePassword `
-LogPath "$DatabaseRoot\NTDS" `
-NoRebootOnCompletion:$true `
-SysvolPath "$DatabaseRoot\SYSVOL" `
-Force:$true

# Done

sleep -Seconds 10
Restart-Computer
