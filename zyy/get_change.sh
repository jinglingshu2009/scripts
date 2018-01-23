#!/bin/bash
#按照数值大小替换规格数据

get_spec ( ) {
	get_spec=`echo $1|awk -F, '{print $7}'`
	get_spec_1=`echo $get_spec|awk -Fx '{print $1}'`
	get_spec_2=`echo $get_spec|awk -Fx '{print $2}'`
	get_spec_3=`echo $get_spec|awk -Fx '{print $3}'`
	if [ "$get_spec_1" -gt "$get_spec_2 "];then
		new_spec=$get_spec
	else
		if [ ! -n "$get_spec_3" ];then
			new_spec="$get_spec_2\x$get_spec_1"
		else
			new_spec="$get_spec_2\x$get_spec_1\x$get_spec_3"
		fi
	  fi
	}


##################################################################################

file_=`wc -l goods.csv|awk '{print $1}'`
for ((i=1;i<=$file_;i++));
do
	if [ $i > 1 ];then	
	zz=`sed -n "$i"p goods.csv`
	id=`echo $zz|awk -F, '{print $1}'`
	get_spec=`echo $zz|awk -F, '{print $7}'`
	_if=`echo $get_spec|grep -i "x"`
	if [ ! -n "$_if" ];then #判断规格是否为数值，如不是将文字赋值给新规格
		new_spec=$get_spec
	else	
	get_spec_1=`echo $get_spec|awk -Fx '{print $1}'`
	get_spec_2=`echo $get_spec|awk -Fx '{print $2}'`
	get_spec_3=`echo $get_spec|awk -Fx '{print $3}'`
	if [ "$get_spec_1" -gt "$get_spec_2" ];then #判断规格中最大值，做第一个值大于第二个将规格直接复制给新规格即可
		new_spec=$get_spec
	else
		if [ ! -n "$get_spec_3" ];then  #判断规格中第三个数值是否存在，若不存在仅显示规格两个数值即可
			new_spec=$get_spec_2'x'$get_spec_1
		else
			new_spec=$get_spec_2'x'$get_spec_1'x'$get_spec_3 #若存在将完整显示排序后的三个规则数值
		fi
	   fi
	 fi
		
	
	#get_spec $zz
	echo $id $get_spec $new_spec
	echo $new_spec >>new_spec.txt
else
	zz=`sed -n "$i"p goods.csv`
	id=`echo $zz|awk -F, '{print $1}'`
	echo $i=$id 

fi
done


