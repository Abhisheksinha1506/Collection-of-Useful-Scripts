param($IPaddress = "")
if ($IPaddress -eq "" ) { $IPaddress = read-host "Enter IP address to locate" }

try {
	$result = Invoke-RestMethod -Method Get -Uri "http://ip-api.com/json/$IPaddr"
	write-output $result
	exit 0
} catch {
	write-error "⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}