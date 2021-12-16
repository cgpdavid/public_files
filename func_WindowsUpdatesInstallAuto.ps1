#WindowsUpdatesInstallAuto
#Lists all the updates, then auto installs them
remove-item $env:TEMP\func_WindowsUpdatesInstallAuto.ps1 -erroraction silentlycontinue
powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/func_WindowsUpdatesInstallAuto.ps1 -OutFile $env:TEMP\func_WindowsUpdatesInstallAuto.ps1"
Set-ExecutionPolicy Bypass -Scope Process -force
powershell -c ". $env:TEMP\func_WindowsUpdatesInstallAuto.ps1; WindowsUpdatesInstallAuto"



function WindowsUpdatesInstallAuto {
try {
		write-host "Setting up windows updates powershell modules"
		Install-PackageProvider -Name NuGet -Force
		Install-Module PSWindowsUpdate -force
		write-host "Checking for and Installing windows updates - This might take a long time"
		Get-WindowsUpdate
		Get-WindowsUpdate -install -acceptall -IgnoreReboot | Format-Table -AutoSize
		Get-WindowsUpdate -MicrosoftUpdate -Download -Install -AcceptAll -IgnoreReboot
}
	catch {
		write-host "ERROR!" -ForegroundColor Red
		$_.Exception.Message
}
}
