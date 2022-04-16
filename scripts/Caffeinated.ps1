<#
#USAGE
#Caffeinated
remove-item $env:TEMP\Caffeinated.ps1 -erroraction silentlycontinue
powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/scripts/Caffeinated.ps1 -OutFile $env:TEMP\Caffeinated.ps1"
powershell -exec bypass -c ". $env:TEMP\Caffeinated.ps1"
#>


function Add-ScheduledTask
{
    param(
        [string]$taskName,
        [string]$execute,
        [string]$argument
    )

    Write-host "Creating scheduled task: taskName: $taskName execute: $execute argument: $argument"
    $action = New-ScheduledTaskAction -Execute $execute -Argument $argument
    $trigger = New-ScheduledTaskTrigger -AtLogOn
    $userId = "$env:userdomain\$env:username"
    $principal = New-ScheduledTaskPrincipal -UserId $userId -RunLevel Highest -LogonType Interactive
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -Compatibility Win8
    $task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $settings
    Register-ScheduledTask -TaskName $taskName -InputObject $task -Force | Out-Null

    if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue)
    {
        Write-host "Scheduled task succesfully created: $taskName"
        Write-host "Starting scheduled task: $taskName"
        Start-ScheduledTask -TaskName $taskName
    }
}

#CheckAndCreateITSFolders
remove-item $env:TEMP\func_CheckAndCreateITSFolders.ps1 -erroraction silentlycontinue
powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/func_CheckAndCreateITSFolders.ps1 -OutFile $env:TEMP\func_CheckAndCreateITSFolders.ps1"
powershell -exec bypass -c ". $env:TEMP\func_CheckAndCreateITSFolders.ps1; CheckAndCreateITSFolders"

$caffeineUrl = 'https://www.zhornsoftware.co.uk/caffeine/caffeine.zip'
$caffeineFolderPath = "C:\itsupport\tools"
$caffeineExeFilePath = "$caffeineFolderPath\caffeine64.exe"
$caffeineZipFilePath = "C:\itsupport\temp\caffeine.zip"

Write-host "Checking for $caffeineExeFilePath"
if (Test-Path -Path $caffeineExeFilePath -PathType Leaf)
{
    Write-host "$caffeineExeFilePath already present, skipping download."
} else{
    Write-host "$caffeineExeFilePath not present, downloading package to $caffeineZipFilePath"
    (New-Object Net.Webclient).DownloadFile($caffeineUrl, $caffeineZipFilePath)
	Write-host "Extracting $caffeineZipFilePath to $caffeineFolderPath"
    Expand-Archive -Path $caffeineZipFilePath -DestinationPath $caffeineFolderPath
}


function RegisterCaffeinatedSchedTask {
	$taskName = 'Caffeinated'
	$arguments = "/c Start $caffeineExeFilePath -replace -noicon -onac -activehours:........xxxxxxxxx......."
	$execute = "$env:SystemRoot\System32\cmd.exe"
	Add-ScheduledTask -taskName $taskName -execute $execute -argument $arguments
}

function CaffeinatedManualRun {
	$arguments = "/c Start $caffeineExeFilePath -replace -noicon -onac -activehours:........xxxxxxxxx......."
	Start-Process $caffeineExeFilePath -ArgumentList $arguments
}

#Uncomment ONE of the below lines depending on if you want it to run as a service (Default, common use case) or manually for testing
RegisterCaffeinatedSchedTask
#CaffeinatedManualRun
