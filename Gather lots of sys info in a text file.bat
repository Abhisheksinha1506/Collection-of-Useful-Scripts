@echo off
color a
if exist %computername%.txt. ( 
    del %computername%.txt.
) else (
    goto B
)
:B
if exist infosideload.bat. ( 
    start infosideload.bat
) else (
echo ^/^/
    echo Error...
    echo Missing Program infosideload.bat
echo ^\^\
echo.
echo.
    goto A
)
 
::Created by www.reddit.com/u/bsmith0
::This program is designed to gather Software, Hardware, Server and Network Info
 
:A
 
title 1%%
echo PreSystem Summary 1%% complete 
call :StartTimer
echo Computer Name: %computername%>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo System Summary>>%computername%.txt
echo.>>%computername%.txt
systeminfo>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo Logon Server
echo Logon Server>>%computername%.txt
echo.>>%computername%.txt
systeminfo /s %logonserver%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
cls
 
 
 
 
title 14%%
echo Finding Username information 14%% complete 
echo User Name: %username%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
cls
 
title 21%%
echo Finding Time information 21%% complete 
echo Time: %time%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
cls
 
 
title 28%%
echo Finding Date information 28%% complete 
echo Date: %date%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
cls
 
 
title 35%%
echo Finding All ip compartment information 35%% complete 
echo All Compartments:>>%computername%.txt
ipconfig /allcompartments /all>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
cls
 
 
title 42%%
echo Finding All ip information 42%% complete 
echo ip  info:>>%computername%.txt
ipconfig /all>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
cls
 
 
title 49%%
echo Finding User information 49%% complete 
echo User info:>>%computername%.txt
set %1>>%computername%.txt
echo.>>%computername%.txt
echo %userprofile%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
cls
 
 
title 56%%
echo Finding Version information 56%% complete 
echo version:>>%computername%.txt
ver>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
cls
 
 
title 63%%
echo Finding dir of c:\users information 63%% complete 
dir c:\users /a h r>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
cls
 
 
title 70%%
echo Finding tree of C:\users information 70%% complete 
tree c:\users /a>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
cls
 
 
title 77%%
echo Finding logon server information 77%% complete 
echo Logon Server:>>%computername%.txt
echo.>>%computername%.txt
echo %logonserver%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
cls
 
 
title 84%%
echo Finding task manager information 84%% complete 
echo Tasks:>>%computername%.txt
tasklist>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
cls
 
 
title 91%%
echo Finding Net Local Group information 91%% complete 
echo Net Local Group:>>%computername%.txt
net localgroup>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
cls
 
 
title 98%%
echo Finding Net View information 98%% complete 
echo Net View:>>%computername%.txt
net view>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
cls
 
echo all users profile:>>%computername%.txt
echo %allusersprofile%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
 
echo app data:>>%computername%.txt
echo %appdata%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
 
echo cmd info:>>%computername%.txt
echo %cmdcmdline%>>%computername%.txt
echo %cmdextversion%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
 
echo cmd path:>>%computername%.txt
echo %comspec%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
 
echo homedrive:>>%computername%.txt
echo %homedrive%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
 
echo homepath:>>%computername%.txt
echo %homepath%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
 
echo homeshare:>>%computername%.txt
echo %homeshare%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
 
echo num of processors:>>%computername%.txt
echo %number_of_processors%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
 
echo os:>>%computername%.txt
echo %os%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
 
echo path search for executable:>>%computername%.txt
echo %path%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
 
echo list of executable extensions:>>%computername%.txt
echo %pathext%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
 
echo processor info:>>%computername%.txt
echo %processor_architecture%>>%computername%.txt
echo %processor_identtifier%>>%computername%.txt
echo %processor_level%>>%computername%.txt
echo %processor_revision%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
 
echo user domain:>>%computername%.txt
echo %userdomain%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
 
 
echo user profile:>>%computername%.txt
echo %userprofile%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
 
echo system drive:>>%computername%.txt
echo %systemdrive%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
 
echo system root:>>%computername%.txt
echo %systemroot%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
 
echo location of os directory:>>%computername%.txt
echo %windir%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
 
 
echo Volume Drive:>>%computername%.txt
vol c:>>%computername%.txt
echo.>>%computername%.txt
vol d:>>%computername%.txt
echo.>>%computername%.txt
vol e:>>%computername%.txt
echo.>>%computername%.txt
vol f:>>%computername%.txt
echo.>>%computername%.txt
vol x:>>%computername%.txt
echo.>>%computername%.txt
vol q:>>%computername%.txt
echo.>>%computername%.txt
vol y:>>%computername%.txt
echo.>>%computername%.txt
vol z:>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
 
 
echo Driver Query
echo Driver Query>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
driverquery>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
cls
 
 
echo Net Accounts:>>%computername%.txt
net accounts>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
 
echo Net Statistcs computer,(workstation):>>%computername%.txt
net statistics workstation>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
echo net accounts:>>%computername%.txt
 
