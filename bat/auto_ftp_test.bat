@echo on
title auto_ftp by likun for V1.0.0.3 2017-06-12
setlocal enabledelayedexpansion
set ftp_ip=192.168.99.109
set ftp_user=aaa
set ftp_pswd=123qwe
set run_number=5000000
set ftp_dir=D:\ftp\test1

set autu_ftp=%ftp_dir%\ftp_%run_number%.cfg
set auto_ftp_log=%ftp_dir%\ftp_%run_number%.log
set up_dir=%ftp_dir%\ftp_up
set down_dir=%ftp_dir%\ftp_down

if not exist %up_dir% 	md  %up_dir% 
rem �ж��ļ����Ƿ���ڣ��������򴴽�
if not exist %down_dir% md  %down_dir% 
echo open %ftp_ip% >"%autu_ftp%"
echo %ftp_user%>>"%autu_ftp%"
echo %ftp_pswd%>>"%autu_ftp%"
echo Prompt >>"%autu_ftp%"  
echo bin >>"%autu_ftp%"
echo mput %up_dir%\%run_number%_* >>"%autu_ftp%" 
echo lcd %down_dir%>>"%autu_ftp%"
echo mget %run_number%_* >>"%autu_ftp%"
echo mdel %run_number%_* >>"%autu_ftp%"
echo bye >>"%autu_ftp%"
rem attrib h file  ��h�����ļ�  -hȡ������
attrib h %autu_ftp%  

for /l %%x in (1,1,%run_number%) do ( 
rem ��ȡ���ֵ
 set  /a file_size=!random!000 
rem ��������ļ�
 fsutil file createnew %up_dir%\%run_number%_%%x  !file_size!  >nul 
rem ִ��FTP�Զ�����ű�autu_ftp.cfg
ftp -s:"%autu_ftp%"  >nul
rem ��ȡFTP���ϴ��ļ�MD5ֵ
!cd!\md5 -n %up_dir%\%run_number%_%%x  >.md5
set /P md5_up=<.md5
rem ��ȡFTP�������ļ�MD5ֵ
!cd!\md5 -n %down_dir%\%run_number%_%%x  >.md5
set /P md5_down=<.md5
 if  "!md5_up!"=="!md5_down!"  (
		rem  �ж�MD5����ȣ����Բ���ӡ��
		echo ID=%%x--Ok--%up_dir%\%run_number%_%%x--!file_size!--!md5_down!
		echo ID=%%x--Ok--%up_dir%\%run_number%_%%x--!file_size!--!md5_down! >>%auto_ftp_log%
		del %up_dir%\%run_number%_%%x
		del %down_dir%\%run_number%_%%x  
	 ) else (
		rem  �ж�MD5�����ȣ�ɾ������¼��־
		echo ID=%%x--Error--%up_dir%\%run_number%_%%x--!file_size!--!md5_up!--!md5_down!
		echo ID=%%x--Error--%up_dir%\%run_number%_%%x--!file_size!--!md5_up!--!md5_down! >>%auto_ftp_log%
		del %up_dir%\%run_number%_%%x
		del %down_dir%\%run_number%_%%x  )
del .md5
)
