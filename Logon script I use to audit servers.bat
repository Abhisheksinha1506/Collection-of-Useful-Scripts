set outputfile=\\servername\audit\%computername%.txt

date /t > %outputfile%
echo %computername% >> %outputfile%
systeminfo >> %outputfile%
net localgroup administrators >> %outputfile%
net user >> %outputfile%
net share >> %outputfile%