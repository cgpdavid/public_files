function RemoveStock365 {
	
	#Remove factory bloat office365
	write-host "Attempting to remove Factory Bloat office365 Apps"
	write-host "This sometimes takes a long time. Upwards of 5 to 10 minutes sometimes."
	
	#Stop processes potentiall 365 related
	Write-Host "Stopping 365 related processes"
	write-host "It will likely say some dont exist - this is fine. continue"
	Get-Process -Name 'setup.exe','firstrun.exe','appvshnotify.exe','Officeclicktorun.exe','iexplore.exe','communicator.exe','ucmapi.exe','excel.exe','groove.exe','microsoftedge.exe','onenote.exe','infopath.exe','onenote.exe','outlook.exe','mspub.exe','powerpnt.exe','winword.exe','winproj.exe','visio.exe' | Stop-Process -Force -ErrorAction SilentlyContinue
	
	# Uninstall Office 20xx
	If (Test-Path "$envProgramFilesX86\Microsoft Office\Office12")
	{ 
	    Show-InstallationProgress "Uninstalling Microsoft Office 2007"
	    Write-Log "Microsoft Office 2007 was detected. Uninstalling..."
		powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/OfficeDev/Office-IT-Pro-Deployment-Scripts/master/Office-ProPlus-Deployment/Remove-PreviousOfficeInstalls/OffScrub07.vbs -OutFile c:\itsupport\scripts\OffScrub07.vbs"
	    Execute-Process -FilePath "CScript.Exe" -Arguments "`"$dirsupportFiles\OffScrub07.vbs`" CLIENTALL /S /Q /NoCancel" -WindowStyle Hidden -IgnoreExitCodes "1,2,3"
	}

	If (Test-Path "$envProgramFiles\Microsoft Office\Office12")
	{ 
	    Show-InstallationProgress "Uninstalling Microsoft Office 2007"
	    Write-Log "Microsoft Office 2007 was detected. Uninstalling..."
		powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/OfficeDev/Office-IT-Pro-Deployment-Scripts/master/Office-ProPlus-Deployment/Remove-PreviousOfficeInstalls/OffScrub07.vbs -OutFile c:\itsupport\scripts\OffScrub07.vbs"
	    Execute-Process -FilePath "CScript.Exe" -Arguments "`"$dirsupportFiles\OffScrub07.vbs`" CLIENTALL /S /Q /NoCancel" -WindowStyle Hidden -IgnoreExitCodes "1,2,3"
	}

	If (Test-Path "$envProgramFilesX86\Microsoft Office\Office14")
	{ 
	    Show-InstallationProgress "Uninstalling Microsoft Office 2010"
	    Write-Log "Microsoft Office 2010 was detected. Uninstalling..."
		powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/OfficeDev/Office-IT-Pro-Deployment-Scripts/master/Office-ProPlus-Deployment/Remove-PreviousOfficeInstalls/OffScrub10.vbs -OutFile c:\itsupport\scripts\OffScrub10.vbs"
	    Execute-Process -FilePath "CScript.Exe" -Arguments "`"$dirsupportFiles\OffScrub10.vbs`" CLIENTALL /S /Q /NoCancel" -WindowStyle Hidden -IgnoreExitCodes "1,2,3"
	}

	If (Test-Path "$envProgramFiles\Microsoft Office\Office14")
	{ 
	    Show-InstallationProgress "Uninstalling Microsoft Office 2010"
	    Write-Log "Microsoft Office 2010 was detected. Uninstalling..."
		powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/OfficeDev/Office-IT-Pro-Deployment-Scripts/master/Office-ProPlus-Deployment/Remove-PreviousOfficeInstalls/OffScrub10.vbs -OutFile c:\itsupport\scripts\OffScrub10.vbs"
	    Execute-Process -FilePath "CScript.Exe" -Arguments "`"$dirsupportFiles\OffScrub10.vbs`" CLIENTALL /S /Q /NoCancel" -WindowStyle Hidden -IgnoreExitCodes "1,2,3"
	}

	If (Test-Path "$envProgramFilesX86\Microsoft Office\Office15")
	{ 
	    Show-InstallationProgress "Uninstalling Microsoft Office 2013"
	    Write-Log "Microsoft Office 2013 was detected. Uninstalling..."
		powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/OfficeDev/Office-IT-Pro-Deployment-Scripts/master/Office-ProPlus-Deployment/Remove-PreviousOfficeInstalls/OffScrub13.vbs -OutFile c:\itsupport\scripts\OffScrub13.vbs"
	    Execute-Process -FilePath "CScript.Exe" -Arguments "`"$dirsupportFiles\OffScrub13.vbs`" CLIENTALL /S /Q /NoCancel" -WindowStyle Hidden -IgnoreExitCodes "1,2,3"
	}

	If (Test-Path "$envProgramFiles\Microsoft Office\Office15")
	{ 
	    Show-InstallationProgress "Uninstalling Microsoft Office 2013"
	    Write-Log "Microsoft Office 2013 was detected. Uninstalling..."
		powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/OfficeDev/Office-IT-Pro-Deployment-Scripts/master/Office-ProPlus-Deployment/Remove-PreviousOfficeInstalls/OffScrub13.vbs -OutFile c:\itsupport\scripts\OffScrub13.vbs"
	    Execute-Process -FilePath "CScript.Exe" -Arguments "`"$dirsupportFiles\OffScrub13.vbs`" CLIENTALL /S /Q /NoCancel" -WindowStyle Hidden -IgnoreExitCodes "1,2,3"
	}

	If (Test-Path "$envProgramFilesX86\Microsoft Office\Office16")
	{ 
	    Show-InstallationProgress "Uninstalling Microsoft Office 2016"
	    Write-Log "Microsoft Office 2016 was detected. Uninstalling..."
		powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/OfficeDev/Office-IT-Pro-Deployment-Scripts/master/Office-ProPlus-Deployment/Remove-PreviousOfficeInstalls/OffScrub16.vbs -OutFile c:\itsupport\scripts\OffScrub16.vbs"
	    Execute-Process -FilePath "CScript.Exe" -Arguments "`"$dirsupportFiles\OffScrub16.vbs`" CLIENTALL /S /Q /NoCancel" -WindowStyle Hidden -IgnoreExitCodes "1,2,3"
	}
		
	If (Test-Path "$envProgramFiles\Microsoft Office\Office16")
	{ 
	    Show-InstallationProgress "Uninstalling Microsoft Office 2016"
	    Write-Log "Microsoft Office 2016 was detected. Uninstalling..."
		powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/OfficeDev/Office-IT-Pro-Deployment-Scripts/master/Office-ProPlus-Deployment/Remove-PreviousOfficeInstalls/OffScrub16.vbs -OutFile c:\itsupport\scripts\OffScrub16.vbs"
	    Execute-Process -FilePath "CScript.Exe" -Arguments "`"$dirsupportFiles\OffScrub16.vbs`" CLIENTALL /S /Q /NoCancel" -WindowStyle Hidden -IgnoreExitCodes "1,2,3"
	}
		
	$MSOFFICE = Get-InstalledApplication -Name "Microsoft Office"
	[string] $DSIPLAYNAME = $MSOFFICE.DisplayName
	IF ($DSIPLAYNAME -match 'Microsoft Office 365 ProPlus')
	{
	    Show-InstallationProgress -StatusMessage "Performing Pre-Install cleanup. $DSIPLAYNAME Was detected and should be removed before proceeding... This may take some time. Please wait...";
	    Write-Log -Message "$DSIPLAYNAME Will be uninstalled" -Source "$DSIPLAYNAME uninstall";
			powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/OfficeDev/Office-IT-Pro-Deployment-Scripts/master/Office-ProPlus-Deployment/Remove-PreviousOfficeInstalls/OffScrubc2r.vbs -OutFile c:\itsupport\scripts\OffScrubc2r.vbs"
	    Execute-Process -FilePath "CScript.Exe" -Arguments "`"$dirsupportFiles\OffScrubc2r.vbs`" CLIENTALL /S /Q /NoCancel" -WindowStyle Hidden -IgnoreExitCodes "1,2,3,16,42"
	}
	
	#Delete office tiles in start menu
	Get-appxpackage -allusers *Microsoft.MicrosoftOfficeHub* -allusers | Remove-AppxPackage -allusers
	Get-appxprovisionedpackage -online | where-object {$_.packagename -like '*Microsoft.MicrosoftOfficeHub*'} | remove-appxprovisionedpackage -online -allusers
	Get-appxpackage -allusers *onenote* | Remove-AppxPackage -allusers
	Get-appxprovisionedpackage -online | where-object {$_.packagename -like '*onenote*'} | remove-appxprovisionedpackage -online -allusers
	
	write-host "Done attempting to remove office!"
	

}
