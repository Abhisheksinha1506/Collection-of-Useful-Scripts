@echo off
:START
color 1F
cls
title View wireless SSID list
 
::Display list of SSIDs stored in this computer and prompt user to choose one
Netsh wlan show profiles
Echo If you wish to view the security key for one of the above SSIDs,
Set /p SSID=enter its name here: 
echo.
 
::Detect whether the user's chosen SSID is in the list
Netsh wlan show profiles name= %SSID% > NUL
If errorlevel 1 (
    ::warn user that SSID is not in the list, then start over
    color 6f
    echo.
    echo Sorry, that SSID is not found.
    pause
    goto start
    ) 
 
:VIEWKEY
 
::The below spacing is deliberately wide for readability of results when a security key is displayed
echo     SSID                   : %SSID%
 
::Display key content if available
netsh wlan show profile name="%SSID%" key=clear | find "Key Content"
If errorlevel 1 (
    ::Turn yellow and warn if a key is not found for this SSID
    color 6f
    echo The security key is not found for this SSID.
    echo It is possible that this SSID is open and does not
    echo require a key, or one may not have been saved.
    echo.
    ) ELSE (
    ::Turn green if a key was found for this SSID
    color 2f)
echo.
 
::Give the user a chance to view another key
choice /c EVR /m "Would you like to (E)xit, (V)iew another key, or (R)emove this profile?"
If errorlevel 3 goto RemoveWarning
If errorlevel 2 goto start
If errorlevel 1 goto exit
 
:EXIT
exit /b
 
:RemoveWarning
::warn user that they are about to delete the profile
color 4f
cls
echo ***********
echo * WARNING *
echo ***********
echo.
echo This computer will forget the profile and security key
echo for the wireless network named "%SSID%".
echo.
choice /c YN /m " Are you sure this is what you want to do?"
If errorlevel 2 goto start
If errorlevel 1 goto keyremoval
 
 
:keyremoval
::Attempt to remove the profile
cls
netsh wlan delete profile name="%SSID%" | find "is deleted"
If errorlevel 1 (
    ::Turn red and warn if a the profile could not be removed.
    color 4f
    echo.
    echo That profile was not found or could not be deleted.
    echo Please check the name and try again.
    echo If the name contains any special characters, it may need
    echo to be deleted manually instead.
    pause
    goto start
    ) ELSE (
    ::Turn green if the profile was removed successfully
    color 2f
    echo.
    echo Press any key to exit.
    pause >nul
    )