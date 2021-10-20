function CheckAndCreateITSFolders {
	try {
		if (!(Test-Path "C:\itsupport\installers\")){
		Write-Host "Creating Installers directory"
		New-Item -Path "C:\itsupport\" -Name "Installers" -ItemType "directory"
		}
		else {
		Write-Host "Installers path exists"
		}
		if (!(Test-Path "C:\itsupport\temp\")){
			Write-Host "Creating Temp directory"
			New-Item -Path "C:\itsupport\" -Name "temp" -ItemType "directory"
		}
		else {
			Write-Host "Temporary Path exists"
		}
		if (!(Test-Path "C:\itsupport\logs\")){
            Write-Host "Creating Logs directory"
			New-Item -Path "C:\itsupport\" -Name "logs" -ItemType "directory"
		}
		else {
			Write-Host "Logs Path exists"
		}
	}

	catch {
		write-host "ERROR!" -ForegroundColor Red
		$_.Exception.Message
	}
}
