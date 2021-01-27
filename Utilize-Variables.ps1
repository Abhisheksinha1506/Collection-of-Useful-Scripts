# View Members for an object
Get-Service -ServiceName 'Dnscache' | Get-Member

# Get the type of object
Get-Service | Get-Member -MemberType Property

# Get the properties of the object
Get-Service -ServiceName 'Dnscache' | Select-Object -Property 'StartType'

# Retrieve alias value
Get-Service | Get-Member -MemberType 'AliasProperty'

# Populate variable with object
$svc = Get-Service -ServiceName 'Dnscache'
$svc.Name
$svc.RequiredServices

# View the methods for an object
Get-Service | Get-Member -MemberType 'Method'

# Selecting values from a PowerShell Object
Get-Service -ServiceName * | Select-Object -Property 'Status','DisplayName'

# Sorting values from Object
Get-Service -ServiceName * | Select-Object -Property 'Status','DisplayName' |
    Sort-Object -Property 'Status' -Descending
    
# Filtering the objects
Get-Service * | Select-Object -Property 'Status','DisplayName' |
Where-Object -FilterScript {$_.Status -eq 'Running' -and $_.DisplayName -like "Windows*" |
    Sort-Object -Property 'DisplayName' -Descending | Format-Table -AutoSize
