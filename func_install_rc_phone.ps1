<#
#Usage

#func_install_rc_phone
Set-ExecutionPolicy Bypass -Scope Process -force
remove-item $env:TEMP\func_install_rc_phone.ps1 -erroraction silentlycontinue
powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/func_install_rc_phone.ps1 -OutFile $env:TEMP\func_install_rc_phone.ps1"
powershell -c ". $env:TEMP\func_install_rc_phone.ps1;"

#>

#Checking if Ringcentral is installed
$fileToCheck = "C:\Program Files (x86)\RingCentral\SoftPhoneApp\Softphone.exe"
if (-not(Test-Path $fileToCheck -PathType leaf)){
	write-host "RingCentral phone not detected - proceeding"
	#Setup working enviorment folders
	remove-item $env:TEMP\func_CheckAndCreateITSFolders.ps1 -erroraction silentlycontinue
	powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/func_CheckAndCreateITSFolders.ps1 -OutFile $env:TEMP\func_CheckAndCreateITSFolders.ps1"
	powershell -exec bypass -c ". $env:TEMP\func_CheckAndCreateITSFolders.ps1; CheckAndCreateITSFolders"

	#Ringcentral touches spooler driver folder for somereason - need to bypass PrintNightmare Just in case
	Write-Host 'Bypassing Print Nightmare ACL' -ForegroundColor Green
	$Path = "C:\Windows\System32\spool\drivers"
	$Acl = (Get-Item $Path).GetAccessControl('Access')
	$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule("System", "Modify", "ContainerInherit, ObjectInherit", "None", "Deny")
	$Acl.RemoveAccessRule($Ar)
	Set-Acl $Path $Acl

	#fetching most recent installer and running it with logging
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
} else {
	write-host "Ringcentral phone is already installed - exiting"
}
