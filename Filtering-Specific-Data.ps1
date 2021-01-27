# Basic Filtering (-eq, -ne and like)
Get-Command | Where-Object {$_.CommandType -eq 'cmdlet'}
Get-Command | Where-Object {$_.CommandType -ne 'cmdlet'}
Get-Command | Where-Object {$_.Name -like '*invoke*'}
Get-Command | Where-Object {$_.Name -like '*workflow*'}

# Joining Filtering
Get-Command | Where-Object {($_.Name -like '*invoke*') `
  -and ($_.CommandType -eq 'cmdlet')}
Get-Command | Where-Object {($_.Name -like '*invoke*') `
  -and !($_.CommandType -eq 'cmdlet')}

# Use a parameter and filter
Get-Command -CommandType cmdlet | `
    Where-Object {$_.Name -like '*invoke*'}

Get-Service
Get-Service | `
    Where-Object -Property Status -eq -Value 'running'

Get-ChildItem -Path "C:\Users\Trainer" -Filter *ps1

Get-Command -ParameterName Filter