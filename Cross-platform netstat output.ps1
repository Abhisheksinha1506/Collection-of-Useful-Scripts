#<#
# -n = Displays addresses and port numbers in numerical form.
# the 1st three lines are unneeded
$RawNetStatInfo = netstat -n |
Select-Object -Skip 3
#>

# since i can't tell if NetStat _always_ uses English column labels,
#    this replaces the header line with a custom one
$CustomHeaderLine = 'Protocol,LocalAddress,ForeignAddress,State'
$RawNetStatInfo[0] = $CustomHeaderLine

# get rid of extra spaces, add comma delimiters
$CleanedNetStatInfo = foreach ($RNSI_Item in $RawNetStatInfo) {
    $RNSI_Item.Trim() -replace '\s{2,}', ','
}

# convert from an array of CSV strings to an array of objects
$NetStatInfo = $CleanedNetStatInfo |
ConvertFrom-Csv

$NetStatInfo