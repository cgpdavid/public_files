<#
#Usage
#func_install_rc_phone
Set-ExecutionPolicy Bypass -Scope Process -force
remove-item $env:TEMP\func_install_rc_phone.ps1 -erroraction silentlycontinue
powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/func_install_rc_phone.ps1 -OutFile $env:TEMP\func_install_rc_phone.ps1"
powershell -c ". $env:TEMP\func_install_rc_phone.ps1;"

#>

remove-item $env:TEMP\func_CheckAndCreateITSFolders.ps1 -erroraction silentlycontinue
powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/func_CheckAndCreateITSFolders.ps1 -OutFile $env:TEMP\func_CheckAndCreateITSFolders.ps1"
powershell -exec bypass -c ". $env:TEMP\func_CheckAndCreateITSFolders.ps1; CheckAndCreateITSFolders"


$url = "https://downloads.ringcentral.com/sp/RingCentralForWindows"
$outpath = "$env:TEMP\RingCentral-Phone-MostRecent.msi"
$ProgressPreference = 'SilentlyContinue'
New-Item -ItemType Directory -Force -Path $env:TEMP\
Invoke-WebRequest -Uri $url -OutFile $outpath
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $outpath)
Write-Host "FileSource $url"
Write-Host "FileDestination $outpath"
Start-Process msiexec.exe -Wait -ArgumentList '/I "$env:TEMP\RingCentral-Phone-MostRecent.msi" ALLUSERS=1 /quiet /L*V! $env:TEMP\RingCentralPhone_install_log.txt'
