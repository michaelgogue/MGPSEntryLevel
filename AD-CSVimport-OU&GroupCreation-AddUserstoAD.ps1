
#  PROJECT INSTRUCTIONS:  https://github.com/MSSA-AU/ClassInfo/blob/main/PowerShellTraining/PSADProject1.md

  # 1. Import CSV File  
  $Users = Import-Csv -Path E:\\newhires.csv
  $Users
  ($users).count

  # 2. Get an array of all of the Departments that are needed based off of the CSV File
  $DepartmentNames = $Users.Department | Select-Object -unique # select-object -unique removes duplicates instead of listing all departments for each user
  $DepartmentNames

  # 3. Get an array of OU names already created in Active Directory
  $CurrentOUNames = (Get-ADOrganizationalUnit -Filter *).Name 
  $CurrentOUNames

  # 4. Get an array of Group names already created in Active Directory
  $CurrentGroupNames = (Get-ADGroup -Filter *).Name #adding the round brackets and the .Name returns only the names of the ADGroups listed in AD
  $CurrentGroupNames 

  # 5. Checking to see if the OUs and Groups are already created
  foreach ($DepartmentName in $DepartmentNames) { # departmentnames returns list of all departments needed within the CSV file
    if ($DepartmentName -notin $CurrentOUNames) { # CurrentOUnames returns all OU's currently in Active Directory
      New-ADOrganizationalUnit -Name $DepartmentName -Path 'dc=adatum,dc=com' # Creates new OU's based on departments that were returned from DepartmentNames not already in AD 
    }
    if ($DepartmentName -notin $CurrentGroupNames) { # Checks groups within the CSV file and looks in CurrentGroupNames to see what is not loaded in AD
      New-ADGroup -GroupScope Global -Name $DepartmentName -Path "ou=$DepartmentName,dc=adatum,dc=com" # Creates new groups for the Groups within the CSV file and not already in AD
    }
  }


  $UserTotalCount = $Users.Count
  $CurrentUserCount = 0 
  
   
  foreach ($User in $Users) {
    $CurrentUserCount++
    Write-Progress -Activity "Creating Users" -PercentComplete ($CurrentUserCount/$UserTotalCount*100) -CurrentOperation  "Creating User: $($User.FirstName + ' ' + $User.LastName)"
    # Creating all of the information needed to create the user
    $Name = $User.firstname + ' ' + $User.lastname
    $OU = 'OU=' + $User.department + ',DC=adatum,DC=com'
    $secPwd = $User.password | ConvertTo-SecureString -AsPlainText -Force
    $SamAccountName = $User.firstname.SubString(0,1) + $User.lastname
    
    $Parameters = @{ # Splatting the paramaters for New-ADUser, instead of listing parameters on one line after the command
      Name=$Name
      Path=$OU
      GivenName=$User.firstname
      Surname=$User.lastname
      SamAccountName=$SamAccountName
      AccountPassword=$secPwd 
      Department=$User.department 
      Office=$User.officename 
      UserPrincipalName=$user.upn 
      MobilePhone=$User.mobilephone 
      City=$User.city 
      StreetAddress=$User.streetaddress
    }
    New-ADUser @Parameters # Creating the new user
    $NewUser = Get-ADUser -Identity $SamAccountName
    Add-ADGroupMember -Identity $User.department -Members $NewUser  # Adding the new user to the relevant group
  }

(get-aduser -filter *).count

Get-ADGroupMember -Identity Contractors