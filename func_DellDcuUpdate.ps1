Function DellDcuUpdate {
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
		}
		else {
			write-host "Dell Command Update not installed in Program Files, checking  Program Files (x86)"
			$fileToCheck = "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe"
			if (Test-Path $fileToCheck -PathType leaf){
				write-host "Dell Command Update found in C:\Program Files (x86)\" -ForegroundColor yellow
				write-host "Patching system using DCU"
				Start-Process "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe" -ArgumentList "/configure -silent -autoSuspendBitLocker=enable -userConsent=disable" -Wait
				Start-Process "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe" -ArgumentList "/scan -outputLog=C:\itsupport\logs\Dell_DCU_Update_log.log" -Wait
				Start-Process "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe" -ArgumentList "/applyUpdates -reboot=disable -outputLog=C:\itsupport\logs\applyUpdates.log" -Wait
		}
		else {
			write-host "We could not locate dell command update!" -ForegroundColor Red
		}
		}

    } 
	else { 
    $manufacturer = $(Get-WmiObject win32_SystemEnclosure | Select-Object Manufacturer)
    Write-Host "This system could not be identified as Dell system - Found manufacturer: $manufacturer" 
}
}
