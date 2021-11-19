$url = "https://s3.amazonaws.com/assets-cp/assets/Agent_Uninstaller.zip"
$output = "C:\itsupport\installers\Agent_Uninstaller.zip"
(New-Object System.Net.WebClient).DownloadFile($url, $output)
[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory('C:\itsupport\installers\Agent_Uninstaller.zip', 'C:\itsupport\Temp\LTAgentUninstaller')
Start-Process -FilePath "C:\itsupport\Temp\LTAgentUninstaller\Agent_Uninstall.exe"


