SETLOCAL
@echo off && cls && echo. && echo  Loading...
:::::::::::::::===============================================
:: Get admin rights
::
:: Check for permissions
::
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
:: If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
mode con: cols=48 lines=28
color 1f
title Backup Location
cls
echo  =============================================
echo                 Backup Location
echo  ---------------------------------------------
echo            Please select a location 
echo              to backup your files
echo  =============================================
set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Please choose a folder.',0,0).self.path""

for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"
cls
setlocal enabledelayedexpansion
echo  =============================================
echo  Backup location set to:
echo  !folder!
echo  ---------------------------------------------
echo   The following folders will be backed up:
echo.
echo       -AppData, Contacts, Desktop, Documents
echo        Downloads, Favorites, Links, Music, 
echo        Pictures, Saved Games, Videos, Outlook.
echo  ---------------------------------------------
echo   Exclude any of these folders or press enter 
echo    to continue. 
echo.
echo     		AppData   -ap
echo     		Contacts  -co
echo     		Desktop   -de
echo     		Documents -dc
echo     		Downloads -dw
echo     		Favorites -fa
echo     		Links     -li
echo     		Music     -mu
echo     		Pictures  -pi
echo     		SavedGame -ga
echo     		Videos    -vi
echo			Outlook   -ol
echo  =============================================
set /p answer=Flags? 
backup.bat %answer%
pause