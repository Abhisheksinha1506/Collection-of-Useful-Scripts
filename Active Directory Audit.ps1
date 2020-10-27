param(
    [string] $exportPath,
    [int] $daysInactive
)
#Requires -Modules   ActiveDirectory
Import-Module ActiveDirectory
 
#Function to check for export directory
#If directory is not present, creates directory
function folderCheck ($path)
{
    $pathTest = Test-Path -Path $path
    if ($pathTest -eq $true)
        {
            Write-Output "Verified $path exists"
        }
    else
        {
            Write-Output "$path does not exisit." 
            Write-Output "Creating $path now"
            New-Item -ItemType Directory -Path $path|Out-Null
        }
}
 
#Function for Write-Progress on overall script progression
function overallProgress ($status)
{
    #calculates percentage of steps compelte
    $progressPercent = ($status/24)*100
    #Rounds percentage
    $percentage = [math]::Round($progressPercent)
    Write-Progress -Activity "Active Directory Audit" -Status "Progress" -PercentComplete $percentage
}
 
#Overall Progress Report 1
$overallStatus = 0
overallProgress -status $overallStatus
#end overall progress
 
#set default path
$defaultPath = "$env:USERPROFILE\desktop\AD Audit" #end set default path
 
#Begin verification $exportPath is not empty
if ([string]::IsNullOrWhiteSpace($exportPath))
{
    Write-Output "No path given for exporting data."
    $exportPath = $defaultPath
    Write-Output "Data will be exported to $exportPath"
} 
else { Write-Output "Data will be exported to $exportPath"}#end $exportPath verification
 
#folder list array
$folders = @("$exportPath",
"$exportPath\AD Groups",
"$exportPath\Active AD Users",
"$exportPath\AD GPOs",
"$exportPath\GPO Reports",
"$exportPath\Inactive Items",
"$exportPath\Disabled Items",
"$exportPath\DC Information") #end folder list array
 
#Overall Progress Report 2
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report
 
#default inacticty days
$defaultInactive = 30
#Begin verification $daysInactive is not empy
if ($daysInactive -eq 0)
{
 Write-Output "No data provided for number of days inactive"
 $daysInactive = $defaultInactive
 Write-Output "Set number of days inactive to $daysInactive"   
}
else {Write-Output "Account inactivty threshold is $daysInactive"}#end $daysInactive verification
 
#Overall Progress Report 3
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report
 
#Set $time equal to $daysInactive from the date script is run
$time = (Get-Date).AddDays(-($daysInactive))#end setting $time
 
#Overall Progress Report 4
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report
 
#gather all Groups and setting group variables
$adGroupList = Get-ADGroup -Filter * #end gather all AD Groups
 
#Overall Progress Report 5
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report
 
#gather all enabled users in AD
$userList = Get-ADUser -Filter {enabled -eq $true} -Properties lastLogonTimestamp,enabled,Description,CanonicalName #end gather all enabled users in AD
 
#Overall Progress Report 6
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report
 
#gather all GPOs
$gpos = Get-GPO -All #end gather all GPOs
 
#Overall Progress Report 7
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report
 
#get inactive users
$inactiveUsers = Get-ADUser -Filter{LastLogonTimeStamp -le $time -and enabled -eq $true} -Properties lastLogonTimestamp,enabled,Description,CanonicalName #end gather inactive users
 
#Overall Progress Report 8
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report
 
#get inactive computers
$inactiveComputers = Get-ADComputer -Filter {LastLogonDate -le $time} -Properties LastLogonDate,CanonicalName #end get inactive computers
 
#Overall Progress Report 9
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report
 
#get disabled users
$disabledUsers = Get-ADUser -Filter {enabled -eq $false} -Properties lastLogonTimestamp,enabled,Description,CanonicalName #end get disabled users
 
#Overall Progress Report 10
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report
 
#get disabled computers
$disabledComputers = Get-ADComputer -Filter {enabled -eq $false} -Properties LastLogonDate,CanonicalName #end get disabled computers
 
#Overall Progress Report 11
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report
 
#check for directories
$folderCount = $folders.Count
$foldersProccessed = 0 
foreach ($folder in $folders)
{
    Write-Output "Running folderCheck on $folder"
    $folderPercantage = (($foldersProccessed/$folderCount)*100)
    $folderRound = [math]::Round($folderPercantage)
    Write-Progress -Activity "Folder Directory Verification" -Status "Progress" -PercentComplete $folderRound
    folderCheck -path $folder
    $foldersProccessed += 1
} #end check for directories
 
#Overall Progress Report 12
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report
 
#export group lists
$adGroupList|Select-Object name,groupcategory,groupscope,samaccountname| Export-Csv -path "$exportPath\AD Groups\All Groups.csv" -NoTypeInformation #end export group lists
 
#Overall Progress Report 13
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report
 
