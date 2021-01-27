# Import the members of a module into the current session
Import-Module -Name PSDiagnostics

# Import all modules specified by the module path
Get-Module -ListAvailable | Import-Module

# Import the members of several modules into the current session
$module = Get-Module -ListAvailable PSDiagnostics, Dism
Import-Module -ModuleInfo $module

# Restrict module members imported into a session
Import-Module PSDiagnostics -Function Disable-PSTrace, Enable-PSTrace
(Get-Module PSDiagnostics).ExportedCommands

# Import the members of a module and add a prefix
Import-Module PSDiagnostics -Prefix x -PassThru

# Import a module from a remote computer
$session = New-PSSession -ComputerName Server01
Get-Module -PSSession $session -ListAvailable -Name NetSecurity


# Explicit Loading
Import-Module -Name 'AzureAD' -UseWindowsPowerShell

# Implicit Loading
Import-Module -Name 'ServerManager'
Get-Module -Name 'ServerManager'



