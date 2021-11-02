
function RemoveStock365 {
#Remove factory bloat office365
write-host "Attempting to remove Factory Bloat office365 Apps"
write-host "This sometimes takes a long time. Upwards of 5 to 10 minutes sometimes."


#Delete scheduled tasks related to 365
Write-Host "Deleting bundled 365 scheduled tasks"
Unregister-ScheduledTask -TaskName "Office Automatic Update" -Confirm:$false -erroraction 'silentlycontinue'
Unregister-ScheduledTask -TaskName "Office Automatic Updates 2.0" -Confirm:$false -erroraction 'silentlycontinue'
Unregister-ScheduledTask -TaskName "Office ClickToRun Service Monitor" -Confirm:$false -erroraction 'silentlycontinue'
Unregister-ScheduledTask -TaskName "Office Feature Updates" -Confirm:$false -erroraction 'silentlycontinue'
Unregister-ScheduledTask -TaskName "Office Feature Updates Logon" -Confirm:$false -erroraction 'silentlycontinue'
Unregister-ScheduledTask -TaskName "Office Subscription Maintenance" -Confirm:$false -erroraction 'silentlycontinue'
Unregister-ScheduledTask -TaskName "Clicktorunsvc" -Confirm:$false -erroraction 'silentlycontinue'


#Stop processes potentiall 365 related
Write-Host "Stopping 365 related processes"
write-host "It will likely say some dont exist - this is fine. continue"
Get-Process -Name 'setup.exe','firstrun.exe','appvshnotify.exe','Officeclicktorun.exe' | Stop-Process -Force -ErrorAction SilentlyContinue

#Delete office tiles in start menu
Get-appxpackage -allusers *Microsoft.MicrosoftOfficeHub* -allusers | Remove-AppxPackage -allusers
Get-appxprovisionedpackage -online | where-object {$_.packagename -like '*Microsoft.MicrosoftOfficeHub*'} | remove-appxprovisionedpackage -online -allusers
Get-appxpackage -allusers *onenote* | Remove-AppxPackage -allusers
Get-appxprovisionedpackage -online | where-object {$_.packagename -like '*onenote*'} | remove-appxprovisionedpackage -online -allusers


#Attempt uninstall of bundled 365 installs
Write-Host "Attempting automated uninstall of 365 C2R apps"
write-host "Checking if bloat c2r installers exist"
$fileToCheck = "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeClickToRun.exe"
if (Test-Path $fileToCheck -PathType leaf)
{
	Write-Host "Manually Removing bundled 365 en-us"
		Start-Process "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeClickToRun.exe" -ArgumentList "scenario=install   scenariosubtype=ARP sourcetype=None productstoremove=O365HomePremRetail.16_en-us_x-none culture=en-us version.16=16.0 DisplayLevel=false" -EA SilentlyContinue -wait
		Write-Host "Manually Removing bundled 365 es-es"
		Start-Process "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeClickToRun.exe" -ArgumentList "scenario=install   scenariosubtype=ARP sourcetype=None productstoremove=O365HomePremRetail.16_es-es_x-none culture=es-es version.16=16.0 DisplayLevel=false" -EA SilentlyContinue -wait
		Write-Host "Manually Removing bundled 365 fr-fr"
		Start-Process "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeClickToRun.exe" -ArgumentList "scenario=install   scenariosubtype=ARP sourcetype=None productstoremove=O365HomePremRetail.16_fr-fr_x-none culture=fr-fr version.16=16.0 DisplayLevel=false" -EA SilentlyContinue -wait

}
}

