function FortiClientVpnInstallandConfigure {
write-host "DOWNLOADING AND INSTALLING FORTICLIENT"
Invoke-WebRequest "https://links.fortinet.com/forticlient/win/vpnagent" -OutFile C:\itsupport\installers\forticlientVPN.exe
Start-Process C:\itsupport\installers\forticlientVPN.exe -ArgumentList "/quiet /norestart /log c:\itsupport\logs\forticlientvpn_log_stage1.txt" -Wait
Start-Process $env:TEMP\FortiClientVPN.exe -ArgumentList "/quiet /norestart /log c:\itsupport\logs\forticlientvpn_log_stage2.txt" -Wait

}
