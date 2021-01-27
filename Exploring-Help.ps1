# Display basic help information about a cmdlet
Get-Help Format-Table
Get-Help -Name Format-Table
Format-Table -?

# Display basic information one page at a time
help Format-Table
man Format-Table
Get-Help Format-Table | Out-Host -Paging

# Display more information for a cmdlet
Get-Help Format-Table -Detailed
Get-Help Format-Table -Full

# Display selected parts of a cmdlet by using parameters
Get-Help Format-Table -Examples
Get-Help Format-Table -Online
Get-Help Format-Table -Parameter *
Get-Help Get-ChildItem -Parameter *
Get-Help Format-Table -Parameter GroupBy

# Display a list of conceptual articles
Get-Help about_*

# Display a list of articles that include a word
Get-Help -Name remoting

# Save the help for specified module
$modulename = ""
$module = Invoke-Command -ComputerName RemoteServer -ScriptBlock { Get-Module -Name $modulename -ListAvailable }
Save-Help -Module $module -DestinationPath "C:\SavedHelp"


