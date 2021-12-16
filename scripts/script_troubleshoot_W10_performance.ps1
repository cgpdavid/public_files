<#
System Performance Troubleshooting Script
Maintained by David


#>
# elevated script execution with admin privileges
$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
$testadmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
if ($testadmin -eq $false) {
    Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
	pause
    exit $LASTEXITCODE
}

# header 
$ErrorActionPreference= 'SilentlyContinue'
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Bypass -Force
Write-Host "ExecutionPolicy Bypass" -fore Green
$ErrorActionPreference= 'Inquire'
$WarningPreference = 'SilentlyContinue'


# Cleanup
write-host "Launching CleanMGR so that you can set what to cleanup - Then cleaning up after you close it"
Start-Process -FilePath CleanMgr.exe -ArgumentList '/d c: sageset:1' -Wait
Start-Process -FilePath CleanMgr.exe -ArgumentList '/sagerun:1' -Wait


#DISM Space
write-host "RUnning DISM Component store Check - This may take a while"
$dismspacecheck = DISM /online /Cleanup-Image /AnalyzeComponentStore
write-host $dismspacecheck
if($dismspacecheck -like "*Component Store Cleanup Recommended : Yes*")
{
    $dismmatch = [string]$dismspacecheck -match "Reclaimable Packages : (\d*)"
    if($dismmatch){
        if($Matches.2 -gt 4){
            Write-Output("DISM Reports that Cleanup is needed, Doing that now. ")
            $dismspacecleanup = DISM /online /Cleanup-Image /StartComponentCleanup
			write-host $dismspacecleanup
        } else {
            Write-Output("Dism reports that DISM Cleanup is recommended but not needed as there are not excessive reclaimable packages.")
        }
    }
} else {
    Write-Output("Cleanup not needed.")
}

#DISM Health
write-host "Running DISM Health Check - This may take a while"
$dismhealth = DISM /Online /Cleanup-Image /ScanHealth
write-host $dismhealth
if($dismhealth -like "*The component store is repairable.*"){
	Write-Output("DISM reports that the component store is in need of repair, Trying it now.")
	$dismhealthfix = DISM /Online /Cleanup-Image /RestoreHealth
	write-host $dismhealthfix
if($dismhealthfix -like "*The restore operation completed successfully.*"){
    Write-Output("DISM image restore-health Fixes Performed.")
}

} elseif ($dismhealth -like "*No component store corruption detected.*") {
    Write-Output("DISM reports image Health is good.")
}



# SFC
write-host "Running DISM Component store Check - This may take a while"
$sfcverify = ($(sfc /verifyonly) -split '' | ? {$_ -and [byte][char]$_ -ne 0}) -join ''
write-host $sfcverify
if($sfcverify -like "*found integrity violations*"){
    Write-Output("SFC found corrupt files, Fixing now.")
	Write-Output("This might require that you reboot your computer in order to process the fixes.")
	Write-Output("You can check the Eventlog after to see resuts.")
    $sfcfix = ($(sfc /scannow) -split '' | ? {$_ -and [byte][char]$_ -ne 0}) -join ''
	write-host $sfcfix
    if($sfcfix -like "*unable to fix*"){
        Rmm-Alert -Category 'SFC' -Body 'SFC fixes failed!'
        Write-Output("SFC was unable to fix the issues.")
    } else {
        Write-Output("SFC repair successful.")
    }
} else {
    Write-Output("SFC reports no issues, so no fixes are needed.")
}


# Defrag Drives
write-host ""
$issd = Get-PhysicalDisk
if ($issd.MediaType -eq 'SSD') {
    Write-Host "Found SSD drive - Trimming drive now"
    $DefragSSD = Optimize-Volume -DriveLetter C -ReTrim -Verbose
	Write-Host $DefragSSD
} else {
	Write-Host "Found HDD drive - Defraging now"
    $DefragHDD = Optimize-Volume -DriveLetter C -Defrag -Verbose
	Write-Host $DefragHDD
}  



<#
# IN PROGRESS 
# WARRANTY LOOKUP
write-host "Looking up warranty information on this machine"
if (Get-WmiObject win32_SystemEnclosure -Filter: "Manufacturer LIKE 'Dell Inc.'") { 
    $isDellSystem = $true
    Write-Host "This computer is a Dell"
	
    } elseif (Get-WmiObject win32_SystemEnclosure -Filter: "Manufacturer LIKE 'LENOVO'") { 
	$isLenovoSystem = $true
	Write-Host "This computer is a Lenovo"
	$SerialNumber = ((Get-WmiObject -Class "Win32_Bios").SerialNumber)
	$Model = ((Get-WmiObject -Class "Win32_ComputerSystem").model)
	$ProductId =
	$WarrantyStatus =
	$WarrantyExpireDate =
	$WarrantyStartDate =
	$warrantyURL = "http://csp.lenovo.com/ibapp/il/WarrantyStatus.jsp?&serial="
	write-host "Launching machine warranty information in browser" 
	write-host $warrantyURL$SerialNumber
	Start-Process $warrantyURL$SerialNumber
	Start 
	
	
	} else { 
	$manufacturer = $(Get-WmiObject win32_SystemEnclosure | Select-Object Manufacturer)
	$isOtherSystem = $true
    Write-Host "This system could not be identified as Dell nor a Lenovo system - Found manufacturer: $manufacturer" 
	}

#>
