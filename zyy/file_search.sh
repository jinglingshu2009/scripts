#!/bin/bash

get_name () {
  get_name=`basename $1`
}

get_dir () {
  get_dir=`dirname $1`
  }
mk_dir () {
   if [ ! -d "$1" ];then
	   mkdir  -p "$1"
   fi
}

##########################
IFS=$(echo -en "\n\b")
echo -en $IFS
##########################

rm -rf .file
src_dir=back
dst_dir=e:/zyy/ceshi
id=1

case $1 in
    AA)
	find $src_dir  -type f >>.file
	for _file in `cat .file`
	do
		get_name $_file  && get_dir $_file
		#$get_dir/$get_name
		#dir_new=`echo $get_dir|awk -F: '{print $2}'|sed "s|/|+|g"`
		dir_new=`echo $get_dir|sed "s|/|+|g"`
		cp $get_dir/$get_name $dst_dir/$dir_new=$get_name
		echo "$id=$get_dir/$get_name $dst_dir/$dir_new=$get_name"
		id=$(($id+1))
	done
	;;
    BB)
	find $src_dir  -type f >>.file
	for _file in `cat .file`
	do
		get_name $_file  
		#$get_dir/$get_name
		#dir_new=`echo $get_dir|awk -F: '{print $2}'|sed "s|/|+|g"`
		_dir=`echo $get_name|awk -F= '{print $1}'|sed "s|+|/|g"`
		_name=`echo $get_name|awk -F= '{print $2}'`
		mk_dir $dst_dir/$_dir
		cp $_file $dst_dir/$_dir/$_name
		echo "$id	$_file		$_dir/$_name"
		id=$(($id+1))
	done
	;;
     *)
	 echo "$0 AA  将文件夹内文件转换为含文件路径名称的文件，并CP至指定目录"
	 echo "$0 BB  将含文件路径名称的文件重新拷贝至对应文件夹中"
       ;;
esac

