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
write-host "Removing Office tile from startmenu"
Get-AppxPackage *MicrosoftOfficeHub* | Remove-AppxPackage

write-host "Removing OneNote tile from startmenu"
Get-AppxPackage *OneNote* | Remove-AppxPackage
}
