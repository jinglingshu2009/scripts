@ECHO OFF
setlocal enabledelayedexpansion
set dir_number=15
set path=L:\xxx
for /l %%x in (1,1,%dir_number%) do ( 
	set /a number=0

	md %path%\%%x	
	for /l %%N in (1,1,100) do ( 
		set /a _number=1
		for /l %%M in (1,1,1000) do (
			set /a id=!number!*1000+!_number!
			echo !id!=%path%\%%x\%%x_!id!.txt
			C:\Windows\System32\fsutil file createnew %path%\%%x\%%x-!id!.txt  1023  2>&1 >nul
			set /a _number+=1
		)
		C:\Windows\System32\ping -n 1 127.0.0.1 2>&1 >nul
		set /a number+=1
	)
)
