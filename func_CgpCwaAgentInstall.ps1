function CgpCwaAgentInstall {

$CgpAgentUrl = (read-host "What is the CgpAgentUrl: ")
$CwaClientLocationID = (read-host "What is the CwaClientLocationID: ")
$CgpCwaServerAddress= (read-host "What is the CgpCwaServerAddress: ")
$CgpCwaServerPwd= (read-host "What is the CgpCwaServerPwd: ")

# NOTICE! must set $CgpAgentUrl, $CwaClientLocationID , $CgpCwaServerAddress, and $CgpCwaServerPwd
try {
		write-host "Downloading CGP Agent"
		#-Download agent from CWA Server
		$url = $CgpAgentUrl
		$outpath = "C:\itsupport\installers\Agent_Install.MSI"
		Invoke-WebRequest -Uri $url -OutFile $outpath
		$wc = New-Object System.Net.WebClient
		$wc.DownloadFile($url, $outpath)
		
		write-host "sleeping for 5 seconds"
		Start-Sleep -s 5
		write-host "Installing CGP Agent"
		$ArgumentList = '/I "C:\itsupport\installers\Agent_Install.MSI" /quiet /norestart /L*V! C:\itsupport\logs\cgp_agent_install_log.txt SERVERADDRESS=$CgpCwaServerAddress SERVERPASS=$CgpCwaServerPwd LOCATION=$CwaClientLocationID'
		Start-Process msiexec.exe -Wait -ArgumentList $ArgumentList
		write-host "Installer exited. Sleeping for 30 seconds."
		Start-Sleep -s 30
		write-host "Checking if LTService service exists"
		$service = Get-Service -Name LTService -ErrorAction SilentlyContinue
		if($service -eq $null){
			write-host "ERROR! Service does not exist" -ForegroundColor Red
			write-host "ERROR! Service does not exist" -ForegroundColor Red
			write-host "ERROR! Service does not exist" -ForegroundColor Red
			write-host "ERROR! Service does not exist" -ForegroundColor Red
			write-host "ERROR! Service does not exist" -ForegroundColor Red
			} else 
			{
			# Service does exist
			write-host "HUGE SUCCESS. It's hard to overstate. My satisfaction" -ForegroundColor green
			write-host "LTService DOES exist!" -ForegroundColor green
			}

}
	catch {
		write-host "ERROR!" -ForegroundColor Red
		$_.Exception.Message
}
}
