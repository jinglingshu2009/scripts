#!/bin/bash
#根据规格查找对应产品的组ID
##########################
IFS=$(echo -en "\n\b")
echo -en $IFS
##########################

_wc=`wc -l tp_spec_goods_price.csv|awk '{print $1}'`
id=0
while [ $id -lt $_wc ]
do
	id=$(($id+1))
	zz=`sed -n  "$id"p tp_spec_goods_price.csv`
	get_spec=`echo $zz |awk -F, '{print $4}'`
	get_key_name=`echo $zz |awk -F, '{print $5}'`
	get_goods_id=`echo $zz |awk -F, '{print $2}'`
	if [ $id > 1 ];then
		get_key=`grep -w "$get_spec" tp_spec_item.csv|awk -F, '{print $1}'`
		if [ "$get_key" == "Binary file tp_spec_item.csv matches" ];then
		    get_key=1
		fi
		echo $id $get_goods_id   $get_spec $get_key_name $get_key
		#echo $id	$get_goods_id	$get_spec	$get_key_name	$get_key>>get_key.txt
		echo $get_key>>get_key
	else
		get_goods_id=`echo $zz |awk -F, '{print $2}'`
		#echo $id	$get_goods_id	$get_spec	$get_key_name	$get_key>>get_key.txt

	fi
done
