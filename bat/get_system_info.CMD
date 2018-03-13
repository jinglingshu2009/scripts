@echo off
setlocal  enabledelayedexpansion
cls
title Get systeminfo(操作系统版本  cpu 内存 硬盘 显卡 网卡_lan_wifi_ip_mac).

call:get_systeminfo 
echo  os_mem=%os_mem%MB os_name=%os_name%
pause

:get_systeminfo
	::systeminfo >c:/.systeminfo
	for /f "tokens=1,2,3 delims= " %%i in (c:/.systeminfo) do ( 
				if "%%i"=="物理内存总量:"  set os_mem=%%j
				)
	for /f "tokens=1,2,3 delims= " %%i in (c:/.systeminfo) do ( 
				if "%%i"=="*名称:"  set os_name=%%j
				echo %%j
				paush
				)
:get_system_mem
:get_system_cpu
:get_system_disk
:get_system_vid
:get_system_nic