<#
#USAGE

#RenamePcXXXPrefix
$PreFix = "XXX" #must change this to client xxx prefix (two or three letters only!)
remove-item c:\itsupport\scripts\func_RenamePcXXXPrefix.ps1 -erroraction silentlycontinue
powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/func_RenamePcXXXPrefix.ps1 -OutFile c:\itsupport\scripts\func_RenamePcXXXPrefix.ps1"
powershell -exec bypass -c ". c:\itsupport\scripts\func_RenamePcXXXPrefix.ps1; RenamePcXXXPrefix('$PreFix')"

#>


function RenamePcXXXPrefix {
param (
    [CmdletBinding()]
    [Parameter(Position=0,mandatory=$true)]
    [string]$ClientHostnamePrefix
)
if(-not($ClientHostnamePrefix)) { Throw “ClientHostnamePrefix has not been defined! for -ClientHostnamePrefix” }

write-host "Prefix detected was: " $ClientHostnamePrefix
#must set  to "xxx"
$ServiceTAG = (Get-WmiObject Win32_BIOS).serialnumber
$OLDNAME    = (Get-WmiObject win32_COMPUTERSYSTEM).Name
Write-Host "Old name is" $OLDNAME
$NewName= $ClientHostnamePrefix + "-" + $ServiceTAG
Rename-Computer -ComputerName $OLDNAME -NewName $NewName -force
Write-Host "New name is "  $NewName

}
