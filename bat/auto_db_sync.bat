@echo off
title oracle db_sync  by V1.0.1.1 for 2017-06-29
setlocal EnableDelayedExpansion
::#############################################################################################
set table=send1	
set db_user=system
set db_pawd=cyberadmin
set run_number=90000000
set loop_commit=2500
set _sleep=10
::#############################################################################################
set id=1
set NAME=���������˰��Ƽ����޹�˾.www.cyberxingan.com.�й�.����.����
set AGE=1234567890
set address1=��ַ1:���������˰��Ƽ����޹�˾.www.cyberxingan.com.�й�.����.����
set address2=��ַ2:���������˰��Ƽ����޹�˾.www.cyberxingan.com.�й�.����.����
set address3=��ַ3:���������˰��Ƽ����޹�˾.www.cyberxingan.com.�й�.����.����
set address4=��ַ4:���������˰��Ƽ����޹�˾.www.cyberxingan.com.�й�.����.����
set address5=��ַ5:���������˰��Ƽ����޹�˾.www.cyberxingan.com.�й�.����.����
set address6=��ַ6:���������˰��Ƽ����޹�˾.www.cyberxingan.com.�й�.����.����
set address7=��ַ7:���������˰��Ƽ����޹�˾.www.cyberxingan.com.�й�.����.����
set address8=��ַ8:���������˰��Ƽ����޹�˾.www.cyberxingan.com.�й�.����.����
set address9=��ַ9:���������˰��Ƽ����޹�˾.www.cyberxingan.com.�й�.����.����
set address10=��ַ10:���������˰��Ƽ����޹�˾.www.cyberxingan.com.�й�.����.����
::#############################################################################################
set commit=%loop_commit%
goto start

:start
	echo %id%,%NAME%%id%,%AGE%,%address1%,%address2%,%address3%,%address4%,%address5%,%address6%,%address7%,%address8%,%address9%,%address10%>>%cd%/data.txt
	echo This is the production of Article %id% data.
	if %commit% == %id% ( 
		echo Please wait for data insertion ... ... ...
		if not exist %cd%/read.ctl  ( goto ctl )
		rem sqlldr %db_user%/%db_pawd% control=%cd%read.ctl  >>nul
		ping -n %_sleep% 127.0.0.1 >nul
		del %cd%/data.txt
		set /a commit+=%loop_commit%
		echo %commit%
		)
	if %id% == %run_number% goto quit
	set  /a id+=1	
	goto start
	goto :EOF

:quit
	exit
	goto :EOF

:ctl
	echo load  >%cd%/read.ctl  
	echo infile "%cd%/data.txt">>%cd%/read.ctl       
	echo append into table %table%>>%cd%/read.ctl  
	echo fields terminated by ",">>%cd%/read.ctl     
	echo trailing nullcols>>%cd%/read.ctl  
	echo (>>%cd%/read.ctl
	echo ID  ,>>%cd%/read.ctl                  
	echo NAME  ,>>%cd%/read.ctl
	echo AGE  ,>>%cd%/read.ctl
	echo ADDRESS1  ,>>%cd%/read.ctl
	echo ADDRESS2  ,>>%cd%/read.ctl
	echo ADDRESS3  ,>>%cd%/read.ctl
	echo ADDRESS4  ,>>%cd%/read.ctl
	echo ADDRESS5  ,>>%cd%/read.ctl
	echo ADDRESS6  ,>>%cd%/read.ctl
	echo ADDRESS7  ,>>%cd%/read.ctl
	echo ADDRESS8  ,>>%cd%/read.ctl
	echo ADDRESS9  ,>>%cd%/read.ctl
	echo ADDRESS10	>>%cd%/read.ctl
	echo )>>%cd%/read.ctl
	goto start
	goto :EOF