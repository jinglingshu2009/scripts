#!/bin/bash
IFS=$(echo -en "\n\b")
echo -en $IFS
local1=e:/zyy/小于900K
local2=e:/zyy/900k-2M
local3=e:/zyy/2M-3M
local4=e:/zyy/3M-4M
local5=e:/zyy/4M-5M
local6=e:/zyy/5M-6M
local7=e:/zyy/6M-7M
local8=e:/zyy/大于7M
id=1
for file_name in `cat xiaoguo-ok.list`
do
	file_size=`du $file_name|awk '{print $1}'`
	#if [ $file_size -lt 1000 ];then
	#	echo $id
	#else

	echo  $id	$file_name	$file_size
	#fi
	id=$(($id+1))
	
done
