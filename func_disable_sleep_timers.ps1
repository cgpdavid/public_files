function DisableSleepTimers {
#Disabling sleep on plugged in
try {
		write-host "Disabling sleep"
		Powercfg /x -standby-timeout-ac 0
		powercfg /x -hibernate-timeout-ac 0
}
	catch {
		write-host "ERROR!" -ForegroundColor Red
		$_.Exception.Message
}
}
