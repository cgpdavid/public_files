function FortiClientVpnInstallandConfigure {
write-host "DOWNLOADING AND INSTALLING FORTICLIENT"
Invoke-WebRequest "https://links.fortinet.com/forticlient/win/vpnagent" -OutFile C:\itsupport\installers\forticlientVPN.exe
Start-Process C:\itsupport\installers\forticlientVPN.exe -ArgumentList "/quiet /norestart /log c:\itsupport\logs\forticlientvpn_log_stage1.txt" -Wait
Start-Process $env:TEMP\FortiClientVPN.exe -ArgumentList "/quiet /norestart /log c:\itsupport\logs\forticlientvpn_log_stage2.txt" -Wait

#---- Setting VPN Settings	
$fileToCheck = "C:\Program Files\Fortinet\FortiClient\FortiClient.exe"
if (Test-Path -Path $fileToCheck -PathType leaf)
{
	write-host "Forticlient detected - Importing config" -ForegroundColor Green
	# Must assign variable values for $VPNConnectionName , $VPNdescription , $VPNserverAddress
	write-host "VPN Connection variable set to " $VPNConnectionName
	write-host "VPN Description variable set to " $VPNdescription
	write-host "VPN Server Address variable set to " $VPNserverAddress
	
	}
else {
	write-host "Forticlient not detected - skipping config import" -ForegroundColor yellow
}
}
