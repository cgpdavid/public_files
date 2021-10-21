function JoinToDomain {
	#Must set $DomainJoinDomain before function! (TLD REQUIRED! cgp.local or ad.cgp.com for example... NOT just "cgp")
	$dsreg = dsregcmd.exe /status
	if (($dsreg | Select-String "DomainJoined :") -match "YES") {
		write-host "dsregcmd.exe reports that this PC is DOMAIN Joined!"
		write-host "It is currently joined to the domain:" $env:userdomain
		write-host "continuing - but if this is the incorrect domain, please remove and rejoin manually"
		
	} elseif (($dsreg | Select-String "DomainJoined :") -match "NO"){
		Write-host "dsregcmd.exe reports that this PC, $env:COMPUTERNAME, is NOT Domain Joined."
		Write-Verbose "Attempting to Join the domain now - prompting your for domain and credentials"
		$DomainJoinCred = (read-host "What is your CGP client domain username? (not your internal credentials)")
		Write-host "Joining domain"
		add-computer –domainname $DomainJoinDomain -Credential $DomainJoinCred –force
	}
}
