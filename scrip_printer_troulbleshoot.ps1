do {
Write-Host 'CGP PRINT TROUBLESHOOTING SCRIPT'
''
$sure=Read-Host "Are you sure you want to delete all Print Jobs on $env:computername and bypass PrintNightmare and MS KB KB5005033 (Y/N)"
''
If ($sure -eq 'Y')
 
{
'================================================================='
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

Write-Host 'Stopping Spooler Service ...' -ForegroundColor Green
Stop-Service spooler
If ((Get-Service spooler).status -eq 'Running')
{Write-Host 'Error! Spooler could not be stopped!' -ForegroundColor Red}

Write-Host "Clearing content in $env:windir\system32\spool\PRINTERS" -ForegroundColor Green
Remove-Item -Path $env:windir\system32\spool\PRINTERS\*.*


Write-Host 'Starting Spooler Service ...' -ForegroundColor Green
$start=Start-Service Spooler -ErrorAction Ignore
If ((Get-Service spooler).status -eq 'Stopped')
{Write-Host 'Error! Spooler could not be started!' -ForegroundColor Red}

write-host "DONE!"
'================================================================='
''
 
PAUSE
}
}
while ($sure -ne 'N')
