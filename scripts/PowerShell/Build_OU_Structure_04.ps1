$baseDN = "DC=contoso,DC=com"
$resourcesDN = "OU=Resources," + $baseDN

New-ADOrganizationalUnit "Resources" -path $baseDN
New-ADOrganizationalUnit "Admin Users" -path $resourcesDN
New-ADOrganizationalUnit "Groups Security" -path $resourcesDN
New-ADOrganizationalUnit "Service Accounts" -path $resourcesDN
New-ADOrganizationalUnit "Workstations" -path $resourcesDN
New-ADOrganizationalUnit "Servers" -path $resourcesDN
New-ADOrganizationalUnit "Users" -path $resourcesDN