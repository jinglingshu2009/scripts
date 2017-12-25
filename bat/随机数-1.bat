@echo off  
setlocal EnableDelayedExpansion
chcp %UTF-8%
set min=1
set max=2
set type=.sh,.xml,.js,.rar,.tgz,.doc,.xls,.ppt,.exe,.iso,.gif,.bat,.jpg,.vmx,.mp4
set time_h=450
set file_number=1
path=S:\send\
set /a mod =!max!-!min!+1
REM set /a  b=%random:~0,2%
REM set /a  b=%random%%%100+1
for /L %%G in (1,1,%time_h%) do (
      MD %path%%%G
for /L %%n in (1,1,3600) do (
	for /L %%i in (1,1,%file_number%) do (
		set /a r=!random!%%!mod!+!min!
		set /a r=!r!*1024
		for %%I in (%type%) do (
			c:\windows\system32\fsutil file createnew %path%%%G\%%G_%%n_%%i%%I !r!	
		)
C:\WINDOWS\system32\ping 127.0.0.1 -n 1>nul
	)
    )
 )
 
