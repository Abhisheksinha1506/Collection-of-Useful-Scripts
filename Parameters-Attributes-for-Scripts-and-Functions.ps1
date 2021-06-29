# Create functions
Function Display-Message() {
	Write-Host "My Message" 
}

Function Display-Message($Text) {
	Write-Host $Text
}

# Change the function to use arguments
Function Display-Message() {
	[String]$Value1 = $args[0]
	[String]$Value2 = $args[1]

	Write-Host $Value1 $Value2
}

# Change the function to use parameter
Function Display-Message() {
	Param(
		[parameter(Mandatory = $true)]
		[String]$Text
	)
	Write-Host $Text
}

Function Display-Message() {
	Param(
		[parameter(Mandatory = $true)]
		[ValidateSet("Lexus", "Porsche", "Toyota", "Mercedes-Benz", "BMW", "Honda", "Ford", "Chevrolet")]
		[String]$Text
	)
	Write-Host "I like to drive a "$Text
}


