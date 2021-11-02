<#
#USAGE

#script_printer_troulbleshoot
remove-item $env:TEMP\script_printer_troulbleshoot.ps1 -erroraction silentlycontinue
powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/script_printer_troulbleshoot.ps1 -OutFile $env:TEMP\script_printer_troulbleshoot.ps1"
powershell -exec bypass -c ". $env:TEMP\script_printer_troulbleshoot.ps1"

#>




do {
Write-Host 'CGP PRINT TROUBLESHOOTING SCRIPT'
''
$askContinue=Read-Host "Continue running this script on $env:computername ? (Y/N)"

''
If ($askContinue -eq 'Y')
 

{
function CheckIfRunningAsAdmin {
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    write-host "MUST BE RUN AS ADMIN - Exiting in 10 seconds!" -ForegroundColor RED
	sleep 10
    Exit
}elseif (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
	write-host "This script is running as administrator!" -ForegroundColor GREEN
}
}
CheckIfRunningAsAdmin

$askClearPrintJobs=Read-Host "Would you like to clear Stuck printjobs? (Y/N)"
$askPrintNightmare=Read-Host "Would you like to bypass PrintNightmare? (Y/N)"
$askBypassMsKB=Read-Host "Would you like to bypass Microsoft printing as admin KB5005033? (Y/N)"




'================================================================='

If ($askPrintNightmare -eq 'Y'){
Write-Host 'Bypassing Print Nightmare ACL' -ForegroundColor Green
$Path = "C:\Windows\System32\spool\drivers"
$Acl = (Get-Item $Path).GetAccessControl('Access')
$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule("System", "Modify", "ContainerInherit, ObjectInherit", "None", "Deny")
$Acl.RemoveAccessRule($Ar)
Set-Acl $Path $Acl
}


If ($askBypassMsKB -eq 'Y'){
Write-Host 'Bypassing Microsoft Driver Install as Admin patch' -ForegroundColor Green
REG ADD "HKLM\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint" /v RestrictDriverInstallationToAdministrators /t REG_DWORD /d 0
REG ADD "HKLM\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint" /v UpdatePromptSettings /t REG_DWORD /d 0
REG ADD "HKLM\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint" /v NoWarningNoElevationOnInstall /t REG_DWORD /d 0
}

If ($askClearPrintJobs -eq 'Y'){
Write-Host 'Stopping Spooler Service ...' -ForegroundColor Green
Stop-Service spooler
If ((Get-Service spooler).status -eq 'Running')
{Write-Host 'Error! Spooler could not be stopped!' -ForegroundColor Red}

Write-Host "Clearing printjobs in $env:windir\system32\spool\PRINTERS" -ForegroundColor Green
Remove-Item -Path $env:windir\system32\spool\PRINTERS\*.*


Write-Host 'Starting Spooler Service ...' -ForegroundColor Green
$start=Start-Service Spooler -ErrorAction Ignore
If ((Get-Service spooler).status -eq 'Stopped')
{Write-Host 'Error! Spooler could not be started!' -ForegroundColor Red}

write-host "DONE!"
}
'================================================================='
''
write-host "Exiting!"
PAUSE
exit
}
}
while ($askContinue -ne 'N')
