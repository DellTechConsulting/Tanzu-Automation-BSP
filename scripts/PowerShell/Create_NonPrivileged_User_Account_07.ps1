# Prompt for a Password
$Password = Read-Host -assecurestring "User Password"

# Create a Non-Privileged User Account
$userProperties = @{

    Name                 = "Krishna Pal Chouhan"
    GivenName            = "Krishna Pal"
    Surname              = "Chouhan"
    DisplayName          = "Krishna Pal Chouhan"
    Path                 = "OU=Users,OU=Resources,DC=Contoso,DC=com"
    SamAccountName       = "krishna.chouhan"
    UserPrincipalName    = "krishna.chouhan@contoso.com"
    AccountPassword      = $Password
    PasswordNeverExpires = $True
    Enabled              = $True
    Description          = "Contoso User"

}

New-ADUser @userProperties