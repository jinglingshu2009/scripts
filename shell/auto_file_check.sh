#/bin/bash
#File sync check by V1.0.0.1 for 2017-11-28
##############################################################
check_file () {
	if [ ! $1 ];then
		echo "check_file  1=dst_dir/src_dir 2=AA/BB"
		exit
	fi
	rm -rf /tmp/.tmp_file_list /tmp/.file_name_list
	find $1 -type f -amin +2 |grep -i "$file_type" >>/tmp/.tmp_file_list
	for  file_name in `cat /tmp/.tmp_file_list` #获取文件名称
	  do
		  basename $file_name >>/tmp/.file_name_list
	  done
	  rm -rf /tmp/.tmp_file_list
	  sort -t- -k1 -n /tmp/.file_name_list>>/tmp/.tmp_file_list  #对文件名称进行排序

case $2 in
	AA)
	  if [ $synctype_del == yes ];then
		  sleep $_sleep && sync
	  else
		   for list in `cat /tmp/.tmp_file_list`
		    do
			rm -rf $1/$list &
			echo "`date +%F====%T`	$1/$list	Delete	ok!!!"   >>$_sys_log
	  	   done
		   
	  fi
	;;
	BB)
		   if [ $file_md5_check == "0" ];then
			
	   		for list in `cat /tmp/.tmp_file_list`
			 do
		   	  rm -rf $1/$list &
		   	  echo "$1/$list	Delete	ok!!!"   >>$_sys_log
			done
		  else
	   		for list in `cat /tmp/.tmp_file_list`
		   	 do
			   src_md5=`echo $list|awk -F. '{print $1}'|awk -F- '{print $2}'`
		   	    get_md5 $1/$list $file_md5_check
			    if [ $src_md5 == $get_md5 ];then
			        rm -rf $1/$list &
			        echo "`date +%F====%T`	$1/$list	Delete	ok!!!"   >>$_sys_log
			    else
			        echo "`date +%F====%T`	$1/$list	Error	ok!!!"   >>$_sys_log
		   	    fi
			done
		     fi
    ;;
    *)
		echo "check_file  1=dst_dir/src_dir  3=AA/BB"
	;;
esac
}

get_usage_disk () {
	# get_usage_disk $1 1=_disk_drive
	#获取磁盘当前使用率.
	usage=`df -k |grep $1|grep lv|grep -v grep  `
	if [ "$usage" == "" ];then
		usage=`df -k |grep $1|awk '{print $5}'|tr -d '%'`
	else
	    usage=`df -k |grep $1|grep -v iso |grep -v lv  |awk '{print $4}'|tr -d '%'`
	fi
}

get_md5  () {
	#get_md5 $1 $2 1=文件 2=0|1
    #获取MD5
    if [ "$2" == "0" ];then
		get_md5=
	else
		get_md5=`md5sum $1|awk '{print $1}'`
	fi
}
##############################################################
touch_number=10000
d_dir_a=/test/recv   #Destination directory AA
d_dir_b=/test/recv   #Destination directory BB
touch_file_mode=random  #dd:创建固定大小文件   random:创建随即大小文件
file_size=11  #mb    #dd模式生效，固定文件大小
dd_speed=no #mb    #dd模式生效，快速生成 开启:yes,关闭:no
file_size_random=2  #random模式生效，随机文件随即范围1=0-10k 2=0-100k 3=0-1000K 4=0-10M
file_type=rar
file_md5_check=1    #0:关闭文件md5检查   1:开启文件MD5检查
_disk_drive=boot    #监控目录
_disk_alert=70  	#磁盘警戒值（使用率）
synctype_del=yes    #yes:源端删除策略 no:非源端删除策略
_sleep=30           #Check the alert value for a cycle of sleep.
_sys_log=sys.log
##############################################################
A='Loop create file'
B='Loop check file'
case $1 in 
	  A)
		 for ((i=1;i<=$touch_number;i++))
		   do	
			   if [ "$touch_file_mode" == "dd" ];then #创建固定大小文件
				   if [ "$dd_speed" == "yes" ];then   #快速模式生成固定大小的文件
					   if [ "$i" == "1" ];then 
						  dd if=/dev/zero of=/tmp/$i.$file_type bs=1M  count=$file_size  >>/dev/null  2>&1
					   fi
					   echo $i >>/tmp/1.$file_type	
					   get_md5  /tmp/1.$file_type  $file_md5_check
					   cp /tmp/1.$file_type  $d_dir_a/$i-$get_md5.$file_type  
					   if [ "$i" == "$touch_number" ];then
						   rm -rf  /tmp/1.$file_type	
					   fi
					else #普通模式生成固定的大小的文件
						dd if=/dev/zero of=/tmp/$i.$file_type bs=1M  count=$file_size     >>/dev/null  2>&1
						echo $i >>/tmp/$i.$file_type	
					    get_md5 /tmp/$i.$file_type  $file_md5_check
						mv /tmp/$i.$file_type  $d_dir_a/$i-$get_md5.$file_type  
					fi
			   elif [ "$touch_file_mode" == "random" ];then #创建随机大小的文件
				   dd if=/dev/zero of=/tmp/$i.$file_type bs=1024c  count=`date +%N |cut -b 1-$file_size_random`    >>/dev/null   2>&1
				   echo $i >>/tmp/$i.$file_type	 
				   get_md5 /tmp/$i.$file_type  $file_md5_check
				   mv /tmp/$i.$file_type  $d_dir_a/$i-$get_md5.$file_type  
			   fi
			   #echo "`date +%F====%T`	$list	Delete	ok!!!" 
			   echo "`date +%F====%T`	$i	$i-$get_md5.$file_type	Create	ok!!!" >>$_sys_log
			   get_usage_disk $_disk_drive #获取磁盘已使用率
			   #usage=`df -k |grep $_disk_drive|awk '{print $5}'|tr -d '%'` #获取磁盘已使用空间
			   usage_wc=`find $d_dir_a/ -name "*" |wc -l ` #获取文件数目
				if [ ! $usage ];then
					echo "Check to see if the alert is empty!!!"
					exit
				fi
				if [ $usage -ge $_disk_alert ];then #获取已使用空间大于警戒值则执行删除
				 check_file  $d_dir_a   AA
				elif [ $usage_wc -ge 100000 ];then  #获取目录文件数目大于10w执行删除动作
				 check_file  $d_dir_a   AA
				fi
		   done
		 ;;
	  B)
	     
		while [ 1 ]
			do 
				sleep $_sleep  
				sync
			    get_usage_disk $_disk_drive #获取磁盘已使用率
				#usage=`df -k |grep $_disk_drive|awk '{print $5}'|tr -d '%'`
			    usage_wc=`find $d_dir_b/ -name "*" |wc -l ` #获取文件数目
				if [ ! $usage ];then
					echo "Check to see if the alert is empty!!!"
					exit
				fi
				if [ $usage -ge $_disk_alert ];then #获取已使用空间大于警戒值则执行删除
					check_file  $d_dir_b  BB
				elif [ $usage_wc -ge 1000 ];then  #获取目录文件数目大于10w执行删除动作
					check_file  $d_dir_b  BB
				fi
			done
		;;
	  *)
	    echo "./$0 A	#$A"
		echo "./$0 B	#$B"
		;;
esac
