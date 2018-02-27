#!/bin/bash
#获取指定范围的随机值
function rand (){  
    min=$1  
    max=$(($2-$min+1))  
    num=$(date +%s%N)  
    echo $(($num%$max+$min))  
}

while [ 1 ]
do
	rnd=$(rand 2 9)
	echo $rnd
sleep 1
done
