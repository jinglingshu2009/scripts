@echo off
setlocal  enabledelayedexpansion
cls
title Get service_name service_state service_stateID.
call:public MySQL
echo %get_name% %get_state%  %get_stateID%

:public
	 rem Get service_name service_state service_stateID. 
	 net start >.system_server.info
	 for /f "tokens=1,2 delims= " %%i in (.system_server.info) do ( 
		if "%%i"=="%1" set check_server=install
		)	
		del .system_server.info >>nul
	 if not "%check_server%"=="install"  ( 
			echo "%1 service is not installed!!!"
		) else (
			rem get server_state server_stateID
			sc query  %1 >.Server_statu.info
			for /f "tokens=1,2,3,4 delims= " %%i in (.Server_statu.info) do ( 
				if "%%i"=="SERVICE_NAME:"  set get_name=%%j
				if "%%i"=="STATE"   set get_stateID=%%k
				if "%%i"=="STATE"   set get_state=%%l
				)
			REM echo "%apache_name%==%apache_state%==%apache_stateID%"
		)
		del .Server_statu.info
		GOTO :EOF
