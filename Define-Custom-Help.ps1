# Basic Function
function Add-FourNumbers()
{
    param(
        [Int32]$first,
        [Int32]$second,
        [Int32]$third,
        [Int32]$fourth
    )

    $result = $first + $second + $third + $fourth

    Write-Host "$($first) + $($second) + $($third) + $($fourth) = $($result)"
}

Add-FourNumbers -first 1 -second 1 -third 1 -fourth 1


# Basic Function with Parameter Help
function Add-FourNumbers()
{
    param(
        [Int32]
        # Specifies the first number
        $first,
        [Int32]
        # Specifies the second number
        $second,
        [Int32]
        # Specifies the third number
        $third,
        [Int32]
        # Specifies the fourth number
        $fourth
    )

    $result = $first + $second + $third + $fourth

    Write-Host "$($first) + $($second) + $($third) + $($fourth) = $($result)"
}


# Basic Function with Detailed Help
function Add-FourNumbers()
{
    param(
        [Int32]$first,
        [Int32]$second,
        [Int32]$third,
        [Int32]$fourth
    )

    $result = $first + $second + $third + $fourth

    Write-Host "Here is the full sum"
    Write-Host "$($first) + $($second) + $($third) + $($fourth) = $($result)"

    <#
        .SYNOPSIS
        Adds four numbers together and returns the result.

        .DESCRIPTION
        Adds four numbers together and returns the result.
        Takes any four numbers.

        .PARAMETER first
        Specifies the first number

        .PARAMETER second
        Specifies the second number

        .PARAMETER third
        Specifies the third number

        .PARAMETER fourth
        Specifies the fourth number

        .INPUTS
        None

        .OUTPUTS
        System.String

        .EXAMPLE
        C:\PS> Add-FourNumbers -first 1 -second 2 -third 3 -fourth 4
        Here is the full sum
        1 + 2 + 3 + 4 = 10
    #>
}

Get-Help Add-FourNumbers



# Script Level Help
<#
    .SYNOPSIS
    This is a custom script.

    .DESCRIPTION
    This script contains all the functions needed.

    .INPUTS
    None

    .OUTPUTS
    System.String
#>

Get-Help .\Help.ps1

