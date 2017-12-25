#!/bin/bash 
/usr/local/bin/iperf 
iperf_server=192.168.1.222 
iperf_number=1 
data_time=300

case "$1" in
	    start_client)
	    killall iperf >>/dev/null
		for ((i=30000;i<=30100;i++))
		do
			/usr/local/bin/iperf -c $iperf_server -i 1 -p $i -P $iperf_number -t $data_time 2>&1 >>/dev/null &
		#	/usr/local/bin/iperf -s  -i 1 -p $i   2>&1 >>/dev/null &
	     done
		;;
	    start_server)
	    killall iperf >>/dev/null
		for ((i=30000;i<=30100;i++))
		do
		#	/usr/local/bin/iperf -c $iperf_server -i 1 -p $i -P $iperf_number  2>&1 >>/dev/null &
			/usr/local/bin/iperf -s  -i 1 -p $i   2>&1 >>/dev/null &
	     done
		;;
		wc_l)
		 while [ 1 ]
		 do 
			 echo -e "##############################################"
			 netstat -an  |grep -v grep |grep -i $iperf_server |wc -l
			 echo -e "##############################################\n"
		 sleep 1 
		 done
		;;
		*)
		echo "$0 start_client | start_server |wc_l"
		;;
esac
