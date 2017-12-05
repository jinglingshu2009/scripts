#!/bin/bash
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

ftp_delete()
{
ftp -i -n $1 2>$error_log <<_EOF_
    user $2 $3
    lcd $4
    delete $5
    bye
_EOF_
# ftp_delete  $1:ftp_ip;  $2:ftp_user; $3:ftp_passwd; $4:load_path;  $5:delete_file_name;  
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
#========Glod========
log=/tmp/ftp_log
error_log=/tmp/ftp_error
#========FTP_config========
#eg:send(ftp client)----->sproxy--cproxy---->recv(ftp server)
mode=ftp_single_loop
ftp_address="172.168.100.2"
ftp_user="test1@testa test2@testa"   ftp_passwd=123qwe
local_path=/tmp/.ftp/
get_path=/tmp/.ftp/get
ftp_loop=10000000
ftp_file_len=5   #1=0-10k 2=0-100k 3=0-1000K
ftp_path=       #vsftpd server path
##############################################################
case   $1  in
	ftp_single_loop) #eg:send(ftp client)----->sproxy--cproxy---->recv(ftp server) 
	if [ ! -s $local_path  ];then
		#echo "Funtion touch_file $touch_file_load error !!!"
		mkdir -p $local_path $get_path
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
			      ftp_delete $ftp_address $user_ftp $ftp_passwd $local_path $i    >>/dev/null   #删除FTP服务器上已经存在的上传文件
		      done 
			   log_count=`cat $error_log |wc -l`
			   if [ "$log_count" != "0" ];then
		        	echo "FTP $i-$ftp_loop times the Upload /Download error !!!" >>$log
			      else
		        	echo "FTP $i-$ftp_loop times the Upload /Download successful !!!" >>$log
			     fi 
			   rm -rf $local_path/$i  $get_path/$i  #rm -rf local ftp upload file 
		  done
		;;
	*)
	echo "Please choice:"
	echo "1  $0   ftp_single_loop"
    ;;	
 esac  
