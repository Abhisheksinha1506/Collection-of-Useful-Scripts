#Backup script using robocopy to get multiple drives backed up, by Dysthymia.
#Assuming we want to format the destination drive before backing up
#Version 0.9 to 1.0 - Removed multithreading argument as it was lower than the default (which is 8), added backup mode switch, and logging to root of backup drive.
#Version 1.0 to 1.1 - Added emptying of the recycle bin and more idiot proof warning before formatting.
#Version 1.1 to 1.2 - Added what I call "minutia" since I'd been adding it manually anyway.
#Version 1.2 to 1.3 - Added Windows Backup server option. Unable to determine how much space is needed, so going by my own test result.
#Version 1.3 to 1.4 - Added detection of running VMs in VMware Workstation Player, and a choice to either shut them down or abandon system backup (it crashes otherwise because I run my VM on my C: drive).
#Version 1.4 to 1.5 - Adding proper system backup allocation detection (by detecting system drive size minus free space), and a variable to pad the system backup allocation size.
#Version 1.5 to 1.6 - Automatically detect maximum drive numbers, leaving minimum at 0 to allow for other backup options. Also reminding users of the current drive information before asking them for any drive letters.
#Version 1.6 to 1.7 - Accounted for the size of the pre-defined but customizable minutia folders, alerting the user to how much space they'll need.

$Version = 1.7
$NumDrives = -1
$Username = $Env:UserName
$DataSize = 0 #DataSize will be in GB.
$MinutiaSize = 0 
$Minutia = @("C:\Users\$Username\Documents","C:\Users\$Username\Downloads")
$SysBackupPad = 1.1

cls
Write-Host "(¯`·._.·´¯`·._.·´¯`·._.·´¯`·._.·´¯)"
Write-Host "   Server backup script v$Version"
Write-Host "         By Dysthymia"
Write-Host "(_.·´¯`·._.·´¯`·._.·´¯`·._.·´¯`·._)"
Write-Host ""

function Test-Administrator  
{  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
}

If (-not (Test-Administrator)) { #ThenNeedAdminOpen
Write-Host "This script must be run as administrator. Exiting."
Exit } #ThenNeedAdminClose

Write-Host "This script will backup as many drives as you have (if there's room) to a single backup drive."
Write-Host "The recycle bin[s] will be emptied and the backup target drive will be formatted." -ForegroundColor Red
Write-Host "Current drive information (Size is in GB):"
$DriveInfo=  Get-Volume | Select -Property DriveLetter, Size | Where-Object {$_.DriveLetter -ne $Null} | Sort-Object DriveLetter
ForEach ($Object in $DriveInfo) { $Object.Size /= (1024*1024*1024)} 
ForEach ($Object in $DriveInfo) { $Object.Size = [math]::Round($Object.Size,0)} 
Write-Output $DriveInfo | FT

$IncludeMinutia = "heyull_naw"
While ( ($IncludeMinutia -ne 'y') -and
        ($IncludeMinutia -ne 'n') -and
        ($IncludeMinutia -ne 'yes') -and
        ($IncludeMinutia -ne 'no') ) { #IncludeMinutiaOpen
Write-Host "An additional set of folders to backup is defined in the script and is currently:"
Write-Host ""
forEach ($Folder in $Minutia) { #ForEachMinutiaFolderOpen
                                Write-Host $Folder 
                                $colItems = (Get-ChildItem $Folder -recurse | Measure-Object -property length -sum -ErrorAction Stop)
                                $MFolderSize = ($colItems.sum / (1024*1024*1024))
                                $MinutiaSize += $MFolderSize
                              } #ForEachMinutiaFolderClose
Write-Host ""
$MinutiaSize = [math]::Round($MinutiaSize,2)
$IncludeMinutia = Read-Host "Include this minutia, at $MinutiaSize GB? (y/n)" 
                                    } #IncludeMinutiaClose

#Determine data size of minutia if opted in
If ( ($IncludeMinutia -eq "y") -or
    ($IncludeMinutia -eq "yes") ) { #ThenAccountForMinutiaSizeOpen
    $DataSize += $MinutiaSize
    

                                  } #ThenAccountForMinutiaSizeClose


$IncludeSystemBackup = "newp"
#DetermineSystemBackupSize
Write-Host "Checking the size of the system drive..."
$SystemDrive = $env:CommonProgramFiles
$SystemDrive = $SystemDrive.subString(0,1)
#Write-Host "System drive letter is $SystemDrive."
$SystemDriveData = Get-Volume $SystemDrive | Select-Object Size,SizeRemaining
$SysDriveCapacity = $SystemDriveData.Size/(1024*1024*1024)
#Write-Host "System drive capacity is $SysDriveCapacity GB."
$SysDriveFree = $SystemDriveData.SizeRemaining/(1024*1024*1024)
#Write-Host "System drive free space is $SysDriveFree GB."
$SystemBackupAllocation = ($SysDriveCapacity - $SysDriveFree) * $SysBackupPad
$SystemBackupAllocation = [math]::Round($SystemBackupAllocation,2)
#Write-Host "System backup allocation is $SystemBackupAllocation GB."

