#Pending reboot check param
$varRebootRequired = $null
$pendingRebootTests = @(
    @{
        Name = 'RebootPending'
        Test = { Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing'  Name 'RebootPending' -ErrorAction Ignore }
        TestType = 'ValueExists'
    }
    @{
        Name = 'RebootRequired'
        Test = { Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update'  Name 'RebootRequired' -ErrorAction Ignore }
        TestType = 'ValueExists'
    }
    @{
        Name = 'PendingFileRenameOperations'
        Test = { Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name 'PendingFileRenameOperations' -ErrorAction Ignore }
        TestType = 'NonNullValue'
    }
)

# Logging function. 

#Checking if computer pending reboot.
function func_check_for_reboot_required {
    foreach ($test in $pendingRebootTests) {
        $result = Invoke-Command -ScriptBlock $test.Test
        if ($test.TestType -eq 'ValueExists' -and $result) {
            write-host "WARNING! A reboot is Pending/Required, and MUST reboot to continue. WARNING!" -ForegroundColor RED
			write-host $test.Name
			sleep 10
			exit 3010	
			$varRebootRequired = $true
        } elseif ($test.TestType -eq 'NonNullValue' -and $result -and $result.($test.Name)) {
            write-host "WARNING! The computer has a Pending File Rename Operation, and MUST reboot to continue. WARNING!" -ForegroundColor RED
			$varRebootRequired = $true
			sleep 10
			exit 3010
        } else {
            write-host "Reboot not requred Required at this time due to " $test.Name
        }
    }
}
