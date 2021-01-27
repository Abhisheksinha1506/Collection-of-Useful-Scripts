# Creating PowerShell Variables
$variable = "My Text Value"
$variable = Get-ComputerInfo

# PowerShell Pipes
Get-Service | Sort-Object -property Status
"I can now use PowerShell Pipe Commands!!" | Out-File "C:\Training\file.txt"
Get-Service | WHERE {$_.status -eq "Running"} | SELECT displayname

# System Variables
Get-ChildItem Env: #Returns all environment variables
$env:SystemRoot #Returns System Path e.g. C:\Windows
$env:VARIABLE = "My Text Value" #Creates and Sets a new Environment Variable

# Ensuring the right data types for variables
[int32]$var #Displays single number e.g. 1
[float]$var #Displays number with decimal e.g. 1.2
[string]$var #Displays text value e.g. 1.2
[boolean]$var #Displays either true or false e.g. True
[datetime]$var #Displays a date e.g. "Thursday, January 2, 2020 12:00:00 AM" 

