@echo off
:FilePrompt
set HitCount=
cls
set /p UserFile="Which file to search?: "
echo.
:SkipFilePrompt
for /f "tokens=*" %%G in ('where /R .\ %UserFile%') do call :ProcessFile "%%G"
goto RequestRepeat
:ProcessFile
set /a HitCount += 1
echo %HitCount%) %~1 ^| (%~z1 bytes at %~t1)
set /p OpenFolder="Open Location (Y/N)?"
if /I "%OpenFolder%" EQU "Y" start explorer.exe "%~dp1"
goto :EOF
:RequestRepeat
echo.
set /p DoAgain=Process another (Y/N)?
if /I "%DoAgain%" EQU "Y" goto FilePrompt
:end