While ( ($IncludeSystemBackup -ne "y") -and
      ($IncludeSystemBackup -ne "yes") -and
      ($IncludeSystemBackup -ne "n") -and
      ($IncludeSystemBackup -ne "no") ) { #IncludeSystemBackupOpen
$IncludeSystemBackup = Read-Host "Include system backup? This will allocate $SystemBackupAllocation GB (y/n)"
$VMwareRunning = Get-Process vmware-vmx -ea SilentlyContinue
If (($VMwareRunning -ne $Null) -and (($IncludeSystemBackup -eq "yes") -or ($IncludeSystemBackup -eq "y")) ) {#VMsMightBeRunning

$VMlist = cmd /c "C:\Program Files (x86)\VMware\VMware Player\vmrun.exe" list
$NumberOfVMs = $VMlist.Split(' ')[3]
$VMXFiles = ''
for ($i=1; $i -le $NumberOfVMs; $i++) { $VMXFiles = $VMXFiles + $VMlist.Split([Environment]::NewLine)[$i] }

If ($NumberOfVMs -gt 0) { #VMsAreRunning
$ShutdownVMs = "I dunno"
While ( ($ShutdownVMs -ne "y") -and
        ($ShutdownVMs -ne "yes") -and
        ($ShutdownVMs -ne "n") -and
        ($ShutdownVMs -ne "no") ) { #AskToShutdown
#Write-Host "VMware running variable is $VMwareRunning and IncludeSystemBackup is $IncludeSystemBackup"
$ShutdownVMs = Read-Host "VMs are running. Proceed to shut them down? (y/n)"
                                        } #AskToShutdown
If ( ($ShutdownVMs -eq "y") -or ($ShutdownVMs -eq "yes") ) { #RunShutdownCommand
forEach ($File in $VMXFiles) { cmd /c "C:\Program Files (x86)\VMware\VMware Player\vmrun.exe" stop $File }
                                                           } #RunShutdownCommand
                        } #VMsAreRunning
 If ( ($ShutdownVMs -eq "n") -or ($ShutdownVMs -eq "no") ) { #AbandonSystemBackup
 $IncludeSystemBackup = "no"
 Write-Host "Due to running VMs, system backup will not be included."
 #Read-Host -Prompt "Press Enter to continue."
                                                           } #AbandonSystemBackup

                                                                                                       }#VMsMightBeRunning
 } # IncludeSystemBackupClose

If ( ($IncludeSystemBackup -eq "y") -or
     ($IncludeSystemBackup -eq "yes") ) { #ThenIncludeWBOpen
$DataSize = $DataSize + $SystemBackupAllocation } #ThenIncludeWBClose

#Count the drives in the system. It has to be one less than the total in order to accommodate the backup drive.
$TotalDrives = Get-Volume | Select-Object DriveLetter
$DriveCount = -1 #Yes, negative one, so we don't count one of them -- the drive we're backing up to.
ForEach ($DriveLetter in $TotalDrives) { #CountDrivesOpen
If ($DriveLetter.DriveLetter -ne $Null) { $DriveCount += 1 } 
                                        } #CountDrivesClose

While ($NumDrives -lt 0 -or $NumDrives -gt $DriveCount) { #WhileDrivesInvalidOpen
$NumDrives = Read-Host "How many data drives to back up? " 
If ($NumDrives -gt $DriveCount) { #TooManyDrivesOpen
Write-Host "Not counting the backup destination itself, you can only backup $DriveCount drives." 
                                } #TooManyDrivesClose
                                                                  } #WhileDrivesInvalidClose

