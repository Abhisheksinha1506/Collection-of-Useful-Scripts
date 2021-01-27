# View details of the Command
Get-Command Format-Table
Get-Command ft

Get-Command 
gcm

# View list of Aliases
Get-Alias

# Define custom Aliases
Set-Alias -Name "" -Value "" -Description ""

# Compare
Get-Command | Where-Object {$_.parametersets.count -gt 3} |  Format-List Name
gcm | ? {$_.parametersets.Count -gt 3}| fl Name

Write-Output "Test Message"
echo "Test Message"

Get-Process
gps 


