# Prompt for a Password
$Password = Read-Host -assecurestring "User Password"

# Create a Privileged Account
$userProperties = @{

    Name                 = "Bhavani Shankar Pradhan"
    GivenName            = "Bhavani Shankar"
    Surname              = "Pradhan"
    DisplayName          = "Bhavani Shankar Pradhan"
    Path                 = "OU=Admin Users,OU=Resources,DC=Contoso,DC=com"
    SamAccountName       = "bhavani.pradhan"
    UserPrincipalName    = "bhavani.pradhan@contoso.com"
    AccountPassword      = $Password
    PasswordNeverExpires = $True
    Enabled              = $True
    Description          = "Contoso Enterprise Admin"

}

New-ADUser @userProperties

# Add Privileged Account to EA, DA, & SA Groups
Add-ADGroupMember "Domain Admins" $userProperties.SamAccountName
Add-ADGroupMember "Enterprise Admins" $userProperties.SamAccountName
Add-ADGroupMember "Schema Admins" $userProperties.SamAccountName