#gather all users in groups
$groupProcessed = 0
$groupCount = $adGroupList.count
 
foreach ($group in $adGroupList)
{
    $groupPercentage = ($groupProcessed/$groupCount)*100
    $groupRound = [math]::Round($groupPercentage)
    $groupName = $group.samaccountname
    $fileName = $group.name
    Write-Progress -Activity "Export members of AD Groups" -Status "Progress" -PercentComplete $groupRound
    $groupProcessed += 1
    Get-ADGroupMember -Identity $groupName| Select-Object name,samaccountname,objectclass|Export-Csv -Path "$exportPath\AD Groups\$fileName.csv" -NoTypeInformation
}
 
#Overall Progress Report 14
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report
 
#export enabled users
$userList|Select-Object Name,SamAccountName,Description,CanonicalName,lastLogonTimestamp|Export-Csv -Path "$exportPath\Active AD Users\All Active Users.csv" -NoTypeInformation #end export enabled users
 
#Overall Progress Report 15
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report
 
#export GPOs
$gpos|Select-Object DisplayName,Owner,GpoStatus|Export-Csv -Path "$exportPath\AD GPOs\AllGPOs.csv" -NoTypeInformation #end export GPOs
 
#export gpo reports
$gpoCount = $gpos.count
$gpoProcessed = 0
foreach($gpo in $gpos)
{
    $gpoPercentage = ($gpoProcessed/$gpoCount)*100
    $gpoRound = [math]::Round($gpoPercentage)
    $gpoName = $gpo.DisplayName
    $gpoNameTrim = $gpoName -replace ' ','' -replace ':','' -replace [regex]::Escape('\'),''
    Write-Progress -Activity "GPO Report Generation" -Status "Progress" -PercentComplete $gpoRound
    Get-GPOReport -Name $gpoName -ReportType HTML -Path "$exportPath\GPO Reports\$gpoNameTrim.html"
    $gpoProcessed += 1
}
 
#Overall Progress Report 16
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report
 
#export inactive users
$inactiveUsers|Select-Object Name,SamAccountName,Description,CanonicalName,@{Name="Stamp"; expression={[DateTime]::FromFileTime($_.lastLogonTimestamp).ToString('yyyy-MM-dd_hh:mm:ss')}}|Export-Csv -Path "$exportPath\Inactive Items\Inactive Users.csv" -NoTypeInformation #end export inactive users
 
#Overall Progress Report 17
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report
 
#export inactive computers
$inactiveComputers|Select-Object name,CanonicalName,LastLogonDate| export-csv -path "$exportPath\Inactive Items\Inactive Computers.csv" -NoTypeInformation #end export inactive computers
 
#Overall Progress Report 18
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report
 
#export disabled users
$disabledUsers|Select-Object givenname,surname,name,samaccountname,enabled|Export-Csv -Path "$exportPath\Disabled Items\Disabled Users.csv" -NoTypeInformation #end export disabled users
 
#Overall Progress Report 19
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report
 
#export disbaled computers
$disabledComputers|Select-Object name,DistinguishedName,LastLogonDate,Enabled|Export-Csv -Path "$exportPath\Disabled Items\Disabled Computers.csv" -NoTypeInformation #end export disabled users
 
#Overall Progress Report 20
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report
 
#gather domain controller list
$dcs = (Get-ADDomain).ReplicaDirectoryServers
$dcs += (Get-ADDomain).ReadOnlyReplicaDirectoryServers #end gather domain controller list
$dcCount = $dcs.count
$dcProcess = 0
 
#Overall Progress Report 21
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report
 
#gather information about Domain Controller
Foreach ($dc in $dcs)
{
    $dcPercentage = ($dcProcess/$dcCount)*100
    $dcRound = [math]::Round($dcPercentage)
    Write-Progress -Activity "Gathering information on Domain Controllers" -Status "Progress" -PercentComplete $dcRound
    Write-Output "Gathering information for $dc"
    Get-ADDomainController -Identity $dc|Export-Csv "$exportPath\DC Information\DC Information.csv" -Append -NoTypeInformation
    Write-Output "Running dcdiag on $dc"
    dcdiag /s:$dc > "$exportPath\DC Information\$dc.txt"
    $dcProcess += 1
} #end gather information about domain controller
 
#Overall Progress Report 22
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report
 
#gather FSMO information
NetDOM /query FSMO > "$exportPath\DC Information\FSMO.txt" #end gather FSMO information
 
#Overall Progress Report 23
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report
 
#gather replication stauts
Get-ADReplicationFailure -Scope Domain|Export-Csv -Path "$exportPath\DC Information\Replication Status.csv" -NoTypeInformation #end gather replication status
 
#Overall Progress Report 24
$overallStatus += 1
overallProgress -status $overallStatus #end Overall Progress Report