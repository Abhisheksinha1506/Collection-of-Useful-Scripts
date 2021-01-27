# Set Variable
$Location = "C:\Users\Trainer\PSFolder\Data"

# Get-Content Command
1..100 | ForEach-Object { Add-Content -Path "$($Location)\PSNumbers.txt" -Value "Line $_." }
Get-Content -Path "$($Location)\PSNumbers.txt"

# Parse XML Data
$Path = "$($Location)\MenuData.xml"
$XPath = "/breakfast_menu/food/name"
Select-Xml -Path $Path -XPath $Xpath | Select-Object -ExpandProperty Node

# CSV Data
Get-Process | Export-Csv -Path "$($Location)\Processes.csv"
$processes = Import-Csv -Path "$($Location)\Processes.csv"
$processes | ft

# CSV Data with Delimiter
Get-Process | Export-Csv -Path "$($Location)\Processes.csv" -Delimiter :
$processes = Import-Csv -Path "$($Location)\Processes.csv" -Delimiter :
$processes | ft

# Import CSV and Loop Each Line
Import-Csv "$($Location)\Employees.csv" | ForEach-Object {
    Write-Host "$($_.FirstName), $($_.LastName) born $($_.DateOfBirth)"
}



