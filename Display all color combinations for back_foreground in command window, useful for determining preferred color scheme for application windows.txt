@echo off
setlocal EnableDelayedExpansion
color 07
 
:start
call :initColor
 
:: Apply each color combination to the phrase "Hello World"
for %%G in (0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F) do (
    for %%U in (0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F) do (
        ping localhost -n 1 >Nul
        set "var=Hello World %%G%%U" !
        findstr /p /A:%%G%%U "." "!var!\..\X" nul
        <nul set /p ".=%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%"
    )
)
del X
 
echo.
echo.
echo Press any key to show a WIDE screen version (better readability)
echo monitor must be at least 24"
pause >nul
cls
MODE CON: COLS=222 LINES=25
goto:start
pause>nul
 
 
:: Credit to Jeb for color conversion routine. See URL http://stackoverflow.com/questions/4339649/how-to-have-multiple-colors-in-a-windows-batch-file
:initColor
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)
<nul > X set /p ".=."
exit /b