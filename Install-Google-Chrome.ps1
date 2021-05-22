try {
	$TempPath = $env:TEMP;
	$SetupFile = "chrome_installer.exe"
	Invoke-WebRequest "http://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile $TempPath\$SetupFile
	Start-Process -FilePath $TempPath\$SetupFile -Args "/silent /install" -Verb RunAs -Wait
	Remove-Item $TempPath\$SetupFile
	write-host -foregroundColor green "✔️  Google Chrome installed"
	exit 0
} catch {
	write-error "⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
