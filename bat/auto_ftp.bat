@echo off
title auto_ftp by likun for 2017-04-11
setlocal enabledelayedexpansion
set ftp_ip=192.168.7.16
set ftp_user=test1
set ftp_pswd=123qwe
set ftp_dir=F:\
set run_number=10

set autu_ftp=autu_ftp.cfg
set up_dir=%ftp_dir%\up
set down_dir=%ftp_dir%\down


md  %ftp_dir%
md  %up_dir%
md  %down_dir%
echo open %ftp_ip% >"%autu_ftp%"
echo %ftp_user%>>"%autu_ftp%"
echo %ftp_pswd%>>"%autu_ftp%"
echo Prompt >>"%autu_ftp%"  
echo bin >>"%autu_ftp%"
echo mput %up_dir%\1_* >>"%autu_ftp%" 
echo lcd %down_dir%>>"%autu_ftp%"
echo mget 1_* >>"%autu_ftp%"
echo mdel 1_* >>"%autu_ftp%"
echo bye >>"%autu_ftp%"

for /l %%x in (1,1,%run_number%) do ( 
rem ��ȡ���ֵ
 set  /a random_number=!random!  
rem ��������ļ�
 fsutil file createnew %up_dir%\1_%%x  !random_number!0000  >>null 
rem ִ��FTP�Զ�����ű�autu_ftp.cfg
  ftp -s:"%autu_ftp%"  > nul
rem ��ȡFTP���ϴ��ļ�MD5ֵ
   !cd!\md5 -n %up_dir%\1_%%x  >.md5_up
 for /f "delims=" %%m in (.md5_up) do (
   set  md5_up=%%m ) 
rem ��ȡFTP�������ļ�MD5ֵ
   !cd!\md5 -n %down_dir%\1_%%x  >.md5_down
 for /f "delims=" %%n in (.md5_down) do (
   set  md5_down=%%n )
rem  �ж�MD5����ȣ����Դ�ӡ��
if  "!md5_up!"=="!md5_down!"  (
     echo ID=%%x----%up_dir%\1_%%x----!random_number!0000----!md5_down! 
     del %up_dir%\1_%%x
     del %down_dir%\1_%%x  )
rem  �ж�MD5�����ȣ�ɾ����־
if   "!md5_up!" neq "!md5_down!" (
	echo ID2=%%x----%up_dir%\1_%%x----!random_number!0000----!md5_up!----!md5_down! >>ftp.log )
rem echo ID=%%x	-	--!random_number!0000	-	!md5_up!	-	!md5_down!
)
pause
