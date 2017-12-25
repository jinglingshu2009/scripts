@ECHO OFF
title Auto iperf send/recv by V1.0.0.0 for 2017-06-21
setlocal enabledelayedexpansion
rem ###########################################################
set send_ip=
set send_port=
set send_time=
set send_thread=
set loop_delay=
set recv_ip=
set recv_port=
set debuy=on
rem ###########################################################
goto local

:LOCAL
	set /p input=Please input type iperf send or recv:
	if "%input%"=="send" goto iperf_send
	if "%input%"=="recv" goto iperf_recv
	if not "%input%"=="iperf_send" (if not %input%=="iperf_recv" goto local )

:iperf_send
	echo "iperf_send"
	pause
	exit
	GOTO :EOF

:iperf_recv
	echo "iperf_recv"
	pause
	exit
	GOTO :EOF