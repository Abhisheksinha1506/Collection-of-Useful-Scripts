#A minor script to gather OS information from servers on your domain the output will return;

Servername, OS, RAM, Free space on C, and used space on C, can easily add more drives to monitor / gather information from.
$Serverlist = Get-ADComputer -Filter * -Properties OperatingSystem, DnsHostname | Where OperatingSystem -Like "*Server*" |  Select DnsHostname
$MasterList = @()

foreach ($Server in $Serverlist) {

    $MyObject = New-Object PSObject -Property @{
        Servername = $Server.DnsHostname
        OS         = (Get-CimInstance -ComputerName $Server.DnsHostname -ClassName Win32_OperatingSystem).Caption
        RAM        = (Invoke-command $Server.DnsHostname { (systeminfo | Select-String 'Total Physical Memory:').ToString().Split(':')[1].Trim() })
        CFreeGB    = (Invoke-Command $Server.DnsHostname { (Get-WmiObject win32_logicaldisk -Filter "DeviceID='C:'").FreeSpace / 1gb -as [int] })
        CTotalGB   = (Invoke-Command $Server.DnsHostname { (Get-WmiObject win32_logicaldisk -Filter "DeviceID='C:'").Size / 1gb -as [int] })

    }
    $MasterList += $MyObject
}
# Select fields in a specific order rather than random.
$MasterList | Select Servername, OS, RAM, CTotalGB, CFreeGB  |
Export-csv C:\Users\$env:username\Desktop\ServerOverview.csv -NoTypeInformation -Encoding Unicode