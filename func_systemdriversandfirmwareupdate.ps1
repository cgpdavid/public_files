
	
	
<#
#usage

#systemdriversandfirmwareupdate
remove-item $env:TEMP\func_systemdriversandfirmwareupdate.ps1 -erroraction silentlycontinue
powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/func_systemdriversandfirmwareupdate.ps1 -OutFile $env:TEMP\func_systemdriversandfirmwareupdate.ps1"
powershell -exec bypass -c ". $env:TEMP\func_systemdriversandfirmwareupdate.ps1; systemdriversandfirmwareupdate"

#>

Function systemdriversandfirmwareupdate {

#CheckAndCreateITSFolders
	remove-item $env:TEMP\func_CheckAndCreateITSFolders.ps1 -erroraction silentlycontinue
	powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/func_CheckAndCreateITSFolders.ps1 -OutFile $env:TEMP\func_CheckAndCreateITSFolders.ps1"
	powershell -exec bypass -c ". $env:TEMP\func_CheckAndCreateITSFolders.ps1; CheckAndCreateITSFolders"
	

if (Get-WmiObject win32_SystemEnclosure -Filter: "Manufacturer LIKE 'Dell Inc.'") { 
    $isDellSystem = $true
    Write-Host "This computer is a Dell"
	
	#Patch system using Dell Command Update
		$fileToCheck = "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe"
		if (Test-Path $fileToCheck -PathType leaf){
			write-host "Dell Command Update found in C:\Program Files\" -ForegroundColor green
			write-host "Patching system using DCU"
			Start-Process "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe" -ArgumentList "/configure -silent -autoSuspendBitLocker=enable -userConsent=disable" -Wait
			Start-Process "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe" -ArgumentList "/scan -outputLog=C:\itsupport\logs\Dell_DCU_Update_log.log" -Wait
			Start-Process "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe" -ArgumentList "/applyUpdates -reboot=disable -outputLog=C:\itsupport\logs\applyUpdates.log" -Wait
		}else {
			write-host "Dell Command Update not installed in Program Files, checking  Program Files (x86)"
			$fileToCheck = "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe"
			if (Test-Path $fileToCheck -PathType leaf){
				write-host "Dell Command Update found in C:\Program Files (x86)\" -ForegroundColor yellow
				write-host "Patching system using DCU"
				Start-Process "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe" -ArgumentList "/configure -silent -autoSuspendBitLocker=enable -userConsent=disable" -Wait
				Start-Process "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe" -ArgumentList "/scan -outputLog=C:\itsupport\logs\Dell_DCU_Update_log.log" -Wait
				Start-Process "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe" -ArgumentList "/applyUpdates -reboot=disable -outputLog=C:\itsupport\logs\applyUpdates.log" -Wait
		}else {
			write-host "We could not locate dell command update!" -ForegroundColor Red
            if ($DcuInstallAttempt -eq $null) {
			write-host "Installing Dell Command Update"
			write-host "Removing conflicting dell update applications if any before proceding"
			
			#remove dell update and dell update UWX
			$productNames = @("*Dell Update for Windows Universal*")
			$UninstallKeys = @('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall','HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall')
			$results = foreach ($key in (Get-ChildItem $UninstallKeys) ) {foreach ($product in $productNames) {if ($key.GetValue("DisplayName") -like "$product") {[pscustomobject]@{KeyName = $key.Name.split('\')[-1];DisplayName = $key.GetValue("DisplayName");UninstallString = $key.GetValue("UninstallString");}}}}
			$Guid = $results.KeyName
			if ($guid) {
			Start-Process msiexec.exe -Wait -ArgumentList "/X$Guid /passive"
			}
			
			$results = foreach ($key in (Get-ChildItem $UninstallKeys) ) {foreach ($product in $productNames) {if ($key.GetValue("DisplayName") -like "$product") {[pscustomobject]@{KeyName = $key.Name.split('\')[-1];DisplayName = $key.GetValue("DisplayName");UninstallString = $key.GetValue("UninstallString");}}}}
			$Guid = $results.KeyName
			if ($guid) {
				Start-Process msiexec.exe -Wait -ArgumentList "/X$Guid /passive"
			}

			$WinVersion = ([System.Environment]::OSVersion.Version).Major
				if ($WinVersion -eq "10") {
					if ((Get-AppxPackage | Where-Object { $_.name -eq "DellInc.DellUpdate" } | Select-Object name -expandproperty name) -eq "DellInc.DellUpdate") {
						Get-AppxPackage | Where-Object { $_.name -eq "DellInc.DellUpdate" } | Remove-AppxPackage
					}
				}
				
			write-host "downloading and Installing Dell Command Update now"
			# Choco Install Basic Packages
			remove-item c:\itsupport\scripts\cgp-choco-appinstall.ps1 -erroraction silentlycontinue
			powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/cgp-choco-appinstall.ps1 -OutFile c:\itsupport\scripts\cgp-choco-appinstall.ps1; c:\itsupport\scripts\cgp-choco-appinstall.ps1"
			SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
			C:\ProgramData\chocolatey\bin\choco install dellcommandupdate --pre --yes
			$DcuInstallAttempt = $true
			
			write-host "Sleeping for 5 seconds to let windows catch up"
			Start-Sleep -s 5
			#LaunchDCU
			DellDcuUpdate
			
			if ($DcuInstallAttempt -eq $true) {
				write-error "Error! We tried to install DCU but it failed"
                write-host "This might be a Dell XPS, Alienware, Inspiron, Vostro, etc system"
				write-host "It likely has Dell Update installed (Not Dell Command Update)"
                write-host "Which are incompatible."
				
			
			} else {
				write-error "Error!"
				
			}
			

		}

		}
		}

    } elseif (Get-WmiObject win32_SystemEnclosure -Filter: "Manufacturer LIKE 'LENOVO'") { 
	write-host "Detected a Lenovo system! - setting up LSU backend"
	write-host "You maybe be required to reboot immediately after completing this. This should be the last step in scripts."
	Set-ExecutionPolicy -ExecutionPolicy Bypass -force
	Import-Module PowerShellGet
	Install-Module -Name LSUClient -force
	write-host "Checking for ALL updates (silent and interactive only)"
	Get-LSUpdate
	write-host "Installing SILENT only updates"
	$updates = Get-LSUpdate | Where-Object { $_.Installer.Unattended }
	$updates | Install-LSUpdate -Verbose
	write-host "DONE!"

	} else { 
    $manufacturer = $(Get-WmiObject win32_SystemEnclosure | Select-Object Manufacturer)
    Write-Host "This system could not be identified as Dell nor a Lenovo system - Found manufacturer: $manufacturer" 
	}

}