echo Net Statistcs (server):>>%computername%.txt
net statistics server>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
 
 
 
echo Net Share:>>%computername%.txt
net share>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
cls
 
echo Pinging-%computername% ...
echo Ping Results IPv4:>>%computername%.txt
ping -n 1 -4 %computername%>>%computername%.txt
set server=%logonserver:\\=%
ping -n 1 -4 %server%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
cls
 
 
 
echo Pinging-%computername% ...
echo Ping Results IPv6:>>%computername%.txt
ping -n 1 -6 %computername%>>%computername%.txt
set server=%logonserver:\\=%
ping -n 1 -6 %server%>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
cls
 
echo Tracert-%computername% 1/5...
echo Tracert LocalHost >>%computername%.txt
tracert localhost>>%computername%.txt
echo Tracert-%computername% 2/5...
echo computer name>>%computername%.txt
tracert %computername%>>%computername%.txt
echo Tracert-%computername% 3/5...
echo logon server>>%computername%.txt
tracert %server%>>%computername%.txt
echo Tracert-%computername% 4/5...
echo local host ipv4>>%computername%.txt
tracert -4 localhost>>%computername%.txt
echo Tracert-%computername% 5/5...
 
echo tracert complete
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
cls
 
echo Gathering disks...
echo All Disk Drives>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
wmic logicaldisk get name>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
cls
 
 
 
 
 
echo Windows Version
echo Windows Versions>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
ver>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo -----------DONE------------>>%computername%.txt
cls
 
title 100%%
 
echo Compiling log information 100%% complete
if %errorlevel%==0 echo Log complete=completed at %time% %date% on %computername%>>%computername%.txt
 
if %errorlevel% == 1 echo Log Error: information=Error code is [%errorlevel%]=errorcode id is[file or command not found]     completed at %time% %date% on %computername%>>%computername%.txt
 
if %errorlevel% geq 2 echo Log Error: information=Error code is [%errorlevel%]=errorcode id is[unkown]       completed at %time% %date% on %computername%>>%computername%.txt
 
 
echo.>>%computername%.txt
echo.>>%computername%.txt
echo LOG>>%computername%.txt 
echo Infogather>>%computername%.txt
echo File=Log File>>%computername%.txt
echo errorresult>>%computername%.txt
echo errorresult=%errorcode%>>%computername%.txt
echo Name=Infogather Log>>%computername%.txt
echo Status=Completed>>%computername%.txt
echo Version=5.2>>%computername%.txt
echo Created=%time% %date%>>%computername%.txt
echo ------------------------------->>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
echo Finish>>%computername%.txt
echo.>>%computername%.txt
echo.>>%computername%.txt
 
 
 
cls
title Infogather 6.1
call :StopTimer
call :DisplayTimerResult
call :DisplayTimerResult>>%computername%.txt
echo infogather was completed at %time% %date%
echo Log file located in [%cd%] current directory called "%computername%.txt"
echo This Log File Contains Server, Network and Computer Information 
echo.
echo Press "O" and ENTER to Open Log
echo Press Any Other Key and ENTER to Exit
set /p letter="Please Enter Your Choice: "
if %letter%==o start %computername%.txt
if %letter%==O start %computername%.txt
exit
 
 
 
:StartTimer
:: Store start time
set StartTIME=%TIME%
for /f "usebackq tokens=1-4 delims=:., " %%f in (`echo %StartTIME: =0%`) do set /a Start100S=1%%f*360000+1%%g*6000+1%%h*100+1%%i-36610100
goto :EOF
 
:StopTimer
:: Get the end time
set StopTIME=%TIME%
for /f "usebackq tokens=1-4 delims=:., " %%f in (`echo %StopTIME: =0%`) do set /a Stop100S=1%%f*360000+1%%g*6000+1%%h*100+1%%i-36610100
:: Test midnight rollover. If so, add 1 day=8640000 1/100ths secs
if %Stop100S% LSS %Start100S% set /a Stop100S+=8640000
set /a TookTime=%Stop100S%-%Start100S%
set TookTimePadded=0%TookTime%
goto :EOF
 
:DisplayTimerResult
:: Show timer start/stop/delta
echo Started: %StartTime%
echo Stopped: %StopTime%
echo Elapsed: %TookTime:~0,-2%.%TookTimePadded:~-2% seconds
goto :EOF
 
:hello
set c=0
set cm=314808
SETLOCAL ENABLEDELAYEDEXPANSION
for /f "tokens=1,2,3,4,5* skip=4" %%a in ('TASKLIST /V /FI "MEMUSAGE ge 0"') do echo %%e>>h
for /f "tokens=1,2,3,4,5* delims=," %%a in (h) do (
       call set /a c=!%c%!+%%a%%b
)
set /a fin=%cm%/%c%
Del /q/f h
cls
echo cpu=%fin%%>>%computername%.txt
timeout 0 >nul