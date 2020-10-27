@Echo Off

Cd %systemroot%\system32

net sess>nul 2>&1||(start mshta vbscript:code(close(Execute("CreateObject(""Shell.Application"").ShellExecute""%~0"",,,""RunAs"",1"^)^)^)&exit)

:_Start
Cls & Mode CON  LINES=11 COLS=60 & Color 0D &Title Created By FreeBooter
Echo.
Echo       ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
Echo       º Type (D) letter to Disable Windows Defender º  
Echo       ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
Echo.
Echo.
Echo       ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»  
Echo       º Type (E) letter to Enable Windows Defender  º  
Echo       ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼  



Set /p input= RESPONSE: 
If /i  Not %input%==D (Goto :_Ex) Else (Goto :_Disbale)

:_Ex
If /i  Not %input%==E  (Goto :_Start) Else (Goto :_Enable)





:_Disbale
:: Disable Windows Defender with  Group Policy. 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f > Nul
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d "1" /f > Nul
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d "1" /f > Nul
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /t REG_DWORD /d "1" /f > Nul
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f  > Nul

Cls & Mode CON  LINES=5 COLS=49 & Color 0C & Title - WARNING -
 Echo.
 Echo. 
 Echo            Windows Defender Disabled
Ping -n 5  localhost > Nul
Cls
Echo.
Echo. 
CHOICE /C YN /M "Press Y to Reboot, N for exiting script."


If %errorlevel% == 1 ( Shutdown /r /t 0) Else (Exit)




:_Enable
:: Enable Windows Defender with  Group Policy. 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "0" /f > Nul
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d "0" /f > Nul
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d "0" /f > Nul
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /t REG_DWORD /d "0" /f > Nul
Reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /f > Nul


Cls & Mode CON  LINES=5 COLS=49 & Color 0C & Title - WARNING -
 Echo.
 Echo. 
 Echo            Windows Defender Enabled

Ping -n 5  localhost > Nul
Cls
Echo.
Echo. 
CHOICE /C YN /M "Press Y to Reboot, N for exiting script."


If %errorlevel% == 1 ( Shutdown /r /t 0) Else (Exit)