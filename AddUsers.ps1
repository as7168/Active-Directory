# Create Active Directory Accounts and add users to multi groups
# /!\ Groups in csv file MUST be exist in Active Directory
# 
# By CHSA 9/03/2014
# 
Import-Module ActiveDirectory -ErrorAction SilentlyContinue
$Logfile = "AddUser.log"


# Get domain DNS suffix
$dnsroot = '@' + (Get-ADDomain).dnsroot

# Import the file with the users. You can change the filename to reflect your file
$users = Import-Csv .\sample.csv
foreach ($user in $users) {
Try
{
$login = $user.SamAccountName
# set default password
# change pass@word1 to whatever you want the account passwords to be
$defpassword = (ConvertTo-SecureString $user.Password -AsPlainText -force)

New-ADUser -SamAccountName $login -Name $login -DisplayName ($user.FirstName + " " + $user.LastName) -Surname $user.LastName -UserPrincipalName ($login + $dnsroot) -Description $user.title -Enabled $true -ChangePasswordAtLogon $false -PasswordNeverExpires $true -AccountPassword $defpassword -path "ou=Students, ou=Spring2017, ou=DigitalLogic, dc=uchiha, dc=com" -PassThru 

"Create user $login  ==> Ok" | Add-Content $Logfile 
}
catch [Microsoft.ActiveDirectory.Management.ADIdentityAlreadyExistsException]
{
"/!\ ERROR creating user: $login $_ " | Add-Content $Logfile
} 
}
