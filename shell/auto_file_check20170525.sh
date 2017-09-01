#/bin/bash
#File sync check by V1.0.0.0 for 2017-05-25
##############################################################
check_file () {
	if [ ! $1 ];then
		echo "check_file  1=dst_dir/src_dir 2=AA/BB"
		exit
	fi
	Dele_file_number=$((`ls -rtl $1/*|wc -l`/2))	#Default Delete 1/2 file 
	file_list=`ls -rtl $1/*|awk '{print $NF}'|head -$Dele_file_number`	#$1=Desttination directory BB 
case $2 in
	AA)
	   for list in $file_list
	    do
			rm -rf $list
			echo "`date +%F====%T`	$list	Delete	ok!!!" 
		done
	;;
	BB)
	   for list in $file_list
	    do
		   dst_file=`basename $list`
		   #echo "2" >>$list
		   src_md5=`echo $list|awk -F. '{print $1}'|awk -F- '{print $2}'`
		   dst_md5=`md5sum $list|awk '{print $1}'`
		   #echo id=$n file=$list$ src_md5=$src_md5  dst_md5=$dst_md5 
		   if [ $src_md5 == $dst_md5 ];then
			   rm -rf $list
			   echo "`date +%F====%T`	$list	Delete	ok!!!" 
		     else
			   echo "`date +%F====%T`	$list	Error	!!!" 
		   fi
	   done
    ;;
    *)
		echo "check_file  1=dst_dir/src_dir  3=AA/BB"
	;;
esac
	   #basename=get filename ;dirname=get dirname
}
##############################################################
touch_number=3000000
d_dir_a=/mnt/test   #Destination directory AA
d_dir_b=/mnt/test   #Destination directory BB
file_size=10			#mb
file_type=rar
_disk_drive=mnt     #
_disk_alert=60  	#Hard disk monitoring alert valuer.
_sleep=5            #Check the alert value for a cycle of sleep.
##############################################################
A='Loop create file'
B='Loop check file'
case $1 in 
	  A)
		 for ((i=1;i<=$touch_number;i++))
		   do	
			   dd if=/dev/zero of=$d_dir_a/$i.$file_type bs=1M  count=$file_size  >>/dev/null  2>&1
			   echo $i >>$d_dir_a/$i.$file_type  
			   _name=`md5sum $d_dir_a/$i.$file_type |awk '{print $1}'`
			   mv $d_dir_a/$i.$file_type  $d_dir_a/$i-$_name.$file_type  && sync
			   #echo "`date +%F====%T`	$list	Delete	ok!!!" 
			   echo "`date +%F====%T`	$i	$i-$_name.$file_type	Create	ok!!!"
			   usage=`df -k |grep $_disk_drive|awk '{print $5}'|tr -d '%'`
				if [ ! $usage ];then
					echo "Check to see if the alert is empty!!!"
					exit
				fi
				if [ $usage -ge $_disk_alert ];then
				check_file  $d_dir_a   AA
				fi
		   done
		 ;;
	  B)
	     
		while [ 1 ]
			do 
				sleep $_sleep
				usage=`df -k |grep $_disk_drive|awk '{print $5}'|tr -d '%'`
				if [ ! $usage ];then
					echo "Check to see if the alert is empty!!!"
					exit
				fi
				if [ $usage -ge $_disk_alert ];then
					check_file  $d_dir_b  BB
				fi
			done
		;;
	  *)
	    echo "./$0 A	#$A"
		echo "./$0 B	#$B"
		;;
esac
