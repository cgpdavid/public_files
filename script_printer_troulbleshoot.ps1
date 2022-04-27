<#
.Synopsis
   CGP Print Nightmare(s) bypass script
   This script will be updated to also include fixes for other printer related problems that we encounter.

.DESCRIPTION
   This is an unnoficial and unsupported script written by David @ CGP

.EXAMPLE
   #script_printer_troulbleshoot
   remove-item $env:TEMP\script_printer_troulbleshoot.ps1 -erroraction silentlycontinue
   powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/script_printer_troulbleshoot.ps1 -OutFile $env:TEMP\script_printer_troulbleshoot.ps1"
   powershell -exec bypass -c ". $env:TEMP\script_printer_troulbleshoot.ps1"

#>


do {
Write-Host 'CGP PRINT TROUBLESHOOTING SCRIPT'
''
$askContinue=Read-Host "Continue running this script on $env:computername ? (y/N)"

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
Write-host "NOTES:"
Write-host "03-23-22 CGP-DM - Gpupdate as admin disabled for now! will only run as logged in user.`n "

$askClearPrintJobs=Read-Host "Would you like to clear Stuck printjobs? (y/N)"
$askPrintNightmare=Read-Host "Would you like to bypass PrintNightmare? (y/N)"
$askBypassMsKB1=Read-Host "Would you like to bypass Microsoft printing as admin KB5005033? (y/N)"
$askBypassMsKB2=Read-Host "Would you like to bypass Microsoft printing as admin KB5005565? (y/N)"
$askGpupdate=Read-Host "Would you like to gpupdate /force as the last step? (y/N)"




'================================================================='

If ($askPrintNightmare -eq 'Y'){
Write-Host 'Bypassing Print Nightmare ACL' -ForegroundColor Green
$Path = "C:\Windows\System32\spool\drivers"
$Acl = (Get-Item $Path).GetAccessControl('Access')
$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule("System", "Modify", "ContainerInherit, ObjectInherit", "None", "Deny")
$Acl.RemoveAccessRule($Ar)
Set-Acl $Path $Acl
}


If ($askBypassMsKB1 -eq 'Y'){
Write-Host 'Bypassing Microsoft Driver Install as Admin patch KB5005033' -ForegroundColor Green
REG ADD "HKLM\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint" /v RestrictDriverInstallationToAdministrators /t REG_DWORD /d 0
REG ADD "HKLM\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint" /v UpdatePromptSettings /t REG_DWORD /d 0
REG ADD "HKLM\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint" /v NoWarningNoElevationOnInstall /t REG_DWORD /d 0
}

If ($askBypassMsKB2 -eq 'Y'){
Write-Host 'Bypassing Microsoft patch KB5005565' -ForegroundColor Green
REG ADD "HKLM\System\CurrentControlSet\Control\Print" /v RpcAuthnLevelPrivacyEnabled /t REG_DWORD /d 0
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

If ($askGpupdate -eq 'Y'){
Write-Host 'NOT Forcing GPUPDATE as admin! (DISABLED FOR NOW!)' -ForegroundColor Green
#gpupdate /force

Write-Host 'Forcing GPUPDATE as logged on user!' -ForegroundColor Green
$ArgumentList = "/k gpupdate /force & exit"
$apppath = "cmd.exe" 
$taskname = "Launch $apppath"
$action = New-ScheduledTaskAction -Execute $apppath -Argument $ArgumentList
write-host $action 
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date)
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $taskname | Out-Null
Start-ScheduledTask -TaskName $taskname
Start-Sleep -s 1
Unregister-ScheduledTask -TaskName $taskname -Confirm:$false

}
write-host "Launching Printers Control Panel then exiting!"
control printers
'================================================================='
''
write-host "Exiting!"
PAUSE
exit
}
}
while ($askContinue -ne 'N')
