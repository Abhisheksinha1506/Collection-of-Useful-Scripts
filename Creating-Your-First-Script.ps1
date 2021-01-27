# Part 1
$variable = Get-Service -Name 'Dnscache'
Write-Host $variable

# Part 2
$variable = Get-Service -Name 'Dnscache'
Write-Host $variable.DisplayName

# Part 3
$variable = Get-Service -Name 'Dnscache'
Write-Host $variable.Name
Write-Host $variable.DisplayName
Write-Host $variable.Description

# Part 4
$variable = Get-Service -Name $service
Write-Host $variable.Name -ForegroundColor Yellow
Write-Host $variable.DisplayName -ForegroundColor Green
Write-Host $variable.Description -ForegroundColor Blue

# Part 5
pushd "C:\Users\Trainer\Documents\PowerShell\Start"
Set-Location "C:\Users\Trainer\Documents\PowerShell\Start"
ls

# Part 6
$service = Read-Host "Please type the service to view"
$variable = Get-Service -Name $service

Write-Host $variable.Name -ForegroundColor Yellow
Write-Host $variable.DisplayName -ForegroundColor Green
Write-Host $variable.Description -ForegroundColor Blue
