#!/sbin/bash
############################
IFS=$(echo -en "\n\b")
echo -en $IFS
############################

check_USAtoTST ( ) {
	#输入USA货号输出陶斯特货号($TST_id)
	#使用方式 check_USAtoTST $1
	TST_id=`grep $1 get_|awk -F= '{print $4}'`
	}

get_file ( ) {
	#输入文件获取1M以内或者后缀名称为jgp的文件并拷贝到指定目录
	# get_file $1:文件 $2:目标目录
 	#Size
	file_size=`du $1|awk '{print $1}'`
	if [ $file_size -lt 1024 ];then
		cp $2
	#Suffix
	get_suffix=`basename $1|awk -F. '{print $2}'`
	elif [ $get_name == jpg ];then
		cp $2
	fi
	}

######################################################################
src_dir=D:/scripts
dst_dir=D:/tmp


######################################################################


find $src_dir -type f >>.file
for _file in `cat .file`
do
	_size=`du $_file|awk '{print $1}'`
	_name=`basename $_file|awk -F. '{print $1}'`
	_type=`basename $_file|awk -F. '{print $2}'`
	echo "$_name..$_type..$_size"
	sleep 1
echo "#################################"
	#get_file $_file $dst_dir
done

#check_USAtoTST  $1
#exit

#_end=`wc -l TTSSkusCSV_WAttributes_WCategories.csv|awk '{print $1}'`
#for ((i=1;i<=$_end;i++))
#do
#    USA_id=`sed -n "$i"p TTSSkusCSV_WAttributes_WCategories.csv|awk -F, '{print $2}'`
#    TST_id=`sed -n "$i"p TTSSkusCSV_WAttributes_WCategories.csv|awk -F, '{print $3}'`
#    echo ID=$i	USA_id=$USA_id	TST_id=$TST_id
#done
