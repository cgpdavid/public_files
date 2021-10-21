function OfficeIconsDesktops {

write-host "creating Outlook, Word, and Excel icons on all Desktops in c:\users\"
write-host "Any users that have not signed in yet, will not recieve an icon, even after they signin - Unless this function is run again"

	$Destination = 'C:\users\*\Desktop\'
			$Source = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Outlook.lnk'
			Get-ChildItem $Destination | ForEach-Object {Copy-Item -Path $Source -Destination $_ -Force}
			
			$Source = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Word.lnk'
			Get-ChildItem $Destination | ForEach-Object {Copy-Item -Path $Source -Destination $_ -Force}
			
			$Source = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Excel.lnk'
			Get-ChildItem $Destination | ForEach-Object {Copy-Item -Path $Source -Destination $_ -Force}
			Remove-Item "C:\users\*\Desktop\Windows 10 Update Assistant.lnk" –Force
}
