# Enable Remoting
Enable-PSRemoting
Enable-PSRemoting -Force

# Connect to a session
Get-PSSessionConfiguration
$session = New-PSSession -ComputerName localhost -ConfigurationName PowerShell.6
$session = New-PSSession -ComputerName localhost -ConfigurationName
Invoke-Command -Session $session -ScriptBlock { $PSVersionTable }

# Start an Interactive Session
Enter-PSSession localhost
Hostname
Get-UICulture
Exit-PSSession
Get-PSSession

# End an Interactive Session
Exit-PSSession

# Run a Remote Command
Invoke-Command -ComputerName localhost -ScriptBlock { Get-ComputerInfo }

# Remove Sessions
$session
Remove-PSSession -Session 5
Remove-PSSession -Session $session
$session


