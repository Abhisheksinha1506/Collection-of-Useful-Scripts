#Figure out what locked a user in AD by using this script, the output will return a username, endpoint device that locked the user & a timestamp.#
$DC = Get-ADComputer -Filter * -SearchBase "OU=Domain Controllers,DC=domain,DC=com" | Select DNSHostname
$properties = @(
    @{n = 'User'; e = { $_.Properties[0].Value } },
    @{n = 'Locked by'; e = { $_.Properties[1].Value } },
    @{n = 'TimeStamp'; e = { $_.TimeCreated } }
)
Foreach ($D in $DC) {
    Get-WinEvent -ComputerName $D.DNSHostname -FilterHashTable @{LogName = 'Security'; ID = 4740 } | 
    Select $properties
} | Export-csv C:\Users\$env:username\Desktop\LockedUsers.csv -NoTypeInformation -Encoding Unicode