#usage RenamePcXXXPrefix($ClientHostnamePrefix="test")
#usage RenamePcXXXPrefix($ClientHostnamePrefix=$VarFromScript)
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
