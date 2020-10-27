@echo off && cls
mode con: cols=85 lines=40
::
:: variables
::
set drive=!folder!
:: Script info
set script_name=BackupScript
set script_version=0.0.2
:: Time
FOR /f %%a in ('WMIC OS GET LocalDateTime ^| find "."') DO set DTS=%%a
set CUR_DATE=%DTS:~0,4%-%DTS:~4,2%-%DTS:~6,2%
:: Log info
set logdir=BackupLogs
set logpath=%SystemDrive%\%logdir%
set logfile=backup_%computername%_%CUR_DATE%.log
if not exist %logpath% mkdir %logpath%
if not exist %logpath%\%logfile% echo. > %logpath%\%logfile%
:: Robo info
set backupCmd=ROBOCOPY
set robocopyArgs=/COPY:D /S /MIR /XJ /XA:S /W:1 /R:1 /LOG+:%logpath%\robo.log /TEE /XX
set robocopyArgs2=/COPY:D /XJ /XA:S /W:1 /R:1 /LOG+:%logpath%\robo.log /TEE /XX
:: Outlook path
set outlookpath=%USERPROFILE%\AppData\Local\Microsoft\Outlook
:: Cmd args
set skip_app=no
set skip_con=no
set skip_des=no
set skip_doc=no
set skip_dow=no
set skip_fav=no
set skip_lin=no
set skip_mus=no
set skip_pic=no
set skip_gam=no
set skip_vid=no
set skip_out=no
::
:: Parse command-line arguments
::
for %%i in (%*) do (
    if /i %%i==-ap set skip_app=yes  
    if /i %%i==-co set skip_con=yes
    if /i %%i==-de set skip_des=yes
    if /i %%i==-dc set skip_doc=yes
    if /i %%i==-dw set skip_dow=yes
    if /i %%i==-fa set skip_fav=yes
    if /i %%i==-li set skip_lin=yes
    if /i %%i==-mu set skip_mus=yes
    if /i %%i==-pi set skip_pic=yes
    if /i %%i==-ga set skip_gam=yes
    if /i %%i==-vi set skip_vid=yes
        if /i %%i==-ol set skip_out=yes
    )
::
:: Config screen
::     
color 1f
title %script_name% v%script_version%
cls
echo  --       %script_name% v%script_version%      --
echo  ------------------------------------
echo  ** Script config displayed below. **
echo  **    Review before proceeding.   **
echo  ------------------------------------
echo         Folders:     Skip?
echo  ====================================
echo          AppData     %skip_app%
echo         Contacts     %skip_con%        
echo          Desktop     %skip_des%        
echo        Documents     %skip_doc%
echo        Downloads     %skip_dow%
echo        Favorites     %skip_fav%      
echo            Links     %skip_lin%          
echo            Music     %skip_mus%                  
echo         Pictures     %skip_pic%    
echo      Saved Games     %skip_gam%
echo           Videos     %skip_vid%
echo          Outlook     %skip_out%
echo  ====================================
echo                Options
echo  ------------------------------------
echo     1  to start backup
echo     2  reset flags and start again
echo  ------------------------------------
set /p answer=Option [1/2]?
if /i {%answer%}=={1} (goto :backup)
if /i {%answer%}=={2} (RUN_ME.bat)
pause
::
:: Backup begin
::
@echo off && cls
:backup
call :log2 ################################################################################
call :log2 #                       Backup beginning, please wait...                       #
call :log2 ################################################################################
call :StartTimer
:appdata
if /i %skip_app%==yes (
        call :log ### Skipping AppData
        goto contacts
)
call :log # Backing up AppData directory...
%backupCmd% "%USERPROFILE%\AppData" "%drive%\%CUR_DATE%\AppData" %robocopyArgs%
call :log # AppData directory backup complete!
 
:contacts
if /i %skip_con%==yes (
        call :log ### Skipping Contacts
        goto desktop
)
call :log # Backing up Contacts directory...  
%backupCmd% "%USERPROFILE%\Contacts" "%drive%\%CUR_DATE%\Contacts" %robocopyArgs%
call :log # Contacts directory backup complete!
 
:desktop
if /i %skip_des%==yes (
        call :log ### Skipping Desktop
        goto documents
)
call :log # Backing up Desktop directory...  
%backupCmd% "%USERPROFILE%\Desktop" "%drive%\%CUR_DATE%\Desktop" %robocopyArgs%
call :log # Desktop directory backup complete!
 
