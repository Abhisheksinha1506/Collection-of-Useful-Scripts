# Command to Execute
$Location = "C:\Users\Trainer\Documents\PowerShell\Start"

$session = New-PSSession -ComputerName localhost -ConfigurationName
Invoke-Command -Session $session -ScriptBlock { "$($Location)\Remote.ps1" } 

