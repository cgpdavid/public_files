<#
Notes:
This is rough, but working.
The ringcentral install process writes logs, but does not do much error catching in terms of looking up MSI exit codes.
Additionally, write-host is used extensively in the refferenced RC install script, which is not optimal for use with CWA. 



#>

#!ps
$productNames = @("*ringcentral*")
$UninstallKeys = @('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall','HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall')
$results = foreach ($key in (Get-ChildItem $UninstallKeys) ) {foreach ($product in $productNames) {if ($key.GetValue("DisplayName") -like "$product") {[pscustomobject]@{KeyName = $key.Name.split('\')[-1];DisplayName = $key.GetValue("DisplayName");QuietUninstallString = $key.GetValue("QuietUninstallString");}}}}
if ($results){
	write-Output "Ringcentral installation detected - exiting"
	} else {
		write-Output "RingCentral not detected - proceeding"
		#func_install_rc_phone
		write-Output "Downloading and installing the latest RC phone application"
		remove-item $env:TEMP\func_install_rc_phone.ps1 -erroraction silentlycontinue
		powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/func_install_rc_phone.ps1 -OutFile $env:TEMP\func_install_rc_phone.ps1"
		powershell -c ". $env:TEMP\func_install_rc_phone.ps1;"
		write-output "Done"
		}
