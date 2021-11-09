<#
#Usage
#SetPdfDefault
remove-item c:\itsupport\scripts\func_SetPdfDefault.ps1 -erroraction silentlycontinue
powershell -exec bypass -c "Invoke-WebRequest https://raw.githubusercontent.com/cgpdavid/public_files/main/func_SetPdfDefault.ps1 -OutFile c:\itsupport\scripts\func_SetPdfDefault.ps1"
powershell -c ". c:\itsupport\scripts\func_SetPdfDefault.ps1; WindowsUpdatesInstallAuto"

#>

function EmulateKeyboardpdfDefault {
$wshell = New-Object -ComObject wscript.shell;
$wshell.AppActivate("Click on 'Change' to select default PDF handler");
Sleep 1;
$wshell.SendKeys('{TAB}');
Sleep .5
$wshell.SendKeys('{TAB}');
Sleep .5
$wshell.SendKeys('{TAB}');
Sleep .5
$wshell.SendKeys('{TAB}');
Sleep .5
$wshell.SendKeys('{TAB}');
Sleep .5
$wshell.SendKeys('{TAB}');
Sleep .5
$wshell.SendKeys('{TAB}');
Sleep .5
$wshell.SendKeys('{ENTER}');
Sleep 1
$wshell.SendKeys('{TAB}');
Sleep .5
$wshell.SendKeys('{DOWN}');
Sleep 1
$wshell.SendKeys('{ENTER}');
Sleep 1
$wshell.SendKeys('{TAB}');
Sleep .5
$wshell.SendKeys('{TAB}');
Sleep .5
$wshell.SendKeys('{TAB}');
Sleep .5
$wshell.SendKeys('{TAB}');
Sleep .5
$wshell.SendKeys('{ENTER}');
}

function OpenPDFFileProperties {
$o = new-object -com Shell.Application
$folder = $o.NameSpace("C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader")
$file = $folder.ParseName("Click on 'Change' to select default PDF handler.pdf")
# File:
$file.InvokeVerb("Properties")
EmulateKeyboardpdfDefault
}
OpenPDFFileProperties
