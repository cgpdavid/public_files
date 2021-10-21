function JoinToDomain {
param (
    [CmdletBinding()]
    [Parameter(Position=0,mandatory=$true)]
    [string]$DomainJoinDomain
)

if(-not($DomainJoinDomain)) { Throw “DomainJoinDomain has not been defined! for -DomainJoinDomain” }

	#Must set $DomainJoinDomain before function! (TLD REQUIRED! cgp.local or ad.cgp.com for example... NOT just "cgp")
	$dsreg = dsregcmd.exe /status
	if (($dsreg | Select-String "DomainJoined :") -match "YES") {
		write-host "dsregcmd.exe reports that this PC is DOMAIN Joined!"
		write-host "It is currently joined to the domain:" $env:userdomain
		write-host "continuing - but if this is the incorrect domain, please remove and rejoin manually"
		
	} elseif (($dsreg | Select-String "DomainJoined :") -match "NO"){
		Write-host "dsregcmd.exe reports that this PC, $env:COMPUTERNAME, is NOT Domain Joined."
		Write-Verbose "Attempting to Join the domain now - prompting your for domain and credentials"
		Write-host "Joining the domain:" $DomainJoinDomain
		write-host "Will Prompt you for credentials"
		add-computer -domainname $DomainJoinDomain -force
	}
}
