@echo off
color B0
echo.
echo                        ��ʱִ�г���:���������˰��Ƽ����޹�˾
echo -------------------------------------------------------------------------------
echo.
echo                              ��һ����Ҫ��ʱִ�е��ļ���
echo.
echo                              �ڶ�����Ҫ�Ƴ�ִ�е�ʱ��(����)
echo -------------------------------------------------------------------------------
set /p filename=������Ҫִ�е��ļ���:
echo.
set /p filetime=������Ҫ�Ƴ�ִ�е�ʱ��:
echo.
echo.
echo ʱ���Ѿ��������
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
echo                        ��ʱִ�г���:���������˰��Ƽ����޹�˾
echo ###############################################################################
echo.
echo                                 %i%������ʼ����
echo.
echo ############################################################################### 
cscript //nologo %temp%\\tmp$$$.vbs 
goto Timeout 
goto End 
:Next 
cls echo. 
call %filename%
exit