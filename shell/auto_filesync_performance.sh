#!/bin/bash
_file_time ( ) {
 _wc=`ls -l $file_dir/* |wc -l`
 _frist=`ls -rt $file_dir/*  |sed -n 1p`
 _end=`ls -rt $file_dir/*  |sed -n "$_wc"p`
 _start_time=`stat $_frist |grep -i "Access"|sed -n 2p  |awk '{print $3}'|awk -F. '{print $1}'`
 _stop_time=`stat $_end |grep -i "Modify"  |awk '{print $3}'|awk -F. '{print $1}'`
 echo start_time=$_start_time   stop_time=$_stop_time
}
_show_file ( ) {
 _wc=`ls -l $file_dir/* |wc -l`
 _file_size=`du -h $file_dir|awk '{print $1}'`
 echo "$1 == $_wc == $_file_size"
}

####################################################################################################################
file_dir=/home/test
####################################################################################################################
case $1 in 
	 touch_file)
	if [  -n "$2" ] ;then
             #echo "Parameter input error !!! \n Example: XX TXT 1K 100"
                number_1=$[$4+1]
		for ((i=1;i<$number_1;i++));
	      do 
			  dd if=/dev/urandom of=$file_dir/expc_$i.$2  bs=$3  count=1  >>/dev/null 2>&1
			  echo  -e "########### touch  $file_dir/expc_$i.$2  #############\n"
	     done 
     	 else
			 echo " Parameter input error !!!  Example: 2:file_type=exe 3:file_size=1K/4K/10K/100M/8G 4:file_number=100" 
            fi	
     ;;
	  show_file)
	   echo `_show_file $file_dir`
	 ;;
	  file_time)
	   _file_time
     ;;	
      *)
	  echo "#######################################################"  
	  echo $0 touch_file  file_type file_size file_number  
	  echo $0 show_file  #show file 
	  echo $0 file_time  #show file touch time
	  echo "#######################################################"  
	 ;;
esac
