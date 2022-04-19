param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('Install','Uninstall')]
    [String]$Mode,
    $localfile
)

#CheckAndCreateITSFolders
remove-item $env:TEMP\func_CheckAndCreateITSFolders.ps1 -erroraction silentlycontinue
powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/func_CheckAndCreateITSFolders.ps1 -OutFile $env:TEMP\func_CheckAndCreateITSFolders.ps1"
powershell -exec bypass -c ". $env:TEMP\func_CheckAndCreateITSFolders.ps1; CheckAndCreateITSFolders"

#Change These Variables Per App
$appname = "Mitel Connect" #needs to match Uninstall DisplayName in Registry
$appurl = "http://upgrade01.sky.shoretel.com/ClientInstall" #url to pull app from (GitHub, Azure Blob, etc.)
$addtlargs = "/S /v/qn" #any additional args needed for install command
$installertype = "exe" # 'msi' or 'exe'
$localinstaller = "" # name of installer file
$applicationexe = "" # location of installed app

$appnamel = $appname.Replace(" ","-")
$Path = "c:\itsupport\temp"
$logpath = "c:\itsupport\logs"
$applog = "$logpath\$appnamel-"+(Get-Date -Format "MMddyyyy")+".log"
if (!(Test-Path $logpath)) { New-Item -ItemType Directory -Path $logpath -Force | Out-Null }

## Install block ##
if($Mode -eq "Install") {
	write-host "This will take some time! Do Not close this window!"
    $date = Get-Date -Format "MM/dd/yyyy-HH:mm:ss"
    $(
        Write-Output "Date: $date" 
        if ($localfile -eq $true) {
            $path = "."
            Write-Output "Temp path is set: $path , Local Installer"
            $Installer = "$localinstaller"
            if (!(Test-Path "$path\$installer")) { Write-Ouput "Local Installer Not Found"}
        } else {
            Write-Output "Temp path is set: $path"
            $Installer = "$appnamel.$installertype"
            Write-Output "Downloading Installer `"$installer`" from `"$appurl`""
            Invoke-WebRequest $appurl -OutFile $Path\$Installer
            if (!(Test-Path $Path\$Installer)) {Write-Output "Download failed"}
        }
        if ($installertype -eq "exe") {
            Write-Output "Running as .exe with additional args: $addtlargs"
            if ($null -match $addtlargs) {
                $InstallCommand = Start-Process -FilePath $Path\$Installer -Verb RunAs -Wait    
            } else {
                $InstallCommand = Start-Process -FilePath $Path\$Installer -Args "$addtlargs" -Verb RunAs -Wait
            }
        } elseif ($installertype -eq "msi") {
            Write-Output "Running as .msi with additional args: $addtlargs"
            $InstallCommand = Start-Process $env:WinDir\System32\msiexec.exe -ArgumentList "/I $Path\$Installer /qn $addtlargs" -Verb RunAs -Wait
        } else {
            Write-Output "Unknown installer type: $installertype"
        }
        Write-Output "Cleaning-up Installer"
        Remove-Item $Path\$Installer

        #add any post-install tasks here

        Write-Output "Install Complete!"
        Write-Output "############################################################"
    ) *>&1 >> $applog
    Exit $InstallCommand.ExitCode
}

## Uninstall block ##
if($Mode -eq "Uninstall") {
	write-host "This will take some time! Do Not close this window!"
    $date = Get-Date -Format "MM/dd/yyyy-HH:mm:ss"
    $(
        Write-Output "Date: $date" 
        Write-Output "Pulling Uninstall Strings"
        $uninstall_strings = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -match "$appname" } | Select-Object -Property DisplayName, UninstallString, PSChildName, QuietUninstallString
        foreach ($uninstall_string in $uninstall_strings) {
            Write-Output "Running uninstall: $uninstall_string"
            if ($uninstall_string.UninstallString -match "MsiExec.exe*") { $installertype = "msi" }
            if ($installertype -eq "exe") {
                $string = $uninstall_string.UninstallString
                if ($string -match "/") {
                    $expandedstring = ($string -split "/") 
                    $uninstallfile = $expandedstring[0]
                    $uninstallargs = $expandedstring[1..($ExpandedString.Length)]
                    foreach ($arg in $uninstallargs) {
                        $fullarg = "/$arg"
                        $arglist += $fullarg
                    }
                    [string]$addtlargs = $arglist
                } elseif ($string -match "--") {
                    $expandedstring = ($string -split "--") 
                    $uninstallfile = $expandedstring[0]
                    $uninstallargs = $expandedstring[1..($ExpandedString.Length)]
                    foreach ($arg in $uninstallargs) {
                        $fullarg = "--$arg"
                        $arglist += $fullarg
                    }
                    [string]$addtlargs = $arglist
                } else {
                    $addtlargs = ""
                }
                Write-Output "Running Uninstall mode: exe"
                if ($null -match $addtlargs) {
                    $UninstallCommand = Start-Process $uninstallfile -Verb RunAs -Wait 
                } else {
                    $UninstallCommand = Start-Process $uninstallfile -ArgumentList "$addtlargs" -Verb RunAs -Wait
                }
            } elseif ($installertype -eq "msi") {
                $string = $uninstall_string.PSChildName
                $Logfile = "$logpath\uninstalllog-$appnamel-$(get-date -Format yyyyMMddTHHmmss).log"
                Write-Output "msiexec uninstall log: $logfile"
                $UninstallCommand = Start-Process "$env:Windir\System32\msiexec.exe" -ArgumentList "/x$string /qn /L*V `"$logfile`"" -Verb RunAs -Wait -PassThru
            } else {
                Write-Output "Unrecognized installer type: $installertype"
            }
        }
        
        #add any post-uninstall tasks here

        Write-Output "Uninstall Complete!"
        Write-Output "############################################################"
    ) *>&1 >> $applog
    Exit $UninstallCommand.ExitCode
}
Exit 1618


## expand logging to capture errors 
