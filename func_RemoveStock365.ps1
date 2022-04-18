
function RemoveStock365 {
#Remove factory bloat office365
write-host "Attempting to remove Factory Bloat office365 Apps"
write-host "This sometimes takes a long time. Upwards of 5 to 10 minutes sometimes."


#Delete scheduled tasks related to 365
Write-Host "Deleting bundled 365 scheduled tasks - this may take a moment"
$SchedTaskToUnreg = @('Office Automatic Update','Office Automatic Updates 2.0','Office ClickToRun Service Monitor','Office Feature Updates','Office Feature Updates Logon','Office Subscription Maintenance','Clicktorunsvc')
foreach ($i in $SchedTaskToUnreg) {
	Unregister-ScheduledTask -TaskName $i -Confirm:$false -erroraction 'silentlycontinue'
	
}
write-host "Done"

#Stop processes potentiall 365 related
Write-Host "Stopping 365 related processes"
write-host "This may throw some red errors, but you can safely ignore them"
$ProcessesToKill = @('setup.exe','firstrun.exe','appvshnotify.exe','Officeclicktorun.exe')
foreach ($i in $ProcessesToKill) {
	if((get-process "$i" -ea SilentlyContinue) -eq $Null){ 
	write-host $i " Not detected - continuing"
		}else {
			write-host "Found process " $i
			write-host "Stopping it.."
			Stop-Process -processname "$i"
			}
	
}
write-host "Done"


#Delete office tiles in start menu
write-host "Removing some office tiles in start menu"
write-host "This may throw some red errors, these are fine and can be ignored!"
write-host "This may throw some red errors, these are fine and can be ignored!"
write-host "This may throw some red errors, these are fine and can be ignored!"
write-host "This may throw some red errors, these are fine and can be ignored!"
write-host "This may throw some red errors, these are fine and can be ignored!"
write-host "This may throw some red errors, these are fine and can be ignored!"
write-host "This may throw some red errors, these are fine and can be ignored!"
Get-appxpackage -allusers *Microsoft.MicrosoftOfficeHub* | Remove-AppxPackage -allusers
Get-appxprovisionedpackage -online | where-object {$_.packagename -like '*Microsoft.MicrosoftOfficeHub*'} | remove-appxprovisionedpackage -online -allusers
Get-appxpackage -allusers *onenote* | Remove-AppxPackage -allusers
Get-appxprovisionedpackage -online | where-object {$_.packagename -like '*onenote*'} | remove-appxprovisionedpackage -online -allusers
write-host "Done"

#Attempt uninstall of bundled 365 installs
Write-Host "Attempting automated uninstall of 365 C2R apps"
write-host "Checking if bloat c2r installers exist"
$fileToCheck = "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeClickToRun.exe"

write-host "Performing 365 cleanup. This may take some time. Please wait..."
powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/OfficeDev/Office-IT-Pro-Deployment-Scripts/master/Office-ProPlus-Deployment/Remove-PreviousOfficeInstalls/OffScrubc2r.vbs -OutFile c:\itsupport\scripts\OffScrubc2r.vbs"
Start-Process -Filepath cscript.exe -ArgumentList "c:\itsupport\scripts\OffScrubc2r.vbs CLIENTALL /S /Q /NoCancel" -Wait

if (Test-Path $fileToCheck -PathType leaf)
{
	Write-Host "Manually Removing bundled 365 en-us"
		Start-Process "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeClickToRun.exe" -ArgumentList "scenario=install   scenariosubtype=ARP sourcetype=None productstoremove=O365HomePremRetail.16_en-us_x-none culture=en-us version.16=16.0 DisplayLevel=false" -EA SilentlyContinue -wait
		Write-Host "Manually Removing bundled 365 es-es"
		Start-Process "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeClickToRun.exe" -ArgumentList "scenario=install   scenariosubtype=ARP sourcetype=None productstoremove=O365HomePremRetail.16_es-es_x-none culture=es-es version.16=16.0 DisplayLevel=false" -EA SilentlyContinue -wait
		Write-Host "Manually Removing bundled 365 fr-fr"
		Start-Process "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeClickToRun.exe" -ArgumentList "scenario=install   scenariosubtype=ARP sourcetype=None productstoremove=O365HomePremRetail.16_fr-fr_x-none culture=fr-fr version.16=16.0 DisplayLevel=false" -EA SilentlyContinue -wait

}
write-host "Done"
}
