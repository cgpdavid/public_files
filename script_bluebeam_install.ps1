#BLUEBEAM 
#CheckAndCreateITSFolders
remove-item $env:TEMP\func_CheckAndCreateITSFolders.ps1 -erroraction silentlycontinue
powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/func_CheckAndCreateITSFolders.ps1 -OutFile $env:TEMP\func_CheckAndCreateITSFolders.ps1"
powershell -exec bypass -c ". $env:TEMP\func_CheckAndCreateITSFolders.ps1; CheckAndCreateITSFolders"

write-host "INSTALLING BLUEBEAM REVU"
		
if (!(Test-Path "C:\itsupport\Installers\BlueBeam\")){
	Write-Host "Creating Logs directory"
	New-Item -Path "C:\itsupport\Installers\" -Name "BlueBeam" -ItemType "directory"
	}
	write-host "Downloading Bluebeam - Its over 1.2GB typically - this will take a long while"
	Invoke-WebRequest "https://www.bluebeam.com/MSIdeployx64" -OutFile C:\itsupport\Installers\BlueBeam\MSIBluebeamRevuLATESTx64.zip
	write-host "Extracting Bluebeam"
	Expand-Archive -LiteralPath 'C:\itsupport\Installers\BlueBeam\MSIBluebeamRevuLATESTx64.zip' -DestinationPath C:\itsupport\Installers\BlueBeam\
	Copy-Item "C:\itsupport\Installers\BlueBeam\Uninstall Previous Versions.txt" "C:\itsupport\Installers\BlueBeam\Uninstall Previous Versions.bat"
	write-host "cleaning system of prior Bluebeam versions"
	start-process "cmd.exe" "/c C:\itsupport\Installers\BlueBeam\Uninstall Previous Versions.bat"
		
		
		$fileToCheck = "$Env:Programfiles\Bluebeam Software\Bluebeam Revu"
		if (![System.IO.File]::Exists($fileToCheck)){
			
			$BB_SERIALNUMBER = Read-Host "What is the SERIAL NUMBER?"
			$BB_PRODUCTKEY = Read-Host "What is the PRODUCT KEY?"
			$BB_EDITION = read-host "What edition of REVU are you installing? (enter 0 for Standard, 1 for CAD, 2 for Extreme)"
			Start-Process C:\itsupport\Installers\BbRevuLATEST.exe -ArgumentList "/QN BB_SERIALNUMBER=$BB_SERIALNUMBER BB_PRODUCTKEY=$BB_PRODUCTKEY BB_EDITION=$BB_EDITION /qn"
			Start-Process msiexec.exe -Wait -ArgumentList '/I "C:\itsupport\Installers\BbRevuLATEST.exe " /quiet /norestart /L*V! $LogPath\cgp_agent_install_log.txt'
		} else {
			write-host "Detected Bluebeam in $Env:Programfiles\Bluebeam Software\Bluebeam Revu"
			
		}
		
	