$Drives = @()
For ($i=1; $i -le $NumDrives; $i++) { #DriveLetterForLoopOpen
$DriveLetter = 'X'
$DrivePath = $DriveLetter +":\"
While ((-not (Test-Path $DrivePath) -or $DriveLetter -eq 'C')) { #WhileDriveLetterLoopOpen
$DriveLetter = Read-Host "Enter a drive letter to backup. " 
$DrivePath = $DriveLetter +":\" } #WhileDriveLetterLoopClose
$Drives = $Drives + $DrivePath} #DriveLetterForLoopClose

$BDrive = 'X'
$BPath = $BDrive +":\"
While ((-not (Test-Path $Bpath) -or $BDrive -eq 'C')) { #WhileBackupDriveInvalidOpen
#$BDrive = 'X'
#$BPath = $BDrive +":\"
$BDrive = Read-Host "Backup to what drive letter? "
$BPath = $BDrive +":\" } #WhileBackupDriveInvalidClose

#So, is there enough space on the destination drive to back up what's on the selected drives?
Write-Host "Determining how much data you're asking to backup..."

ForEach ($Drive in $Drives) { #AddUpDataToBeBackedUpOpen
$RecyclePath = $Drive + "`$Recycle.Bin"
takeown /f $RecyclePath /r | out-null
Write-Host "Emptying Recycle Bin for the $Drive drive..."
Clear-RecycleBin -DriveLetter $Drive -Confirm:$False -ea SilentlyContinue
$colItems = (Get-ChildItem $Drive -recurse | Measure-Object -property length -sum -ErrorAction Stop)
$DriveSize = ($colItems.sum / (1024*1024*1024))
$DataSize = $DataSize +[math]::Round($DriveSize,2) } #AddUpDataToBeBackedUpClose

If ( ($IncludeMinutia -eq 'y') -or
     ($IncludeMinutia -eq 'yes') ) { #MinutiaIncludedOpen
forEach ($Item in $Minutia) { #MinutiaSizeOpen
$colItems = (Get-ChildItem $Item -recurse | Measure-Object -property length -sum -ErrorAction Stop)
$ItemSize = ($colItems.sum / (1024*1024*1024))
$ItemSize = $ItemSize +[math]::Round($ItemSize,2)
$DataSize = $DataSize + $ItemSize
                            } #MinutiaSizeClose
                                   } #MinutiaIncludedClose

Write-Host "Checking if enough space is available on the $BDrive drive..."

$Object = Get-Volume -DriveLetter $BDrive
$BackupCapacity = $Object.Size /(1024*1024*1024)
$DataSize = [math]::Round($DataSize,2)
$BackupCapacity = [math]::Round($BackupCapacity,2)

If ($DataSize -gt $BackupCapacity) { #NotEnoughBackupSpaceOpen
Write-Host "Not enough room to backup $DataSize GB onto $BackupCapacity GB."
Write-Host "Exiting."
exit } #NotEnoughBackupSpaceClose

$Proceed = "nope"
While ($Proceed -ne "proceed") { #DoNotProceedOpen
Write-Host "Backing up $DataSize GB to the $BackupCapacity GB $BDrive drive."
Write-Host "WARNING!" -ForegroundColor Red -NoNewLine;
Write-Host "Proceeding will format all data on the $BDrive drive and back up the $Drives drive[s] to it."
$Proceed = Read-Host -Prompt "Type the word `"proceed`" to continue (without quotes)"
} #DoNotProceedClose

$CurrentDate = Get-Date -Format "MM-dd-yyyy"
$CurrentTime = Get-Date -Format "HH:mm"
Format-Volume -DriveLetter $BDrive -FileSystem ReFS -Force
Set-Volume -DriveLetter $BDrive -NewFileSystemLabel "Backup $CurrentDate"
$LogFile = "$BPath" + "BackupLog.txt"
New-Item "$LogFile" -ItemType "File"
Add-Content "$LogFile" "Backing up $DataSize GB from $NumDrives drive[s] to the $BDrive drive."
Add-Content "$LogFile" "Backup job beginning at $CurrentTime on $CurrentDate."

If ( ($IncludeSystemBackup -eq "y") -or 
     ($IncludeSystemBackup -eq "yes") ) { #ThenBackupSystemOpen
Add-Content "$LogFile" "Backing up system drive at $CurrentTime on $CurrentDate."
$Policy = New-WBPolicy
Add-WBSystemState -Policy $Policy
Add-WBBareMetalRecovery -Policy $Policy
$WBTarget = New-WBBackupTarget -VolumePath $BPath
Add-WBBackupTarget -Policy $Policy -Target $WBTarget
Start-WBBackup -Policy $Policy -Force } #ThenBackupSystemClose

If ( ($IncludeMinutia -eq 'y') -or
     ($IncludeMinutia -eq 'yes') ) { #IncludeMinuta2Open
$MinutiaBackupPath = $BPath + "\Minutia"
Add-Content "$LogFile" "Backing up minutia at $CurrentTime on $CurrentDate."
New-Item -Path $BPath -Name "Minutia" -ItemType "Directory"
ForEach ($Item in $Minutia) { #MinutiaCopyOpen
$MinutiaFolder = $Item.Split('\')[-1]
Write-Host $MinutiaFolder
$ThisFolder = $MinutiaBackupPath + "\$MinutiaFolder"
New-Item -Path $MinutiaBackupPath -Name $ThisFolder -ItemType "Directory"
robocopy $Item $ThisFolder /e /np /b /copyall /r:3 /w:0 /eta
                            } #MinutiaCopyClose
                                   } #IncludeMinutia2Close

ForEach ($Drive in $Drives) { #EachDriveLoopOpen
$SPath = $Drive
$DriveLetter = $Drive -replace ':\\',''
New-Item -Path $BPath -Name "$DriveLetter Drive" -ItemType "Directory"
$CurrentDate = Get-Date -Format "MM-dd-yyyy"
$CurrentTime = Get-Date -Format "HH:mm"
Add-Content "$LogFile" "Backing up $DriveLetter drive at $CurrentTime on $CurrentDate."
$DestPath = $BPath +"$DriveLetter Drive"
Write-Host "Backing up $Drive drive to $DestPath..."
robocopy $SPath $DestPath /e /np /b /copyall /r:10 /w:0 /eta } #EachDriveLoopClose

$CurrentDate = Get-Date -Format "MM-dd-yyyy"
$CurrentTime = Get-Date -Format "HH:mm"
Add-Content "$LogFile" "Backup job ended at $CurrentTime on $CurrentDate."