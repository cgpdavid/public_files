# 
# Author: CGP David
# Usage: 
# powershell -exec bypass -c "(new-object net.webclient).DownloadFile('https://raw.githubusercontent.com/cgpdavid/public_files/main/script_wipe_bloat_mcafee.ps1','script_wipe_bloat_mcafee.ps1'); ./script_wipe_bloat_mcafee.ps1"
#

# Functions

function CheckAndCreateITSFolders {
	try {
		if (!(Test-Path "C:\itsupport\installers\")){
		Write-Host "Creating Installers directory"
		New-Item -Path "C:\itsupport\" -Name "Installers" -ItemType "directory"
		}
		else {
		Write-Host "Installers path exists"
		}
		if (!(Test-Path "C:\itsupport\temp\")){
			Write-Host "Creating Temp directory"
			New-Item -Path "C:\itsupport\" -Name "temp" -ItemType "directory"
		}
		else {
			Write-Host "Temporary Path exists"
		}
		if (!(Test-Path "C:\itsupport\logs\")){
            Write-Host "Creating Logs directory"
			New-Item -Path "C:\itsupport\" -Name "logs" -ItemType "directory"
		}
		else {
			Write-Host "Logs Path exists"
		}
	}

	catch {
		write-host "ERROR!" -ForegroundColor Red
		$_.Exception.Message
	}
}

function waitForProcessToStartOrTimeout( [string]$procname, [int]$timeoutvalue ) {
    # Takes process name (without exe) and time value in seconds, waits until process starts or timesout
        [int]$waittries = 0
        Write-Host "Waiting until Process `'$procname`' is started or until $($timeoutvalue) seconds have passed..."
        while ( !(Get-Process $procname -ErrorAction SilentlyContinue) -and ($waittries -lt $timeoutvalue) )  {
            Start-Sleep -Seconds 1
            $waittries += 1
        }
        if ( $waittries -ge $timeoutvalue ) {
            Write-Host "Waiting for Process `'$procname`' to start timed out."
            return 258
        } else {
            Write-Host "Process `'$procname`' has started. Continuing..."
            return 0
        }
}

function RemoveMcAfee {
if ( Test-Path "c:\itsupport\installers\mcpr.exe" ) {
	Write-Output "Starting McAfee Removal Tool..." | Out-Default
	Start-Process "c:\itsupport\installers\mcpr.exe"
	$waittimeoutexitcode = waitForProcessToStartOrTimeout "McClnUI" 45
	Start-Process "taskkill.exe" -ArgumentList "/im `"McClnUI.exe`" /f"
    if ( Test-Path "$($env:temp)\MCPR" ) {
        Set-Location "$($env:temp)\MCPR"
        if ( Test-Path "$($env:temp)\MCPR\mccleanup.exe" ) {
            $uninstallpath = "$($env:temp)\MCPR\mccleanup.exe"
            $uninstallarguments = "-p StopServices,MFSY,PEF,MXD,CSP,Sustainability,MOCP,MFP,APPSTATS,Auth,EMproxy,FWdiver,HW,MAS,MAT,MBK,MCPR,McProxy,McSvcHost,VUL,MHN,MNA,MOBK,MPFP,MPFPCU,MPS,SHRED,MPSCU,MQC,MQCCU,MSAD,MSHR,MSK,MSKCU,MWL,NMC,RedirSvc,VS,REMEDIATION,MSC,YAP,TRUEKEY,LAM,PCB,Symlink,SafeConnect,MGS,WMIRemover,RESIDUE -v -s"
            Write-Output "MCPR may take quite a while to run. Please wait..." | Out-Default
			Start-Process $uninstallpath -ArgumentList $uninstallarguments -passthru -Wait -NoNewWindow 
        }
    } else {
        Write-Warning "Directory $($env:temp)\MCPR does not exist." | Out-Default
        Write-Warning "Probably low disk space, or the removal tool has changed. Ask David to debug." | Out-Default
        Write-Warning "Check Disk Space, check write permissions to c:\itsupport\ and try again, or manually uninstall McAfee or run MCPR.exe manually and reboot." | Out-Default
        Continue
    }
} else {
	if ($mcprdownloaded -ne "True") {
	Write-Output "Downloading McAfee Removal Tool..." | Out-Default
	$url = "http://us.mcafee.com/apps/supporttools/mcpr/mcpr.asp"
	$output = "c:\itsupport\installers\mcpr.exe"
	CheckAndCreateITSFolders
	$ProgressPreference = "silentlyContinue"
	Invoke-WebRequest -Uri $url -OutFile $output
	$mcprdownloaded = $True
	RemoveMcAfee
	} else {
		Write-Error "Error! Dowloading of McAfee MCPR Tool failed. We tried once, and c:\itsupport\installers\mcpr.exe was not detected." | Out-Default
	}
}
}
RemoveMcAfee


function RemoveMcAfeeAppPackages {
	Write-Output "Removing McAfee Windows Tiles and Apps" | Out-Default
	$RemoveApp = 'Mcafee'
	Get-AppxPackage -AllUsers | Where-Object {$_.Name -Match $RemoveApp} | Remove-AppxPackage
	Get-AppxPackage | Where-Object {$_.Name -Match $RemoveApp} | Remove-AppxPackage
	Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Match $RemoveApp} | Remove-AppxProvisionedPackage -Online
	
	
}
RemoveMcAfeeAppPackages