:documents
if /i %skip_doc%==yes (
        call :log ### Skipping Documents
        goto downloads
)
call :log # Backing up Documents directory...  
%backupCmd% "%USERPROFILE%\Documents" "%drive%\%CUR_DATE%\Documents" %robocopyArgs%
call :log # Documents directory backup complete!
 
:downloads
if /i %skip_dow%==yes (
        call :log ### Skipping Downloads
        goto favorites
)
call :log # Backing up Downloads directory...  
%backupCmd% "%USERPROFILE%\Downloads" "%drive%\%CUR_DATE%\Downloads" %robocopyArgs%
call :log # Downloads directory backup complete!
 
:favorites
if /i %skip_fav%==yes (
        call :log ### Skipping Favorites
        goto links
)
call :log # Backing up Favorites directory...  
%backupCmd% "%USERPROFILE%\Favorites" "%drive%\%CUR_DATE%\Favorites" %robocopyArgs%
call :log # Favorites directory backup complete!
 
:links
if /i %skip_lin%==yes (
        call :log ### Skipping Links
        goto music
)
call :log # Backing up Links directory...  
%backupCmd% "%USERPROFILE%\Links" "%drive%\%CUR_DATE%\Links" %robocopyArgs%
call :log # Links directory backup complete!
 
:music
if /i %skip_mus%==yes (
        call :log ### Skipping Music
        goto pictures
)
call :log # Backing up Music directory...  
%backupCmd% "%USERPROFILE%\Music" "%drive%\%CUR_DATE%\Music" %robocopyArgs%
call :log # Music directory backup complete!
 
:pictures
if /i %skip_pic%==yes (
        call :log ### Skipping Pictures
        goto games
)
call :log # Backing up Pictures directory...  
%backupCmd% "%USERPROFILE%\Pictures" "%drive%\%CUR_DATE%\Pictures" %robocopyArgs%
call :log # Pictures directory backup complete!
 
:games
if /i %skip_gam%==yes (
        call :log ### Skipping Saved Games
        goto videos
)
call :log # Backing up Saved Games directory...  
%backupCmd% "%USERPROFILE%\Saved Games" "%drive%\%CUR_DATE%\Saved Games" %robocopyArgs%
call :log # Saved Games directory backup complete!
 
:videos
if /i %skip_vid%==yes (
        call :log ### Skipping Videos
        goto outlook
)
call :log # Backing up Videos directory...  
%backupCmd% "%USERPROFILE%\Videos" "%drive%\%CUR_DATE%\Videos" %robocopyArgs%
call :log # Videos directory backup complete!  
 
 
:outlook
if /i %skip_out%==yes (
        call :log ### Skipping outlook.pst
        goto post
)
call :log # Backing up outlook.pst...  
%backupCmd% "%outlookpath%" "%drive%\%CUR_DATE%\Outlook" "Outlook.pst" %robocopyArgs2%
call :log # Videos directory backup complete!  
::
:: Back end
::
:post
call :StopTimer
cls
call :log2 ################################################################################
call :log2 #                              Backup complete!                                #
call :log2 ################################################################################
echo.
call :log Elapsed time: %TookTime:~0,-2%.%TookTimePadded:~-2% seconds
echo.
call :log Backup location: !folder!
call :log Backup log location: %logpath%
echo.
@pause
 
::
:: Call functions
::
:: Log
:log
echo [%CUR_DATE%] - %TIME%    %*>> "%logpath%\%logfile%"  
echo [%CUR_DATE%] - %TIME%    %*
goto :eof
:log2
echo %*>> "%logpath%\%logfile%"  
echo %*
goto :eof
:: Timer
:StartTimer
:: Store start time
set StartTIME=%TIME%
for /f "usebackq tokens=1-4 delims=:., " %%f in (`echo %StartTIME: =0%`) do set /a Start100S=1%%f*360000+1%%g*6000+1%%h*100+1%%i-36610100
goto :eof
:StopTimer
:: Get the end time
set StopTIME=%TIME%
for /f "usebackq tokens=1-4 delims=:., " %%f in (`echo %StopTIME: =0%`) do set /a Stop100S=1%%f*360000+1%%g*6000+1%%h*100+1%%i-36610100
:: Test midnight rollover. If so, add 1 day=8640000 1/100ths secs
if %Stop100S% LSS %Start100S% set /a Stop100S+=8640000
set /a TookTime=%Stop100S%-%Start100S%
set TookTimePadded=0%TookTime%
goto :eof
:: eof
:eof