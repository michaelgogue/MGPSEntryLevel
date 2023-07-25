#Set your Public/Private Certificate to digitally sign code
# On Client:  mmc.exe - File - Add/Remove Snapin - Certificates - add - personal - all tasks - request new cert
# On DC: Certificate authority must be authorized for the specific user = DC - Server Manager - Tools - Certificate Authority - Certificate Templates

$cert = get-childitem -path Cert:\currentuser\My -CodeSigningCert

Set-AuthenticodeSignature -FilePath C:\Scripts\demo.ps1 -Certificate $cert

Set-ExecutionPolicy -ExecutionPolicy AllSigned
# Sets to all codes must be signed

C:\scripts\Demo.ps1
# Test a script should display a prompt


Set-ExecutionPolicy unrestricted
# Set's all code to Unrestricted

Get-ExecutionPolicy