# Generate JSON
systeminfo /fo CSV | ConvertFrom-Csv | convertto-json | Out-File  "$($Location)\ComputerInfo.json"

# Load JSON
Get-Content -Path "$($Location)\ComputerInfo.json" | ConvertFrom-JSON

# Load JSON into a Grid View
Get-Content -Path "$($Location)\ComputerInfo.json" | ConvertFrom-JSON | Out-GridView

# Populate Variable with JSON and use Values
$jsonObject = Get-Content -Path "$($Location)\ComputerInfo.json" | ConvertFrom-JSON

$jsonObject.'Host Name'
$jsonObject.'Windows Directory'

# Manually Creating JSON
$jsonObject = @{}
$arrayList = New-Object System.Collections.ArrayList

$arrayList.Add(@{"Name"="Reid";"Surname"="Randolph";"Gender"="M";})
$arrayList.Add(@{"Name"="Scott";"Surname"="Best";"Gender"="M";})
$arrayList.Add(@{"Name"="Isabel";"Surname"="Mays";"Gender"="F";})
$arrayList.Add(@{"Name"="Marcia";"Surname"="Clark";"Gender"="F";})

$employees = @{"Employees"=$arrayList;}

$jsonObject.Add("Data",$employees)
$jsonObject | ConvertTo-Json -Depth 10 


