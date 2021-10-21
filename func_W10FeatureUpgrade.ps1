function W10FeatureUpgrade {
#Download and install feature update
try {
		
		write-host "Downloading windows 10 feature upgrade"
		$webClient = New-Object System.Net.WebClient
		$url = 'https://go.microsoft.com/fwlink/?LinkID=799445'
		$file = "C:\itsupport\installers\Win10Upgrade.exe"
		$webClient.DownloadFile($url,$file)
}
	catch {
		write-host "ERROR!" -ForegroundColor Red
		$_.Exception.Message
}

#Windows 10 feature upgrade
try {
		$fileToCheck = "C:\itsupport\installers\Win10Upgrade.exe"
		if (Test-Path $fileToCheck -PathType leaf)
		{
			write-host "Launching windows 10 feature upgrade"
			Start-Process -FilePath $file -ArgumentList '/skipeula /auto upgrade /copylogs c:\itsupport\logs\'
			write-host "sleeping for 5 seconds"
			Start-Sleep -s 5
			Remove-Item "C:\users\*\Desktop\Windows 10 Update Assistant.lnk" –Force -erroraction silentlycontinue
	
		}
		else {
			write-host "We could not find the windows 10 upgrade installer!" -ForegroundColor Red
		}
		
		
}
	catch {
		write-host "ERROR!" -ForegroundColor Red
		$_.Exception.Message
}
}
