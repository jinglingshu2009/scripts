#!/bin/bash
#auto_ftp.sh for likun by 20171018
#set -x 
##############################################################
ftp_up_down ()
{
	if [ "$#" != "6" ]; then
		echo "Funtion ftp_up_down error !!!"
		exit 
	elif [ ! -s $6 ];then
		#echo "Funtion ftp_up_down $6 error !!!"
		mkdir $6
	elif [ ! -s $4 ];then
		#echo "Funtion ftp_up_down $4 error !!!"
		mkdir $4
	  fi	
ftp -i -n $1  2>$error_log <<_EOF_
    user  $2  $3
	lcd $4
    put $5
	lcd $6
    get $5
    bye
_EOF_
# ftp_up_down  $1:ftp_ip;  $2:ftp_user; $3:ftp_passwd; $4:local_path;  $5:up/down_file_name; $6:get_path 
}

touch_file ()
{
	touch_file_load=$1
	if [ "$#" != "3" ];then
		echo "Funtion touch_file error !!! $#"
		exit 
	elif [ ! -s $touch_file_load  ];then
		#echo "Funtion touch_file $touch_file_load error !!!"
		mkdir $touch_file_load   
	  fi	
	  dd if=/dev/zero of=$touch_file_load/$2 bs=1024c  count=`date +%N |cut -b 1-$3`  2>&1   >>/dev/null  #touch file
	 #touch_file $1:touch_file_load  $2:touch_file_name $3:touch_file_len $3:1=0-10k/2=0-100k/3=0-1000K; 
  }
##############################################################
#eg:send(ftp client)----->sproxy--cproxy---->recv(ftp server)
log=/root/log
error_log=/root/.err_log
mode=ftp_single_loop
ftp_address="10.10.10.2"
ftp_user="test@test.com test1 test2"   ftp_passwd=123qwe
local_path=/tmp/.ftp
get_path=/tmp/.ftp/get/
ftp_loop=100000
ftp_file_len=2   #1=0-10k 2=0-100k 3=0-1000K
ftp_path=       #vsftpd server path
##############################################################
case   $1  in
	ftp_single_loop) #eg:send(ftp client)----->sproxy--cproxy---->recv(ftp server) 
	if [ ! -s $local_path ];then
		mkdir -p $local_path   $get_path
	 fi
		cd $local_path
		for (( i=0;i<=$ftp_loop;i++))
		  do
		      #touch  ftp upload file 
			  touch_file $local_path $i   $ftp_file_len  2>&1   >>/dev/null
			  #echo "this is $i file " >> $i.txt
			for user_ftp in $ftp_user
			 do
				 #ftp_up_down $ftp_address $user_ftp $ftp_passwd $local_path $i $get_path  2>&1   >>/dev/null||rm -rf $local_path/$i  &  
				 sleep 0.2
				 ftp_up_down $ftp_address $user_ftp $ftp_passwd $local_path $i $get_path   >>/dev/null  
				 #put/get ftp file
		      done 
			   log_count=`cat $error_log |wc -l`
			   if [ "$log_count" != "0" ];then
		        	echo "FTP $i-$ftp_loop times the Upload /Download error !!!" >>$log
			   else
		        	echo "FTP $i-$ftp_loop times the Upload /Download successful !!!" >>$log
			   	fi 
			   rm -rf $local_path/$i  #rm -rf local ftp upload file 
		  done   
		  ;; 
     *)
	echo "Please choice:"
	echo "1  $0   ftp_single_loop"
    ;;	
 esac  
