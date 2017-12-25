#!/bin/bash
IFS=$(echo -en "\n\b")
echo -en $IFS
local1=e:/zyy/小于1M
local2=e:/zyy/1M-2M
local3=e:/zyy/2M-3M
local4=e:/zyy/3M-4M
local5=e:/zyy/4M-5M
local6=e:/zyy/5M-6M
local7=e:/zyy/6M-7M
local8=e:/zyy/大于7M
id=1
mkdir  $local1 $local2 $local3 $local4 $local5 $local6 $local7 $local8
for file_name in `cat xiaoguo-ok.list`
do
	file_size=`du $file_name|awk '{print $1}'`
 	if [ $file_size -lt 1000 ];then
		local=$local1
	    cp  $file_name $local
 	elif [ $file_size -lt 2000 ];then
		local=$local2
	    cp  $file_name $local2
        elif [ $file_size -lt	3000 ];then
		local=$local3
	    cp  $file_name $local3
	elif [ $file_size -lt	4000 ];then
		local=$local4
	    cp  $file_name $local4
  	elif [ $file_size -lt 5000 ];then
		local=$local5
	    cp  $file_name $local5
 	elif [ $file_size -lt 6000 ];then
		local=$local6
	    cp  $file_name $local6
        elif [ $file_size -lt 7000 ];then
		local=$local7
	    cp  $file_name $local7
	  else
		local=$local8
	    cp  $file_name $local8
        fi	
	echo $id	$file_name	$local		$file_size	
	id=$(($id+1))

done
