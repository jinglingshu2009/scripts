@echo off
color B0
echo.
echo                        计时执行程序:北京赛博兴安科技有限公司
echo -------------------------------------------------------------------------------
echo.
echo                              第一输入要定时执行的文件名
echo.
echo                              第二输入要推迟执行的时间(分钟)
echo -------------------------------------------------------------------------------
set /p filename=请输入要执行的文件名:
echo.
set /p filetime=请输入要推迟执行的时间:
echo.
echo.
echo 时间已经设置完毕
echo.
pause
color B0
echo WScript.Sleep 1000 > %temp%\\tmp$$$.vbs 
set /a i = %filetime% * 60
:Timeout
if %i% == 0 goto Next 
setlocal
set /a i = %i% - 1 
cls 
echo.
echo.
echo                        计时执行程序:北京赛博兴安科技有限公司
echo ###############################################################################
echo.
echo                                 %i%秒后程序开始运行
echo.
echo ############################################################################### 
cscript //nologo %temp%\\tmp$$$.vbs 
goto Timeout 
goto End 
:Next 
cls echo. 
call %filename%
exit