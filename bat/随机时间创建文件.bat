@ECHO OFF
setlocal enabledelayedexpansion
set min=150
set max=200
set /a mod=%max%-%min%+1
set end=500000
set path=C:\xx
set type=txt
set file_size=1024
set id=1

:start
 if %id% == %end% goto quit
 set /a _sleep=!random!%%!mod!+!min!
C:\Windows\System32\fsutil file createnew %path%\%id%.%type%  %file_size%   2>&1 >nul
 echo sleep=%_sleep%=%path%\%id%.%type%
C:\Windows\System32\ping -n %_sleep% 127.0.0.1 2>&1 >nul
 set  /a id+=1	
 ::pause
 goto start
 goto :EOF
 
 
:quit
	exit
	goto :EOF