# Select objects by property
Get-Process | Select-Object -Property ProcessName, Id, WS
Get-Process | Select-Object -Property ProcessName

# Select objects by property and format the results$variable
Get-Process Explorer | Select-Object -Property ProcessName -ExpandProperty Modules | Format-List

# Select processes using the most memory
Get-Process | Sort-Object -Property WS | Select-Object -Last 5

# Select unique characters from an array
"One","Two","Three","One","One","Two" | Select-Object -Unique

# Select all but the first object
"One","Two","Three","One","One","Two" | Select-Object -Skip 1

# Demonstrate the intricacies of the -ExpandProperty parameter
$object = [pscustomobject]@{Name="MyObject";Expand=@("One","Two","Three","Four","Five")}
$object | Select-Object -ExpandProperty Expand -Property Name
$object | Select-Object -ExpandProperty Expand -Property Name | Get-Member

