<#
#USAGE

#NTFSECURITY_SMB_Shares_Audit_Script.ps1
remove-item $env:TEMP\NTFSECURITY_SMB_Shares_Audit_Script.ps1 -erroraction silentlycontinue
powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/scripts/NTFSECURITY_SMB_Shares_Audit_Script.ps1 -OutFile $env:TEMP\NTFSECURITY_SMB_Shares_Audit_Script.ps1"
powershell -exec bypass -c ". $env:TEMP\NTFSECURITY_SMB_Shares_Audit_Script.ps1;"

#>



$RecursiveDepth = 2
$head = @"
<script>
function myFunction() {
    const filter = document.querySelector('#myInput').value.toUpperCase();
    const trs = document.querySelectorAll('table tr:not(.header)');
    trs.forEach(tr => tr.style.display = [...tr.children].find(td => td.innerHTML.toUpperCase().includes(filter)) ? '' : 'none');
  }</script>
<Title>Audit Log Report</Title>
<style>
body { background-color:#E5E4E2;
      font-family:Monospace;
      font-size:10pt; }
td, th { border:0px solid black; 
        border-collapse:collapse;
        white-space:pre; }
th { color:white;
    background-color:black; }
table, tr, td, th {
     padding: 2px; 
     margin: 0px;
     white-space:pre; }
tr:nth-child(odd) {background-color: lightgray}
table { width:95%;margin-left:5px; margin-bottom:20px; }
h2 {
font-family:Tahoma;
color:#6D7B8D;
}
.footer 
{ color:green; 
 margin-left:10px; 
 font-family:Tahoma;
 font-size:8pt;
 font-style:italic;
}
#myInput {
  background-image: url('https://www.w3schools.com/css/searchicon.png'); /* Add a search icon to input */
  background-position: 10px 12px; /* Position the search icon */
  background-repeat: no-repeat; /* Do not repeat the icon image */
  width: 50%; /* Full-width */
  font-size: 16px; /* Increase font-size */
  padding: 12px 20px 12px 40px; /* Add some padding */
  border: 1px solid #ddd; /* Add a grey border */
  margin-bottom: 12px; /* Add some space below the input */
}
</style>
"@

function InstallModuleNTFSSecurity {
	install-module "NTFSSecurity" -Force; import-module "NTFSSecurity"
	If(Get-Module -ListAvailable -Name "NTFSSecurity") {
		write-host "NTFSSecurity Module not found!"
		write-host "Trying to install package using Powershell gallery through install-module"
		Install-Module -Name NTFSSecurity
	}
	Else{
		write-host "Error - Could not import. Manually installing NTFSSecurity"
		$TempPath = "C:\itsupport\temp\"
		if (!(Test-Path $TempPath)){
			Write-Host "Creating Reports directory"
			New-Item -ItemType "directory" -Path $TempPath 
		}
		Invoke-WebRequest -Uri "https://www.powershellgallery.com/api/v2/package/NTFSSecurity/" -OutFile $TempPath\NTFSSecurity_latest.zip
		Expand-Archive -Path $TempPath\NTFSSecurity_latest.zip -DestinationPath $TempPath\NTFSSecurity_latest\
		$VersionFilePath = "C:\itsupport\temp\NTFSSecurity_latest\package\services\metadata\core-properties\"
		$VersionFile = Get-ChildItem $VersionFilePath -Recurse -Force -Include *.psmdcp* -name
		[xml]$XmlDocument = Get-Content -Path $VersionFilePath$VersionFile
		$version = $XmlDocument.coreProperties.version
		Move-Item -Path $TempPath\NTFSSecurity_latest\ -Destination $TempPath\$version
		if (!(Test-Path $env:ProgramFiles\WindowsPowerShell\Modules\NTFSSecurity)){
			Write-Host "Creating Reports directory"
			New-Item -ItemType "directory" -Path $env:ProgramFiles\WindowsPowerShell\Modules\NTFSSecurity
		}
		Move-Item -Path $TempPath\$version -Destination $env:ProgramFiles\WindowsPowerShell\Modules\NTFSSecurity
		write-host "Done processing manual install - Attempting module import now"
		If(Get-Module -ListAvailable -Name "NTFSSecurity") {Import-module "NTFSSecurity";write-host "Detected moving along!";} Else {write-host "COULD NOT INSTALL MODULE, EXITING!!!!!";Break ;}
		
	}
}

$timestamp = $(get-date -f yyyy-MM-dd_HH-mm-ss)
$FolderPath = "C:\itsupport\reports\smb_share_ntfs_audit_" + $timestamp 
if (!(Test-Path $FolderPath)){
	Write-Host "Creating Reports directory"
	New-Item -ItemType "directory" -Path $FolderPath
}

If(Get-Module -ListAvailable -Name "NTFSSecurity") {Import-module "NTFSSecurity"} Else { InstallModuleNTFSSecurity}
write-host "NTFSSecurity Module detecting - Continuing"
write-host "Running reports now - This may take some time!"
$AllsmbShares = get-smbshare | Where-Object {(@('Remote Admin','Default share','Remote IPC') -notcontains $_.Description)}
foreach($SMBShare in $AllSMBShares){
$Permissions = get-item $SMBShare.path | get-ntfsaccess
$Permissions += get-childitem -Depth $RecursiveDepth -Recurse $SMBShare.path | get-ntfsaccess
$FullAccess = $permissions | where-object {$_.'AccessRights' -eq "FullControl" -AND $_.IsInherited -eq $false -AND $_.'AccessControlType' -ne "Deny"}| Select-Object FullName,Account,AccessRights,AccessControlType  | ConvertTo-Html -PreContent "<h1>Full Access</h1>" -Fragment | Out-String
$Modify = $permissions | where-object {$_.'AccessRights' -Match "Modify" -AND $_.IsInherited -eq $false -and $_.'AccessControlType' -ne "Deny"}| Select-Object FullName,Account,AccessRights,AccessControlType  | ConvertTo-Html "<h1>Modify</h1>"  -Fragment | Out-String
$ReadOnly = $permissions | where-object {$_.'AccessRights' -Match "Read" -AND $_.IsInherited -eq $false -and $_.'AccessControlType' -ne "Deny"}| Select-Object FullName,Account,AccessRights,AccessControlType  | ConvertTo-Html "<h1>Read Only</h1>" -Fragment | Out-String
$Deny =   $permissions | where-object {$_.'AccessControlType' -eq "Deny" -AND $_.IsInherited -eq $false} | Select-Object FullName,Account,AccessRights,AccessControlType | ConvertTo-Html -Fragment "<h1>Deny</h1>" | Out-String
$PermCSV = $Permissions | ConvertTo-Csv -Delimiter "," | out-file "$FolderPath\ExportOfPermissions.csv" -append
$head,$FullAccess,$Modify,$ReadOnly,$Deny | Out-File "$FolderPath\$($SMBShare.name).html"
}
write-host "Done!"
write-host "Compressing reports into Zip file at "
write-host $FolderPath\ZIP_smb_share_ntfs_audit_$timestamp
Compress-Archive -Path $FolderPath -DestinationPath $FolderPath\ZIP_smb_share_ntfs_audit_$timestamp
write-host "Done compressing. Trying to navigate to the path above."
explorer.exe $FolderPath
