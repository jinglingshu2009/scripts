@echo off  
wmic logicaldisk Where DriveType="3" get caption,FreeSpace,size |find "C:" >disk.info
for /f "tokens=2 delims= " %%i in (disk.info) do  (
		set   /a "disk_free=%%i"  
		REM set "n=" 
		REM for %%a in (16 8 4 2 1) do (
    REM if not !disk_free:~%%a! == "" set /a n+=%%a 
	REM set "diskfree=!disk_free:~%%a!"
			REM )
		)
for /f "tokens=3 delims= " %%s in (disk.info) do  (
		set  /a disk_size=%%s )
		echo %diskfree%/%xxx%  %disk_size%
pause
