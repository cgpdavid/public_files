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
	
		#Write Config to registry
		if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels") -ne $true) {  New-Item "HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels" -force -ea SilentlyContinue };
		if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$VPNConnectionName") -ne $true) {  New-Item "HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$VPNConnectionName" -force -ea SilentlyContinue };
		New-ItemProperty -LiteralPath HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$VPNConnectionName -Name 'Description' -Value $VPNdescription -PropertyType String -Force -ea SilentlyContinue;
		New-ItemProperty -LiteralPath HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$VPNConnectionName -Name 'Server' -Value $VPNserverAddress -PropertyType String -Force -ea SilentlyContinue;
		New-ItemProperty -LiteralPath HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$VPNConnectionName -Name 'promptusername' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;
		New-ItemProperty -LiteralPath HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$VPNConnectionName -Name 'promptcertificate' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;
		New-ItemProperty -LiteralPath HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$VPNConnectionName -Name 'DATA3' -Value '' -PropertyType String -Force -ea SilentlyContinue;
		New-ItemProperty -LiteralPath HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$VPNConnectionName -Name 'ServerCert' -Value '1' -PropertyType String -Force -ea SilentlyContinue;
		New-ItemProperty -LiteralPath HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$VPNConnectionName -Name 'dual_stack' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;
		New-ItemProperty -LiteralPath HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$VPNConnectionName -Name 'sso_enabled' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;
		New-ItemProperty -LiteralPath HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$VPNConnectionName -Name 'use_external_browser' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;
}
else {
	write-host "Forticlient not detected - skipping config import" -ForegroundColor yellow
}
}
