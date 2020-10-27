@echo off
setlocal
:MENU1
echo Select an option:
for /F "delims=" %%a in ('mshta.exe "%~F0"') do set "HTAreply=%%a"
echo End of HTA window, reply: "%HTAreply%"
IF %HTAreply%==1 GOTO :EST
IF %HTAreply%==2 GOTO :CST
IF %HTAreply%==3 GOTO :MST
IF %HTAreply%==4 GOTO :PST
 
:EST
tzutil /s "Eastern Standard Time"
GOTO :Done
:CST
tzutil /s "Central Standard Time"
GOTO :Done
:MST
tzutil /s "Mountain Standard Time"
GOTO :Done
:PST
tzutil /s "Pacific Standard Time"
GOTO :Done
 
 
-->
 
 
<HTML>
<HEAD>
<HTA:APPLICATION SCROLL="no" SYSMENU="no" >
 
<TITLE>Select Time Zone</TITLE>
<SCRIPT language="JavaScript">
window.resizeTo(200,160);
 
 
function closeHTA(reply){
   var fso = new ActiveXObject("Scripting.FileSystemObject");
   fso.GetStandardStream(1).WriteLine(reply);
   window.close();
}
 
</SCRIPT>
</HEAD>
<BODY>
   <button onclick="closeHTA(1);">EST</button>
   <button onclick="closeHTA(2);">CST</button>
   <button onclick="closeHTA(3);">MST</button>
   <button onclick="closeHTA(4);">PST</button>
</BODY>
</HTML>