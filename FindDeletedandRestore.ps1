# Project @ https://github.com/MSSA-AU/ClassInfo/blob/main/PowerShellTraining/PSADProject2.md#restore-an-accidently-deleted-ad-user-account-from-the-recycle-bin

function FindandRestore {
  <#
   .Synopsis
    This function finds deleted objects and displays in Out-grid view.  Selected objects will be restored when "ok" is selected

   .Description
    This function finds deleted objects and displays in Out-grid view.  Selected objects will be restored when "ok" is selected

   .Notes
    NAME:  Find and restore deleted objects
    AUTHOR: Mike Gogue
    LASTEDIT: 08/30/2023 14:21:22
    KEYWORDS: Restore deleted objects

   .Link
    Project https://github.com/MSSA-AU/ClassInfo/blob/main/PowerShellTraining/PSADProject2.md#restore-an-accidently-deleted-ad-user-account-from-the-recycle-bin

 #>
    [cmdletBinding()]
  Param()

$finddeleted = Get-ADObject -LDAPFilter:"(msDS-LastKnownRDN=*)" -IncludeDeletedObjects | Where-Object {$_.Deleted -eq $true} | 
    Out-GridView -OutputMode Multiple -Title 'Choose Deletions to restore' | Restore-ADObject
}

(get-aduser -filter *).count   #1245

get-help findandrestore