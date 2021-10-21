function DisableSleepTimers {
#Disabling sleep on plugged in
try {
		write-host "Disabling Sleep Timer While AC is Plugged in"
		Powercfg /x -standby-timeout-ac 0
		write-host "Disabling Hibernation Timer While AC is Plugged in"
		powercfg /x -hibernate-timeout-ac 0
}
	catch {
		write-host "ERROR!" -ForegroundColor Red
		$_.Exception.Message
}
}
