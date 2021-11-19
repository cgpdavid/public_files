<#
#Usage
remove-item $env:TEMP\script_cwa_universaluninstaller.ps1 -erroraction silentlycontinue
powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/script_cwa_universaluninstaller.ps1 -OutFile $env:TEMP\script_cwa_universaluninstaller.ps1"
powershell -exec bypass -c ". $env:TEMP\script_cwa_universaluninstaller.ps1"

#>

$url = "https://s3.amazonaws.com/assets-cp/assets/Agent_Uninstaller.zip"
$output = "C:\itsupport\installers\Agent_Uninstaller.zip"
(New-Object System.Net.WebClient).DownloadFile($url, $output)
[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory('C:\itsupport\installers\Agent_Uninstaller.zip', 'C:\itsupport\Temp\LTAgentUninstaller')
Start-Process -FilePath "C:\itsupport\Temp\LTAgentUninstaller\Agent_Uninstall.exe"


