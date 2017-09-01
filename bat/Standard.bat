@echo off   
setlocal enabledelayedexpansion   
title %7.bat   
set /a js=%1   
set /a time_d=%Date:~8,2%  
set /a time_h=%Time:~0,2%  
set /a time_m=%Time:~3,1%*10+%Time:~4,1%  
set /a time_s=%Time:~6,1%*10+%Time:~7,1%  
set /a ntp_old=%time_d%*24*60*60+%time_h%*60*60+%time_m%*60+%time_s%  
set /a ntp_now=%ntp_old%+%3   
:m   
set /a time_d=%Date:~8,2%  
set /a time_h=%Time:~0,2%  
set /a time_m=%Time:~3,1%*10+%Time:~4,1%  
set /a time_s=%Time:~6,1%*10+%Time:~7,1%  
set time1=%7_example%js%
set path_1=%2%time_d%%time_h%\%7\
set /a ntp_old=%Date:~8,2%*24*60*60+%time_h%*60*60+%Time_m%*60+%Time_s%      
if "%ntp_old%" leq "%ntp_now%" (     
	       echo Program is running normally.  +OK   >nul 
    ) else (   
          echo End of the program running time, exit. +ok >>log.txt && exit  
     )   
 if exist %path_1% (    
	      echo %time1% NO 1 >nul    
		 ) else (    
		  md %path_1% && echo now %time1% md %path_1% +ok >nul   
		 )     	 
 if  "%time_h%" EQU "00" (    
        if exist %path_1% (    
	         echo %time1% NO 2 >nul   
		   ) else (    
		   md %path_1% && echo now %time_h% md %path_1% +ok >nul   
		   for /l %%i in (1,1,%5) do (   
		       fsutil file createnew %path_1%%time1%_%%i.%4  %6  >nul  
		     )	 
		   )     
	 ) else  (   
	   for /l %%i in (1,1,%5) do (   
	   fsutil file createnew %path_1%%time1%_%%i.%4  %6  >nul  
         )   
	 echo %time1% NO 3 >nul   
	 )   
set /a number=%js%*%5   
echo ########################%7_%js%########%7_sun:%number%#################  >>%2log.txt 
set /a js=%js%+1   
ping 127.1 -n %8 >nul   
goto m   
