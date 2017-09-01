@ECHO OFF
setlocal enabledelayedexpansion
set path_0=d:\autorun\
set /a run_time=4*24*60*60+0*60*60+0*60+60
set name=Standard.bat

echo @echo off   >%name%
echo setlocal enabledelayedexpansion   >>%name%
echo title %%7.bat   >>%name%
::echo ::%%1:启始值 %%2:path(路径）%%3:结束时间 %%4:类型（rar txt doc ...） %%5:X个/秒  %%6:x*1024（KB） %%7:1k 100k 200k  %%8 延迟X-1秒   >>%name%
echo set /a js=%%1   >>%name%
echo set /a time_d=%%Date:~8,2%%  >>%name%
echo set /a time_h=%%Time:~0,2%%  >>%name%
echo set /a time_m=%%Time:~3,1%%*10+%%Time:~4,1%%  >>%name%
echo set /a time_s=%%Time:~6,1%%*10+%%Time:~7,1%%  >>%name%
echo set /a ntp_old=%%time_d%%*24*60*60+%%time_h%%*60*60+%%time_m%%*60+%%time_s%%  >>%name%
::echo set /a ntp_old=%%Date:~8,1%%*10*60*60*60+%%Date:~9,1%%*60*60*60+%%Time:~0,1%%*10*60*60+%%Time:~1,1%%*60*60+%%Time:~3,1%%*10*60+%%Time:~4,1%%*60+%%Time:~6,1%%*10+%%Time:~7,1%%   >>%name%
echo set /a ntp_now=%%ntp_old%%+%%3   >>%name%
echo :m   >>%name%
echo set /a time_d=%%Date:~8,2%%  >>%name%
echo set /a time_h=%%Time:~0,2%%  >>%name%
echo set /a time_m=%%Time:~3,1%%*10+%%Time:~4,1%%  >>%name%
echo set /a time_s=%%Time:~6,1%%*10+%%Time:~7,1%%  >>%name%
::echo ::set time1=%%7_%%Date:~8,2%%%%Time:~0,2%%%%Time:~3,2%%%%Time:~6,2%%%%Time:~9,2%%   >>%name%
echo set time1=%%7_example%%js%%>>%name%
echo set path_1=%%2%%time_d%%%%time_h%%\%%7\>>%name%
::echo set path_1=%%path_1: =%%>>%name%
::echo set /a ntp_old=%%time_d%%*60*60*60+%%time_h%%*60*60+%%time_m%%*60+%%time_s%%    >>%name%
echo set /a ntp_old=%%Date:~8,2%%*24*60*60+%%time_h%%*60*60+%%Time_m%%*60+%%Time_s%%      >>%name%
::echo echo %%1 %%2 %%3 %%4 %%5 %%6 %%7 %%8  %%ntp_old%% %%ntp_now%% %%time1%% %%path_1%%  >>%name%
echo if "%%ntp_old%%" leq "%%ntp_now%%" (   >>%name%  
echo 	       echo Program is running normally.  +OK   ^>nul >>%name%
echo     ) else (   >>%name%
echo           echo End of the program running time, exit. +ok ^>^>log.txt ^&^& ^exit >>%name% 
echo      )   >>%name%
::echo ::	^pause ^&^& ^exit    >>%name%
echo  if exist %%path_1%% (    >>%name%
echo 	      echo %%time1%% NO 1 ^>nul    >>%name%
echo 		 ) else (    >>%name%
echo 		  md %%path_1%% ^&^& echo now %%time1%% md %%path_1%% +ok ^>nul   >>%name%
echo 		 )    >>%name% 	 
echo  if  "%%time_h%%" EQU "00" (    >>%name%
echo         if exist %%path_1%% (    >>%name%
echo 	         echo %%time1%% NO 2 ^>nul   >>%name%
echo 		   ) else (    >>%name%
echo 		   md %%path_1%% ^&^& echo now %%time_h%% md %%path_1%% +ok ^>nul   >>%name%
echo 		   for /l %%%%i in (1,1,%%5) do (   >>%name%
echo 		       fsutil file createnew %%path_1%%%%time1%%_%%%%i.%%4  %%6  ^>nul  >>%name%
::echo               echo %%1 %%2 %%3 %%4 %%5 %%6 %%7 %%8 ^>^>log.txt >>%name%
echo 		     )	 >>%name%
echo 		   )     >>%name%
echo 	 ) else  (   >>%name%
echo 	   for /l %%%%i in (1,1,%%5) do (   >>%name%
echo 	   fsutil file createnew %%path_1%%%%time1%%_%%%%i.%%4  %%6  ^>nul  >>%name%
::echo 	   echo fsutil file createnew %%path_1%%%%time1%%_%%%%i.%%4   >>%name%
::echo       echo %%time1%%  ^>^>log.txt >>%name%
echo          )   >>%name%
echo 	 echo %%time1%% NO 3 ^>nul   >>%name%
echo 	 )   >>%name%
echo set /a number=%%js%%*%%5   >>%name%
echo echo ########################%%7_%%js%%########%%7_sun:%%number%%#################  ^>^>%%2log.txt >>%name%
echo set /a js=%%js%%+1   >>%name%
echo ping 127.1 -n %%8 ^>nul   >>%name%
echo goto m   >>%name%

REM echo  %name%  %path_0%  %run_time%
REM pause && exit
start %name% 1 %path_0% %run_time% txt 10 1024     1kB   2
start %name% 1 %path_0% %run_time% doc 10 10240    10kB  2
start %name% 1 %path_0% %run_time% bin 10 102400   100kB 2
start %name% 1 %path_0% %run_time% rar 5  1024000  1MB   20
start %name% 1 %path_0% %run_time% exe 5  10240000 10MB  60
::%1:启始值1  %2:E:\autorun\(路径） %3:结束时间(s) %4:类型(rar/txt/doc）%5:X个/秒 %6:x*1024(KB) %7:目录(1k/100k/200k/1M) %8 延迟X-1秒
