# Set Variable
$Location = "C:\Users\Trainer\PSFolder\"

# C:\Users\Trainer\PSFolder
# C:\Users\Trainer\PSFolder\TextFiles
# C:\Users\Trainer\PSFolder\Users
# C:\Users\Trainer\PSFolder\Data
# C:\Users\Trainer\PSFolder\PSFolderDelete
# C:\Users\Trainer\PSFolder\PSFolderDelete30
# C:\Users\Trainer\PSFolder\PSFolderNew

Get-Command *Item*

# Retrieve items in a folder
Get-ChildItem -Force $Location

# Retrieve items in a folder and all sub-folders
Get-ChildItem -Force $Location -Recurse

# Include specific file formats
Get-ChildItem -Path $Location -Recurse -Include *.xlsx

# Exclude specific formats
Get-ChildItem -Path $Location -Recurse -Exclude *.xlsx 

# Get all item and filter by last write time
Get-ChildItem -Path $Location -Recurse | Where-Object -FilterScript {($_.LastWriteTime -gt '2020-10-22')}

# Create Directory and File
New-Item -Path "$($Location)\PSFolderNew" -ItemType Directory
New-Item -Path "$($Location)\PSFolderNew\PSFile.txt" -ItemType File

# Create Text, CReate File and add Text
$document = 'Lorem ipsum dolor sit amet consectetur adipiscing elit.' | Out-File -FilePath "$($Location)PSFolder\PSDocument.txt" 

# Removing Items in Folder
Remove-Item -Path "$($Location)\PSFolderDelete" -Recurse

# Copy Files
Copy-Item -Path "$($Location)\Users\Users.xlsx" -Destination "$($Location)\Users\UsersCopy.xlsx"

# Rename Files
Rename-Item -Path "$($Location)\Users\UsersCopy.xlsx" -NewName "UsersCopyCopy.xlsx"

# Rename File Extensions
Get-ChildItem "$($Location)\TextFiles\*.txt" | Rename-Item -NewName { $_.name -Replace '\.txt$','.bak' }