@echo off  
goto loop_check

:loop_check
wmic logicaldisk Where DriveType="3" get caption,FreeSpace,size |find "G:" >disk.info 
for /f "tokens=2 delims= " %%z in (disk.info) do  (
		set   "disk_free=%%z"  )
for /f "tokens=3 delims= " %%s in (disk.info) do  (
		set   disk_size=%%s )
	call chu_lk.cmd %disk_free%  %disk_size%  free
		echo %disk_free%  %disk_size%  %free% 
	 ::call D:\script\bat\Functions\Sleep.CMD 1
	REM call D:\script\bat\Functions\GetNA.CMD NA
		REM echo GetNA:%NA%
	REM call D:\script\bat\Functions\GetMAC.CMD MAC  
		REM echo GetMAC:%MAC%
	REM call D:\script\bat\Functions\GetOS.CMD OS	
		REM echo GetOS:%OS%
	REM call D:\script\bat\Functions\GetTime.CMD HH MM SS TT	
		REM echo GetTime:%HH%:%MM%:%SS%:%TT%
	::call D:\script\bat\Functions\chu_lk.cmd 9150197760  21476171776  val
	::	echo chu:%val%
	REM call D:\script\bat\test.bat %disk_free%  %disk_size%
	REM echo test:%chu%
	goto loop_check
