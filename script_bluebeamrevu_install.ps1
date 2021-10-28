#BLUEBEAM 
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
	start-process "C:\itsupport\Installers\BlueBeam\Uninstall Previous Versions.bat" -Wait

		
	$fileToCheck = "$Env:Programfiles\Bluebeam Software\Bluebeam Revu\20\Revu\Revu.exe"
	if (![System.IO.File]::Exists($fileToCheck)){
		write-host "Bluebeam 20 not detected, continuing"
		set-location "C:\itsupport\Installers\BlueBeam\"
		$BB_SERIALNUMBER = Read-Host "What is the SERIAL NUMBER? (usually formated xxxxxxx)"
		$BB_PRODUCTKEY = Read-Host "What is the PRODUCT KEY? (usually xxxxx-xxxxxxx format)"
		$BB_EDITION = read-host "What edition of REVU are you installing? (enter 0 for Standard, 1 for CAD, 2 for Extreme)"
		write-host "Launching Bluebeam installer - this will take at least 5 minutes"
		msiexec.exe /i "Bluebeam Revu x64 20.msi" BB_SERIALNUMBER=$BB_SERIALNUMBER BB_PRODUCTKEY=$BB_PRODUCTKEY BB_EDITION=$BB_EDITION BB_DESKSHORTCUT=1 BB_DEFAULTVIEWER=1 /qn /L*V! C:\itsupport\logs\bb_revu_install_log.txt
		Start-Sleep 300
		write-host "Launching Bluebeam OCR installer - this will take 2-3 minutes"
		msiexec.exe /i "BluebeamOCR x64 20.msi" /qn /L*V! C:\itsupport\logs\bb_revu_OCR_install_log.txt
		Start-Sleep 180
		write-host "DONE exiting"
		start-sleep 10
		
	} else {
		write-host "Not continuing!  Detected Bluebeam in $Env:Programfiles\Bluebeam Software\Bluebeam Revu"
		
	}
