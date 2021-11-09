<#
#Usage
Set-ExecutionPolicy Bypass -Scope Process -force
remove-item c:\itsupport\scripts\func_bypassPrintNightmareAndMsKB.ps1 -erroraction silentlycontinue
powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/func_bypassPrintNightmareAndMsKB.ps1 -OutFile c:\itsupport\scripts\func_bypassPrintNightmareAndMsKB.ps1"
powershell -c ". c:\itsupport\scripts\func_bypassPrintNightmareAndMsKB.ps1;"

#>

Write-Host 'Bypassing Print Nightmare ACL' -ForegroundColor Green
$Path = "C:\Windows\System32\spool\drivers"
$Acl = (Get-Item $Path).GetAccessControl('Access')
$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule("System", "Modify", "ContainerInherit, ObjectInherit", "None", "Deny")
$Acl.RemoveAccessRule($Ar)
Set-Acl $Path $Acl


Write-Host 'Bypassing Microsoft Driver Install as Admin patch' -ForegroundColor Green
REG ADD "HKLM\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint" /v RestrictDriverInstallationToAdministrators /t REG_DWORD /d 0
REG ADD "HKLM\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint" /v UpdatePromptSettings /t REG_DWORD /d 0
REG ADD "HKLM\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint" /v NoWarningNoElevationOnInstall /t REG_DWORD /d 0
