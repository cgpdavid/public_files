<# 
.SYNOPSIS
   Install Script for the latest version of Adobe Acrobat Reader DC.

.DESCRIPTION
   Finds, downloads & installs the latest version of Adobe Acrobat Reader DC.

.EXAMPLE
	remove-item $env:TEMP\script_adobereaderdc_FREE_downloadinstall.ps1 -erroraction silentlycontinue
	powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/script_adobereaderdc_FREE_downloadinstall.ps1 -OutFile $env:TEMP\script_adobereaderdc_FREE_downloadinstall.ps1"
	powershell -exec bypass -c ". $env:TEMP\script_adobereaderdc_FREE_downloadinstall.ps1"

.FUNCTIONALITY

   PowerShell v1+
   
.NOTES

# Download the latest Adobe Acrobat Reader DC x64
# https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/index.html
# https://armmf.adobe.com/arm-manifests/mac/AcrobatDC/reader/current_version.txt

#>

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Clear-Host
Write-Verbose "Starting Installation" -Verbose
$StartDTM = (Get-Date)

$LogPS = "C:\itsupport\logs\Adobe Acrobat Reader DC $Version PS Wrapper.log"

Start-Transcript $LogPS

## Get the latest version of adobe reader dc 

$Versionurl = "https://armmf.adobe.com/arm-manifests/mac/AcrobatDC/reader/current_version.txt"

try {
    $temp = New-TemporaryFile
    Invoke-WebRequest -UseBasicParsing -Uri $Versionurl -OutFile $temp -ErrorAction SilentlyContinue
    $Version = get-content $temp
}
catch {
    Throw "Failed to connect to URL: $url with error $_."
}

$UnattendedArgs = '/sAll /rs /msi EULA_ACCEPT=YES' 

# Get the link to the latest Adobe Acrobat Reader DC x64 installer
$Headers = @{
	"Sec-Fetch-Dest"   = "empty"
	"Sec-Fetch-Site"   = "same-origin"
	"X-Requested-With" = "XMLHttpRequest"
	Accept             = "*/*"
	"User-Agent"       = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.182 Safari/537.36 Edg/88.0.705.81"
	Referer            = "https://get.adobe.com/reader/otherversions/"
	DNT                = "1"
	"Accept-Language"  = "en_US;q=0.9,en;q=0.8"
	"Sec-Fetch-Mode"   = "cors"
	"Accept-Encoding"  = "gzip, deflate, br"
}
$Language = (Get-WinSystemLocale).EnglishName -split " " | Select-Object -Index 0
$TwoLetterISOLanguageName = (Get-WinSystemLocale).TwoLetterISOLanguageName
$Parameters = @{
	Uri             = "https://get.adobe.com/reader/webservices/json/standalone/?platform_type=Windows&platform_dist=Windows%2010&platform_arch=&language=$Language&eventname=readerotherversions"
	Headers         = $Headers
	UseBasicParsing = $true
}
$URL = ((Invoke-RestMethod @Parameters) | Where-Object -FilterScript {$_.aih_installer_abbr -eq "readerdc64_$TwoLetterISOLanguageName"}).download_url

# Prepare ITsupport folder
remove-item $env:TEMP\func_CheckAndCreateITSFolders.ps1 -erroraction silentlycontinue
powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/func_CheckAndCreateITSFolders.ps1 -OutFile $env:TEMP\func_CheckAndCreateITSFolders.ps1"
powershell -exec bypass -c ". $env:TEMP\func_CheckAndCreateITSFolders.ps1; CheckAndCreateITSFolders"

# Download the installer
$DownloadsFolder = "C:\itsupport\Installers\"
$Parameters = @{
	Uri             = $URL
	OutFile         = "$DownloadsFolder\AcroRdrDCx64.exe"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

# Extract to the "AcroRdrDCx64" folder
$Arguments = @(
	# Specifies the name of folder where the expanded package is placed
	"-sfx_o{0}" -f "$DownloadsFolder\AcroRdrDCx64"
	# Do not execute any file after installation (overrides the '-e' switch)
	"-sfx_ne"
)
Start-Process -FilePath "$DownloadsFolder\AcroRdrDCx64.exe" -ArgumentList $Arguments -Wait

# Extract AcroPro.msi to the "AcroPro.msi extracted" folder
$Arguments = @(
	"/a `"$DownloadsFolder\AcroRdrDCx64\AcroPro.msi`""
	"TARGETDIR=`"$DownloadsFolder\AcroRdrDCx64\AcroPro.msi extracted`""
	"/qb"
)
Start-Process "msiexec" -ArgumentList $Arguments -Wait

Remove-Item -Path "$DownloadsFolder\AcroRdrDCx64\Core.cab", "$DownloadsFolder\AcroRdrDCx64\Languages.cab", "$DownloadsFolder\AcroRdrDCx64\WindowsInstaller-KB893803-v2-x86.exe" -Force -ErrorAction Ignore
Remove-Item -Path "$DownloadsFolder\AcroRdrDCx64\VCRT_x64" -Recurse -Force
Get-ChildItem -Path "$DownloadsFolder\AcroRdrDCx64\AcroPro.msi extracted" -Recurse -Force | Move-Item -Destination "$DownloadsFolder\AcroRdrDCx64" -Force
Remove-Item -Path "$DownloadsFolder\AcroRdrDCx64\AcroPro.msi extracted" -Force

# Create the edited setup.ini
$PatchFile = (Get-Item -Path "$DownloadsFolder\AcroRdrDCx64\AcroRdrDCx64Upd*.msp").Name

# setup.ini
# https://www.adobe.com/devnet-docs/acrobatetk/tools/AdminGuide/properties.html
$CmdLine = @(
	"REMOVE_PREVIOUS=YES",
	"IGNOREVCRT64=1",
	"EULA_ACCEPT=YES",
	# Install updates automatically
	"UPDATE_MODE=3"
)

$setupini = @"
[Product]
msi=AcroPro.msi
PATCH=$PatchFile
CmdLine=$CmdLine
"@
Set-Content -Path "$DownloadsFolder\AcroRdrDCx64\setup.ini" -Value $setupini -Encoding Default -Force

# Initate installation of Acobrat reader dc

Write-Verbose "Starting Installation of Adobe Reader DC"
(Start-Process "$DownloadsFolder\AcroRdrDCx64\setup.exe" $UnattendedArgs -Wait -Passthru).ExitCode 

## Create Detection Method. 
$logfilespath = "C:\itsupport\logs\"
If(!(test-path $logfilespath))
{
      New-Item -ItemType Directory -Force -Path $logfilespath
}

New-Item -ItemType "file" -Path "C:\itsupport\logs\AdobeReaderDC-$Version.txt"

Write-Verbose "Stop logging" -Verbose
$EndDTM = (Get-Date)
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalSeconds) Seconds" -Verbose
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalMinutes) Minutes" -Verbose
Stop-Transcript
