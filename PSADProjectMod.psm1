# Powershell Active Directory Module with functions
function Import-ADUserCSV {
  <#
.SYNOPSIS
  Adds Active Directory users based on CSV input
.DESCRIPTION
  This function imports user information from a CSV file and performs the following tasks:
  1. Creates new OUs if they don't already exist.
  2. Creates new security groups if they don't already exist.
  3. Creates new user accounts in the appropriate groups and OUs.
.NOTES
  This was created for Powershell Project 1
.LINK
  Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
  Import-ADUserCSV -FilePath "E:\NewHires.csv"
  Imports user information from NewHires.csv and creates ADUsers, OUs, and security groups as needed.
#>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, HelpMessage = "Path to the CSV file containing user information.")]
    [string]$FilePath
  )
  
  begin {
    # Import the CSV File and store in variable
    $NewHires = Import-Csv -Path $FilePath
      
    # Get a list of OUs in AD
    $OrgNames = (Get-ADOrganizationalUnit -Filter *).Name
      
    # Get a list of Security Groups
    $SecGroups = (Get-ADGroup -Filter 'GroupCategory -eq "Security"').Name
  }
  
  process {
    # For each department in $NewHires, create OU and security group if not exists
    foreach ($Department in ($NewHires | Select-Object -Property Department -Unique).Department) {
      if ($OrgNames -notcontains $Department) {
        New-ADOrganizationalUnit -Name $Department
      }
      if ($SecGroups -notcontains $Department) {
        New-ADGroup -Name $Department -GroupScope DomainLocal -GroupCategory Security
      }
    }
      
    # For each person in the file, create a new user account
    foreach ($newHire in $NewHires) {
      $UserInfo = @{
        SamAccountName    = ($newHire.FirstName.Substring(0, 1) + $newHire.LastName).ToLower()
        Name              = $newHire.FirstName + " " + $newHire.LastName
        Path              = "OU=" + $newHire.Department + ",DC=Adatum,DC=com"
        UserPrincipalName = $newHire.Upn
        Department        = $newHire.Department
        GivenName         = $newHire.FirstName
        Surname           = $newHire.LastName 
        StreetAddress     = $newHire.StreetAddress
        City              = $newHire.City
        MobilePhone       = $newHire.MobilePhone
        AccountPassword   = (ConvertTo-SecureString $newHire.Password -AsPlainText -Force)
        Office            = $newHire.OfficeName
        Enabled           = $true
      }
          
      $newUser = New-ADUser @UserInfo -PassThru
      Add-ADPrincipalGroupMembership -Identity $newUser -MemberOf $newHire.Department
    }
  }
  
  end {
    # Clean up resources if needed
  }
}

function Restore-DeletedADObject {
  <#
  .SYNOPSIS
    This command will restore AD users from the AD Recycle bin
  .DESCRIPTION
    This command will check for all deleted users and list them in a GUI, allowing the users that 
    need to be restored to be slected and then automatically restored to AD
  .EXAMPLE
    Restore-DeletedADObject
    This will present a list of deleted users for selection to resore them to AD
  .NOTES
    General notes
      Created By: Brent Denny
      Created On: 01-Feb-2022
  #>
  # Find all of the deleted objects in AD  
  $DeletedObjects = Get-ADObject -LDAPFilter:"(msDS-LastKnownRDN=*)" -IncludeDeletedObjects | Where-Object { $_.Deleted -eq $true }
  $ADObjectsChosen = $DeletedObjects | Out-GridView -OutputMode Multiple  # Choose which objects to restore
  $ADObjectsChosen | Restore-ADObject -Confirm:$false # This restores the chosen object
  # this finds the restored objects in AD  
  $RestoredObjects = Get-ADObject -Filter * | Where-Object { $_.ObjectGuid -in $ADObjectsChosen.ObjectGuid }  
  return $RestoredObjects   # Show the restored objects on the screen (this is the optional requirement)
}

function Find-AssociatedGroupMembership {
  <#
  .SYNOPSIS
    This command will find all related groups given a users samaccountname
  .DESCRIPTION
    This command will find all of the groups a user is a member of and then
    will located all groups that those groups are a member of and repeat this 
    until no more memberships can be found. These groups will then be displayed
    as output
  .EXAMPLE
    Find-AssociatedGroupMembership
    This command will find all related groups given a users samaccountname
  .PARAMETER SamAccountName
    This is the SamAccountName that is associated with the use in question  
  .NOTES
    General notes
      Created By: Brent Denny
      Created On: 01-Feb-2022
  #>
  Param ($SamAccountName)
  function Get-MemberOf {
    Param($ADObject)
    $Groups = Get-ADPrincipalGroupMembership -Identity $ADObject
    foreach ($Group in $Groups) {
      $Group | Select-Object -Property Name, GroupScope
      Get-MemberOf -ADObject $Group
    }
  }
  $ADAccount = Get-ADUser -Identity $SamAccountName
  Get-MemberOf -ADObject $ADAccount
} 

function New-Password {
  param (
    [int]$NumberCount = 1,
    [int]$LowerCaseCount = 7,
    [int]$UpperCaseCount = 3
  )
  $NewPW = ''

  # Generate Random Numbers
  for ($i = 0; $i -lt $NumberCount; $i++) {
    $NewPW += Get-Random -Minimum 0 -Maximum 10
  }
  # Generate random lowercase letters between ASCII values 97 and 123
  for ($i = 0; $i -lt $LowerCaseCount; $i++) {
    $RLC = [char](Get-Random -Minimum 97 -Maximum 123)
    $NewPW += $RLC
  }
  # Generate random uppercase letters between ASCII values 65 and 91
  for ($i = 0; $i -lt $UpperCaseCount; $i++) {
    $RUC = [char](Get-Random -Minimum 65 -Maximum 91)
    $NewPw += $RUC
  }
  $FinalPW = -join ($NewPw.ToCharArray() | Get-Random -Count $NewPw.Length)
  return $FinalPW
}

function Disable-ADUsersCSV {
  param (
    [string]$FileName
  )
  $DUsers = Import-Csv -Path $FileName
  foreach ($DUser in $DUsers) {
    $Name = $DUser.Name
    $Dep = $DUser.Department
    $NewPass = ConvertTo-SecureString (New-Password) -AsPlainText -Force
    $User = Get-ADUser -Filter { Name -eq $Name -and Department -eq $Dep }
    Set-ADUser -Identity $User -Replace @{info = $User.DistinguishedName + " was the original DN" }
    Set-ADAccountPassword -Identity $User -Reset -NewPassword $NewPass
    Disable-ADAccount -Identity $User
    Move-ADObject -Identity $User -TargetPath "OU=DisabledUsers,DC=Adatum,DC=Com"
  }
}