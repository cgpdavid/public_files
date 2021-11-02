<#
#USAGE

#CheckAndCreateITSFolders
remove-item $env:TEMP\func_CheckAndCreateITSFolders.ps1 -erroraction silentlycontinue
powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/func_CheckAndCreateITSFolders.ps1 -OutFile $env:TEMP\func_CheckAndCreateITSFolders.ps1"
powershell -exec bypass -c ". $env:TEMP\func_CheckAndCreateITSFolders.ps1; CheckAndCreateITSFolders"

#>


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
		if (!(Test-Path "C:\itsupport\scripts\")){
            Write-Host "Creating Logs directory"
			New-Item -Path "C:\itsupport\" -Name "scripts" -ItemType "directory"
		}
		else {
			Write-Host "Scripts Path exists"
		}
	}

	catch {
		write-host "ERROR!" -ForegroundColor Red
		$_.Exception.Message
	}
}
