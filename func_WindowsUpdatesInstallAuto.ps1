function WindowsUpdatesInstallAuto {
try {
		write-host "Setting up windows updates powershell modules"
		Install-PackageProvider -Name NuGet -RequiredVersion 2.8.5.201 -Force
		Install-Module PSWindowsUpdate -force
		write-host "Checking for and Installing windows updates - This might take a while"
		Get-WindowsUpdate -install -acceptall -IgnoreReboot | Format-Table -AutoSize
		Get-WindowsUpdate -MicrosoftUpdate -Download -Install -AcceptAll -IgnoreReboot
}
	catch {
		write-host "ERROR!" -ForegroundColor Red
		$_.Exception.Message
}
}
