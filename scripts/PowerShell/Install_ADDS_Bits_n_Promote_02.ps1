$domainName  = "contoso.com"
$netBIOSname = "CONTOSO"
$mode  = "Win2012R2"

Install-WindowsFeature AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools

Import-Module ADDSDeployment

$forestProperties = @{

    DomainName           = $domainName
    DomainNetbiosName    = $netBIOSname
    ForestMode           = $mode
    DomainMode           = $mode
    CreateDnsDelegation  = $false
    InstallDns           = $true
    DatabasePath         = "C:\Windows\NTDS"
    LogPath              = "C:\Windows\NTDS"
    SysvolPath           = "C:\Windows\SYSVOL"
    NoRebootOnCompletion = $false
    Force                = $true

}

Install-ADDSForest @forestProperties