:: WARNING!!! This script will remove EVERY installed printer, their ports, and the unused drivers.
:: Use with caution.
:: You have been warned.
 
Cd \
Cd Windows\System32
setLocal EnableDelayedExpansion
CLS
 
:: Determine OS
If exist "c:\Users\Default\NTUSER.DAT" goto Win7
If exist "c:\Documents and Settings\All Users\NTUSER.DAT" goto WinXP
 
:WinXP
cls
Echo Removing all printers
:: Printer deletion
CSCRIPT /nologo %windir%\System32\prnmngr.vbs -x
 
:: Delete TCP/IP port
if exist c:\IPPorts.txt del c:\IPPorts.txt
if exist c:\IPPorts2.txt del c:\IPPorts2.txt
if exist c:\IPPorts3.txt del c:\IPPorts3.txt
cls
 
CSCRIPT /nologo %windir%\System32\prnport.vbs -l > c:\IPPorts.txt
type c:\IPPorts.txt | findstr IP_ > c:\IPPorts2.txt
for /f "tokens=* delims=" %%c in ('type c:\IPPorts2.txt') do (
 set LINE=%%c
 >> c:\IPPorts3.txt echo !LINE:~10!
)
for /f "delims=" %%x in (c:\IPPorts3.txt) do CSCRIPT /nologo %windir%\System32\prnport.vbs -d -r %%x
 
del c:\IPPorts.txt
del c:\IPPorts2.txt
del c:\IPPorts3.txt
 
:: Delete all un-used printer drivers
CSCRIPT /nologo %windir%\System32\prndrvr.vbs -x
 
goto Exit
 
:Win7
cls
Echo Removing all printers
:: Printer deletion
CSCRIPT /nologo %windir%\System32\Printing_Admin_Scripts\en-US\prnmngr.vbs -x
 
:: Delete TCP/IP port
if exist c:\IPPorts.txt del c:\IPPorts.txt
if exist c:\IPPorts2.txt del c:\IPPorts2.txt
if exist c:\IPPorts3.txt del c:\IPPorts3.txt
if exist c:\IPPorts4.txt del c:\IPPorts4.txt
cls
 
CSCRIPT /nologo %windir%\System32\Printing_Admin_Scripts\en-US\prnport.vbs -l > c:\IPPorts.txt
type c:\IPPorts.txt | findstr 172.20 > c:\IPPorts2.txt
type c:\IPPorts2.txt | findstr Port > c:\IPPorts3.txt
for /f "tokens=* delims=" %%c in ('type c:\IPPorts3.txt') do (
 set LINE=%%c
 >> c:\IPPorts4.txt echo !LINE:~10!
)
for /f "delims=" %%x in (c:\IPPorts4.txt) do CSCRIPT /nologo %windir%\System32\Printing_Admin_Scripts\en-US\prnport.vbs -d -r %%x
 
del c:\IPPorts.txt
del c:\IPPorts2.txt
del c:\IPPorts3.txt
del c:\IPPorts4.txt
 
:: Delete all used printer drivers
CSCRIPT /nologo %windir%\System32\Printing_Admin_Scripts\en-US\prndrvr.vbs -x
 
goto Exit
 
:Exit