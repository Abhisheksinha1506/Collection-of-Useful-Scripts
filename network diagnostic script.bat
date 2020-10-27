@echo off
color 1f
Title NETWORK DIAGNOSTICS
mode 80,13
cls
echo.
echo This script will test a few things and save the results in a file named 
echo "NetworkReport.txt" on your desktop. When the script is done, just send
echo that file to your tech support person and they'll know what to do next!
echo.
pause
 
                                                                        :::::::::::::::::::::::::
                                                                        ::    INTERNET TEST    ::
                                                                        :::::::::::::::::::::::::
                                                                
 
set _log=%UserProfile%\Desktop\NetworkReport.txt
 
echo.
echo Testing your network connection and generating a report.
echo Please wait...
echo.
set _PingWANworking=0
 
::try to ping different WAN IP addresses. If all fail, user has no internet access.
set _PingTarget=8.8.8.8
call :WANpingTest
 
set _PingTarget=4.2.2.2
call :WANpingTest
 
set _PingTarget=192.0.43.10
call :WANpingTest
 
::if internet is working, test DNS next. If not, skip testing DNS
echo. >> %_log%
If %_PingWANworking% == 0 (
    echo --Internet Ping Test: FAILED >> %_log%
    echo   Failed to ping any public IP addresses. >> %_log%
    goto SkipDNS
    ) ELSE (
    echo --Internet Ping Test: PASSED >> %_log%
    echo   Successfully pinged public IP addresses. >> %_log% >> %_log%
    )
 
                                                                        ::::::::::::::::::::
                                                                        ::    DNS TEST    ::
                                                                        ::::::::::::::::::::
                                                                        
echo.
echo Testing DNS.
echo Please wait...
echo.
set _DNSworking=0
 
::try to ping different WAN domains. If all fail, DNS is not working.
set _PingTarget=www.google.com
call :WANpingTestDNS
 
set _PingTarget=icann.org
call :WANpingTestDNS
 
set _PingTarget=amazon.com
call :WANpingTestDNS
 
echo. >> %_log%
If %_DNSworking% == 0 (
    echo --Internet DNS Test: FAILED >> %_log%
    echo   Could ping public sites by IP address but not by name. >> %_log%
    ) ELSE (
    echo --Internet DNS Test: PASSED >> %_log%
    echo   Able to ping external sites by name and by IP address. >> %_log%
    )
                                                                
:SkipDNS                                                                    
                                                                        
                                                                        ::::::::::::::::::::::::
                                                                        ::    GATEWAY TEST    ::
                                                                        ::::::::::::::::::::::::
:: Get the gateways into the variables
for /f "tokens=2,3 delims={,}" %%a in ('"WMIC NICConfig where IPEnabled="True" get DefaultIPGateway /value | find "I" "') do (
    set _ipv4GW=%%~a
    set _ipv6GW=%%~b
    )
set _ipv4Working=0
set _ipv6Working=0
set _gatewayworking=0
 
 
::Try to ping the IPv4 gateway if enabled
if [%_ipv4gw%]==[] goto 4disabled
 
ping -n 1 %_ipv4GW% | find "TTL="
if errorlevel 1 (
    echo The default gateway %_ipv4GW% could not be reached.
    ) ELSE (
    set _ipv4Working=1)
    
echo. >> %_log%
If %_ipv4Working% == 1 (
    echo --IPv4 Default Gateway Ping Test: PASSED >> %_log%
    echo   Able to ping %_ipv4GW%. >> %_log%
    ) ELSE (
    echo --IPv4 Default Gateway Ping Test: FAILED >> %_log%
    echo   Not able to ping %_ipv4GW%. >> %_log%
    )   
:skipped4
 
 
::Try to ping the IPv6 gateway if enabled
if [%_ipv6gw%]==[] goto 6disabled
 
 
 
ping -n 1 %_ipv6GW% | find /v "times" | find "time"
if errorlevel 1 (
    echo The default gateway %_ipv6GW% could not be reached.
    ) ELSE (
    set _ipv6Working=1)
    
