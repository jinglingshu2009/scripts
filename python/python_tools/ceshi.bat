@echo off
title File sync check by V1.0.1.2 for 2017-06-12
setlocal EnableDelayedExpansion
rem ###########################################################
set touch_number=100000
set	d_dir_a=C:\test
rem \Destination directory AA
set	d_dir_b=C:\ftp
rem Destination directory BB
set	/a file_size=1		
rem MB
set	file_type=rar
set drive_type=C:
rem set drive_type=%~d0    
set	_disk_alert=15
rem Hard disk monitoring alert valuer.
set	_sloop=300
rem Check the alert value for a cycle of sleep.
rem ###########################################################
set synctype_del=yes  
rem yes:synctype=del NO:no synctype del
rem ###########################################################
::call GetTime.CMD chu_lk.cmd md5.exe
rem ###########################################################
set A=Loop create file
set B=Loop check file
set /a file_size=!file_size!*1024000
set  wc=0
set log=log
set dellog=dele_log
goto LOCAL 

:LOCAL
	set /p input=Please input type A or B:
	if "%input%"=="A" goto A
	if "%input%"=="B" goto B
	if not "%input%"=="A" (if not %input%=="B" goto C )
:A
	::echo AAAAAA%A%
	set /a wc+=1
		::kill old md5.exe fsutil
		::taskkill /f /im md5.exe 2>&1 >nul
		::taskkill /f /im fsutil	2>&1 >nul
		::touch file
		c:\windows\system32\fsutil file createnew %wc%.%file_type% %file_size%  2>&1 >nul
		::get file md5
		echo %wc% >>%wc%.%file_type%
		!cd!\md5 -n %wc%.%file_type%>md5_src
		set /P md5_src=<md5_src
		::move file_src  file_dst
		move %wc%.%file_type% %d_dir_a%\%wc%-%md5_src%.%file_type%	2>&1 >nul
		call !cd!\GetTime.CMD HH MM SS TT
		echo %HH%:%MM%:%SS%	%wc%	%wc%-%md5_src%.%file_type%	%file_size%	Create	ok
		echo %HH%:%MM%:%SS%	%wc%	%wc%-%md5_src%.%file_type%	%file_size%	Create	ok >>%log%
		REM check disk free size
		rem set drive_type=G:
		wmic logicaldisk Where DriveType="3" get caption,FreeSpace,size |find "%drive_type%" >md5_src 
		for /f "tokens=2 delims= " %%f in (md5_src) do  (
			set   "disk_free=%%f"  ) 
		for /f "tokens=3 delims= " %%s in (md5_src) do  (
			set   "disk_size=%%s" ) 
		call !cd!\chu_lk.cmd %disk_free%  %disk_size% free  
			 rem echo %drive_type% %disk_free%  %disk_size%  %free%  %_disk_alert%
		if "%synctype_del%" == "yes" (
			echo %wc% please wait for the next inspection cycle %_sloop%s .....
			ping -n %_sloop% 127.0.0.1 2>&1 >nul
			) else ( 
				 if	%free% leq %_disk_alert% ( 
					echo %free% <= %_disk_alert% 
					rem check file || del_file
					dir %d_dir_a% /a-d /b /s |find /V /C "">md5_src
					set /P c=<md5_src >nul
					set /a del_file=!c!/2 
					dir %d_dir_a% /b/a-d/a-h/a-s/od/tc>md5_src
					set x=0
						for /f "delims=" %%L in (md5_src) do  (	
							set /a x+=1
							del %d_dir_a%\%%L & echo %HH%:%MM%:%SS%	%%L	Delete	ok
							echo %HH%:%MM%:%SS%	%%L	Delete	ok >>%dellog%
							::echo x=!x! del_file=!del_file!  
							if "!x!" == "!del_file!" goto A
						  )
					  ) else ( echo %free% > %_disk_alert% >nul )
			  )
		if %wc% == %touch_number% goto Q 
		::del md5_src
		del md5_src 2>&1 >nul
		GOTO A
:B
	::echo BBBBB%B%
    set /a wc+=1
	wmic logicaldisk Where DriveType="3" get caption,FreeSpace,size |find "%drive_type%" >md5_dst
	for /f "tokens=2 delims= " %%f in (md5_dst) do  (
			set   "disk_free=%%f"  ) 
	for /f "tokens=3 delims= " %%s in (md5_dst) do  (
			set   "disk_size=%%s" ) 
	call !cd!\chu_lk.cmd %disk_free%  %disk_size% free
	call !cd!\GetTime.CMD HH MM SS TT
		 ::echo %drive_type% %disk_free%  %disk_size%  %free%  %_disk_alert%
		if	%free% leq %_disk_alert% (
			echo "%free% <= %_disk_alert%"  >NUL 
			rem del function
			dir %d_dir_b% /a-d /b /s |find /V /C "">md5_dst
			set /P c=<md5_dst
			set /a del_file=!c!/2 
			dir %d_dir_b% /b/a-d/a-h/a-s/od/tc>md5_dst
			set x=0
			 for /f "delims=" %%L in (md5_dst) do  (	
				set /a x+=1
				::get src file md5
				set md5_src=%%L
				set md5_src=!md5_src:~-36,32!
				::get dst file md5
				!cd!\md5 -n !d_dir_b!\%%L>md5_dst
				set /P md5_dst=<md5_dst
				::echo !x!=!md5_src!=!md5_dst!
				if "!md5_src!" ==  "!md5_dst!" (
					del %d_dir_b%\%%L & echo %HH%:%MM%:%SS%	%%L	Delete	ok
					echo %HH%:%MM%:%SS%	%%L	Delete	ok >>%log%
					) else ( echo %HH%:%MM%:%SS%	%%L=!md5_src!=!md5_dst!	Delete	error
						 	 echo %HH%:%MM%:%SS%	%%L=!md5_src!=!md5_dst!	Delete	error >>%log% )
				if "!x!" == "!del_file!" goto B
				) 
			  ) else ( echo %free% > %_disk_alert% >nul )
		::del md5_dst
		dir %d_dir_b% /b/a-d/a-h/a-s/od/tc>.file.ini
		set /P file_number=<.file.ini
		del md5_dst .file.ini 2>&1 >nul
		echo %wc% please wait for the next inspection cycle(File:%file_number%)(Disk_free:%free%)(%_sloop%s).....
		ping -n %_sloop% 127.0.0.1 2>&1 >nul
		GOTO B
:C
	echo Please Choose input type A or B:
	echo		A	%A%
	echo		B	%B%
	goto local
	GOTO :EOF
:Q
	exit
	goto :EOF
		
		

