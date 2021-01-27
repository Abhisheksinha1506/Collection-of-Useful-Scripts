# Pipe
Get-Commend | Where-Object {} | Sort-Object {} | Select-Object

# The && and || Operators
# The && operator executes the command to the right side of the pipe only if the first command was successful.

#  first command succeeds and the second command is executed
Write-Host "Primary Message" && Write-Host "Secondary Message"

# first command fails, the second is not executed
Write-Error "Primary Error" && Write-Host "Secondary Message"

# The || operator executes the command to the right side of the pipe only if the first command was unsuccessful. So it’s the opposite of the previous one.

# first command succeeds, the second command is not executed
Write-Host "Primary Message" || Write-Host "Secondary Message"

# first command fails, so the second command is executed
Write-Error "Primary Error" || Write-Host "Secondary Message"


# Null-coalescing, assignment, and conditional operators
#PowerShell 7 includes Null coalescing operator ??, Null conditional assignment ??=, and Null conditional member access operators ?. and ?[]

$variable = $null

if ($null -eq $variable) {
	"No Value is Found"
} 

$variable = "test"
if($null -eq $variable)
{
	"No Value is Found"
}

if($null -eq $variable) { "Np Value is Found" } else { $variable }


$variable = $null
$variable ?? "No Value is Found"

$variable = "test"
$variable ?? "No Value is Found"