echo. >> %_log%
If %_ipv6Working% == 1 (
    echo --IPv6 Default Gateway Ping Test: PASSED >> %_log%
    echo   Able to ping %_ipv6GW%. >> %_log%
    ) ELSE (
    echo --IPv6 Default Gateway Ping Test: FAILED >> %_log%
    echo   Not able to ping %_ipv6GW%. >> %_log%
    )   
:skipped6
 
 
                                                                        :::::::::::::::::::::::::
                                                                        ::    WIRELESS TEST    ::
                                                                        :::::::::::::::::::::::::
                                                    
::check for wireless connection
::test if wlan service is running or not, then display wireless SSID info
echo. >> %_log%
sc query wlansvc | find "RUNNING"
If errorlevel 1 (
    echo --Wireless test: SKIPPED >> %_log%
    echo   The wireless service 'wlansvc' is not running or is not present. >> %_log%
    ) ELSE (
    netsh wlan show interfaces | find " SSID"
        IF errorlevel 1 (
        echo --Wireless status: DISCONNECTED >> %_log%
        echo   Not currently connected to a wireless network. >> %_log%
        ) ELSE (
        echo --Wireless status: CONNECTED to the network listed below >> %_log%
        netsh wlan show interfaces | find " SSID" >> %_log%
        )
    )
                                                                        ::APIPA DETECTOR::
                                                                        
ipconfig /all | find "169.254"
if errorlevel 1 goto adapterinfo
echo. >> %_log%
echo --Self assigned IP address test: FAILED >> %_log%
echo  Below please review IPCONFIG /ALL for more information. At least one self assigned IPv4 address was detected.  >> %_log%
 
    
                                                                        :::::::::::::::::::::::::
                                                                        ::    ADAPTER INFO     ::
                                                                        :::::::::::::::::::::::::
:adapterinfo
::display enabled, disabled and disconnected adapters
echo. >> %_log%
echo. >> %_log%
 
echo. >> %_log%
echo --Network adapters that are CONNECTED: (note that some of these may be virtual) >> %_log%
wmic /append:%_log% path win32_networkadapter where (netconnectionstatus=2 AND PhysicalAdapter='TRUE') get name, macaddress, manufacturer, netconnectionID
 
echo. >> %_log%
echo --Network adapters that are DISABLED: (note that some of these may be virtual) >> %_log%
wmic /append:%_log% path win32_networkadapter where (netconnectionstatus=0 AND PhysicalAdapter='TRUE') get name, macaddress, manufacturer, netconnectionID
 
echo. >> %_log%
echo --Network adapters that are DISCONNECTED: (note that some of these may be virtual) >> %_log%
wmic /append:%_log% path win32_networkadapter where (netconnectionstatus=7 AND PhysicalAdapter='TRUE') get name, macaddress, manufacturer, netconnectionID
 
echo. >> %_log%
 
echo --Detailed information: SEE BELOW >> %_log%
echo   IPCONFIG /ALL >> %_log%
ipconfig /all >> %_log%
 
cls
echo.
color 2f
echo DIAGNOSTICS COMPLETE!
echo.
echo Look on your desktop for a text file named "NetworkReport.txt"
echo Please send that file to the person that requested it.
echo.
echo If you are unable to email it from this computer, please instead
echo save it onto a flash drive to bring to another computer,
echo and then email the file to your helpdesk contact from there.
echo. 
echo Please read the above, then press E to exit.
Choice /c E
If errorlevel 1 exit /b
::that's all, folks
 
 
                                                                                    :::::::::::::::::
                                                                                    :: SUBROUTINES ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 
 
:WANpingTest
Ping -n 1 %_PingTarget% | find /v "times" | find "time"
If %errorlevel% == 0 set _PingWANworking=1
goto :EOF
 
:WANpingTestDNS
Ping -n 1 %_PingTarget% | find /v "times" | find "time"
If %errorlevel% == 0 set _DNSworking=1
goto :EOF
 
:4disabled
echo. >> %_log%
echo --IPv4 Default Gateway Ping Test: SKIPPED >> %_log%
echo   No IPv4 default gateway is configured.  >> %_log%
goto skipped4
 
:6disabled
echo. >> %_log%
echo --IPv6 Default Gateway Ping Test: SKIPPED >> %_log%
echo   No IPv6 default gateway is configured.  >> %_log%
goto skipped6