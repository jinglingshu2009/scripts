@echo off
setlocal  enabledelayedexpansion
cls
title Start/Stop/Restart Apache and MySQL service.

set server_apache=Apache2a
set server_mysql=MySQLa

goto LOCAL

:LOCAL
cls
color 0B
	echo ==========================================================================
	echo Please choose the commands you need:
	echo  	1	start	start %server_apache% and %server_mysql% service.
	echo  	2	stop	stop %server_apache% and %server_mysql% service.
	echo  	3	restart	restart %server_apache% and %server_mysql% service.
	echo ==========================================================================
	set input=	
	set /p input=Please choose :
	if "%input%"=="1" 	goto 1
	if "%input%"=="2"  	goto 2
	if "%input%"=="3" 	goto 3
	if not "%input%"=="1" (if not %input%=="2" (if not %input%=="3" goto local)) 
	GOTO :EOF

:1
	 ::echo 1  start	 start Apache and MySQL service.
	 call:public
	 if "%mysql_stateID%"=="4" ( echo "The %server_mysql% service is running!!!" 
		) else (
		if "%mysql_stateID%"=="1" (net start %server_mysql%) 
		)
	 if "%apache_stateID%"=="4" ( echo "The %server_apache% service is running!!!"
		) else ( 
		if "%apache_stateID%"=="1" (net start %server_apache% )
		)
	 GOTO :EOF
	 
:2
	 ::echo 2  stop	 stop Apache and MySQL service.
	 call:public
	 if "%apache_stateID%"=="1" ( 
		echo "The %server_apache% service is not running!!!"
	 )	else (
		if "%apache_stateID%"=="4" ( net stop %server_apache% )
		)
	 if "%mysql_stateID%"=="1" ( 
		echo "The %server_mysql% service is not running!!!"
	 )	else (
		 if "%mysql_stateID%"=="4" ( net stop %server_mysql% )
		)
	 GOTO :EOF
	 
:3
	 ::echo 3  restart	restart Apache and MySQL service.
	 call:2
	 call:1
	 GOTO :EOF

:public
	 rem check service
	 net start >.system_server.info
	 for /f "tokens=1,2 delims= " %%i in (.system_server.info) do ( 
		if "%%i"=="%server_apache%" set check_apache=install
		if "%%i"=="%server_mysql%"  set check_mysql=install
		)	
		del .system_server.info >>nul
	 if not "%check_apache%"=="install"  ( 
			echo "%server_apache% service is not installed!!!"
		) else (
			rem get server_state server_stateID
			sc query  %server_apache% >.Server_statu.info
			for /f "tokens=1,2,3,4 delims= " %%i in (.Server_statu.info) do ( 
				if "%%i"=="SERVICE_NAME:"  set apache_name=%%j
				if "%%i"=="STATE"   set apache_stateID=%%k
				if "%%i"=="STATE"   set apache_state=%%l
				)
			REM echo "%apache_name%==%apache_state%==%apache_stateID%"
		)
	 if not "%check_mysql%"=="install"  (
			echo "%server_mysql% service is not installed!!!"
		) else (
			rem get server_state server_stateID
			sc query  %server_mysql% >.Server_statu.info
			for /f "tokens=1,2,3,4 delims= " %%i in (.Server_statu.info) do ( 
				if "%%i"=="SERVICE_NAME:"  set mysql_name=%%j
				if "%%i"=="STATE"   set mysql_stateID=%%k
				if "%%i"=="STATE"   set mysql_state=%%l
				)
			del .Server_statu.info >>nul
			rem echo "%mysql_name%==%mysql_state%==%mysql_stateID%"
		)	
	 GOTO :EOF	 
