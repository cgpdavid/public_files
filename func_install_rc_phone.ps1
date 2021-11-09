<#
#Usage
remove-item c:\itsupport\scripts\func_install_rc_phone.ps1 -erroraction silentlycontinue
powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/func_install_rc_phone.ps1 -OutFile c:\itsupport\scripts\func_install_rc_phone.ps1"
powershell -c ". c:\itsupport\scripts\func_install_rc_phone.ps1;"

#>

remove-item $env:TEMP\func_CheckAndCreateITSFolders.ps1 -erroraction silentlycontinue
powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/func_CheckAndCreateITSFolders.ps1 -OutFile $env:TEMP\func_CheckAndCreateITSFolders.ps1"
powershell -exec bypass -c ". $env:TEMP\func_CheckAndCreateITSFolders.ps1; CheckAndCreateITSFolders"


$url = "https://downloads.ringcentral.com/sp/RingCentralForWindows"
$outpath = "C:\itsupport\installers\RingCentral-Phone-MostRecent.msi"
$ProgressPreference = 'SilentlyContinue'
New-Item -ItemType Directory -Force -Path C:\itsupport\installers\
Invoke-WebRequest -Uri $url -OutFile $outpath
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $outpath)
Write-Host "FileSource $url"
Write-Host "FileDestination $outpath"
Start-Process msiexec.exe -Wait -ArgumentList '/I "C:\itsupport\installers\RingCentral-Phone-MostRecent.msi" ALLUSERS=1 /quiet /L*V! C:\itsupport\logs\RingCentralPhone_install_log.txt'



