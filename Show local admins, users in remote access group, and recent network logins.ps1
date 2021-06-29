write-output "`r`nLocal admin user group members`r`n----------`r`n"

#Get local admins group
Invoke-Command {
    net localgroup administrators | 
    where { $_ -AND $_ -notmatch "command completed successfully" } | 
    select -skip 4

}
write-output "`r`n"
write-output "`r`nRemote desktop users group members`r`n----------`r`n"

#show users in local remote desktop users group
Invoke-Command {
    net localgroup "remote desktop users" | 
    where { $_ -AND $_ -notmatch "command completed successfully" } | 
    select -skip 4
}

write-output "`r`n"

# Extract info from logs            
$allRDPevents = Get-WinEvent -FilterHashtable @{Logname = "Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational" ; ID = 1149, 1150, 1148 } -ErrorAction SilentlyContinue            
            
$RDPevents = @()              
foreach ($event in $allRDPevents) {            
    $result = $type = $null             
    switch ($event.ID) {            
        1148 { $result = "failed" }            
        1149 { $result = "succeeded" }            
        1150 { $result = "merged" }            
    }        
    if ($event.Properties[1].Value -ne $null -and $event.Properties[1].Value.length -gt 0 ) {      
        $RDPevents += New-Object -TypeName PSObject -Property @{         
            ComputerName         = $env:computername            
            User                 = $event.Properties[0].Value            
            Domain               = $event.Properties[1].Value            
            SourceNetworkAddress = [net.ipaddress]$Event.Properties[2].Value            
            TimeCreated          = $event.TimeCreated            
            Result               = $result            
        }
    }            
}            
            
# Display results  

write-output "`r`nNetwork logons in the past 7 days`r`n----------`r`n " 
$RDPevents | Sort-Object -Descending:$true -Property TimeCreated | Format-Table -AutoSize -Wrap    