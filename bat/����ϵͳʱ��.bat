@echo off  
setlocal EnableDelayedExpansion
chcp %UTF-8%
set min=0
set max=55
set type=.xml,.rar,.doc,.xls,.ppt,.bat,.txt
set time_h=0
set file_number=1
set mounth=08
path=D:\test
set /a mod =!max!-!min!+1
REM set /a  b=%random:~0,2%
rem set /a  b=%random%%%100+1

for /L %%G in (0,1,%time_h%) do (
      set xx=%%G
	  ::MD %path%%%G
	  set dd=%DATE:~8,2%
	  if "!dd:~0,1!" == "0" (
	  set /a dd=!dd:~1!
	  echo !dd!
	  )
	  set /a dd=!dd!+!xx!
	  echo 2017-!mounth!-!dd!
	   pause
	  @date 2017-!mounth!-!dd!
for /L %%n in (9,1,22) do (
		set /a r=!random!%%!mod!+!min!
		set /a mm=!r!
		set /a hh=%%n
		if "!hh!" ==  "12" ( 
		set /a hh=11
		set /a mm=57		
		)
		if "!hh!" ==  "13" ( 
		set /a hh=13
		set /a mm=56		
		)
		::echo !r! 
		echo !hh!:!mm!
		
		@time !hh!:!mm!
		for %%I in (%type%) do (
			c:\windows\system32\fsutil file createnew %path%\cyber!mm!%%I 123
			echo "ceshisixiang%%n" >>%path%\cyber!mm!%%I
			echo "ZLce%%n" >>%path%\cyber!mm!%%I
			echo "ceshichanp%%n" >>%path%\cyber!mm!%%I
			echo "xxxfasfdsafasdfasdfsdafsdfsdfuioweiosxinsadfisafsxinid%%n" >>%path%\cyber!mm!%%I
			if "%%I" == ".txt" (
			 set /p a=<%path%\cyber!mm!%%I 
			 echo !a!
			 pause
			 )
			del  %path%\cyber!mm!%%I
		)
C:\WINDOWS\system32\ping 127.0.0.1 -n 1  2>&1 >nul

    )
 C:\WINDOWS\system32\ping 127.0.0.1  -n 2 2>&1 >nul
 )
 shutdown -s -t 0 
 
