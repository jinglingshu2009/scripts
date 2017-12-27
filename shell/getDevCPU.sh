#!/bin/bash
#
# 获取CPU利用率
#

#/proc/status fields
#cpu user nice system idle iowait irq softirq steal guest
#Note: usage = 
# (user + nice + system) / (user+nice+system+idle+iowait+irq+softirq+steal+guest)

function get_busy_time()
{
    local res=0

    if [ $# -ge 1 ]; then
        res=`echo "$@" |awk '{print $2 + $3 + $4}'`
    fi

    echo ${res}
}

function get_total_time()
{
    local res=0

    if [ $# -ge 1 ]; then
        res=`echo "$@" |awk '{print $2 + $3 + $4 + $5 + $6 + $7 + $8 + $9 + $10}'`
    fi

    echo ${res}
}

#status file
STATFILE="/proc/stat"
#usage scale
SCALE=2

stat1=`cat ${STATFILE} |grep '^cpu\b'`
sleep 1
stat2=`cat ${STATFILE} |grep '^cpu\b'`

busy1=$(get_busy_time "${stat1}")
busy2=$(get_busy_time "${stat2}")

total1=$(get_total_time "${stat1}")
total2=$(get_total_time "${stat2}")

busy=`expr ${busy2} - ${busy1}`
total=`expr ${total2} - ${total1}`

if [ ${total} -ne 0 ]; then
    usage=`echo "scale=${SCALE}; (100.0 * ${busy}) / ${total}" |bc`
else
    usage=0.00
fi

printf "%.2f\n" ${usage}

exit 0

