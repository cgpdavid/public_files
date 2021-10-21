function RemoveFromAzureAD {
	
	$dsreg = dsregcmd.exe /status
	if (($dsreg | Select-String "AzureAdJoined :") -match "NO") {
		write-host "Computer is NOT Azure domain joined! Skipping!"
	} elseif (($dsreg | Select-String "AzureAdJoined :") -match "YES"){
	Write-host "dsregcmd.exe reports that this PC is AzureAD Joined...."
	write-host "Trying to Un-join $env:COMPUTERNAME from Azure AD!"
	Write-Verbose "by running: Invoke-AsSystem { dsregcmd.exe /leave /debug } -returnTranscript"
	Invoke-AsSystem { dsregcmd.exe /leave /debug } #-returnTranscript
	Start-Sleep 5
	Get-ChildItem 'Cert:\LocalMachine\My\' | ? { $_.Issuer -match "MS-Organization-Access|MS-Organization-P2P-Access \[\d+\]" } | % {
		Write-Host "Removing leftover Hybrid-Join certificate $($_.DnsNameList.Unicode)" -ForegroundColor Cyan
		Remove-Item $_.PSPath
	}
	
	$dsreg = dsregcmd.exe /status
	if (!(($dsreg | Select-String "AzureAdJoined :") -match "NO")) {
		throw "$env:COMPUTERNAME is still joined to Azure. Run again"
	}
	}
	
	
}
