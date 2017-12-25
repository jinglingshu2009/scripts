#!/bin/bash
#Auto_iperf was written by CyberXingan Test in 2017-10-11.
#############################
send_ip=192.168.126.134
_run_number=1
_print_interval=1			#日志打印间隙(print log time)
_threads=10					#发送客户端线程数，默认为1
_udp_bandwidth_switch=yes	#UDP协议带宽开关 yes|no(关闭后默认1Mbits/sec)
_udp_speed=15				#UDP协议传输速度,单位Mbits/sec
_run_day=
_run_hours=1
port=17100					#设置iperf传输端口，默认传输端口为16100
log=$1.log
#############################
if [ ! -n "$_run_day" ];then 
	if [ ! -n "$_run_hours" ];then
    	 _run_time=60                    #_run_day=nul _run_hours=nul Default 60s
     else 
    	_run_time=$((60*60*$_run_hours)) #_run_day=nul Default 60*60*$_run_hours
     fi
 else
	_run_time=$((60*60*24*$_run_day))  
 fi
if [ ! -n "$_threads" ];then
   _threads=1	#_threads=nul Default threads=1 
fi
if [ ! -n "$port" ];then
   port=16100	#port=nul Default port=16100 
fi
case $1 in 
	  send_SGG) #AAA-->SGGA==SGGB-->BBB(TCP/UDP)
			  if [ -f "/tmp/._$1_pid" ];then   
				  for _pid in `cat /tmp/._$1_pid`
					do   
					  kill -9 $_pid 2>&1  >>/dev/null
				   done	
				fi
				  rm -rf /tmp/.$1-*   /tmp/._$1_pid
				  echo $$ >>/tmp/._$1_pid #获取自身PID 
				_port=$port
				_end_port=$(($port+$_run_number))
				_protocol=tcp-udp
				for ((n=$_port; n<$_end_port; n++)); #send iperf data
				 do
					 iperf -c $send_ip -i $_print_interval  -p $n  -t $_run_time -P $_threads 2>&1  >>/tmp/.$1-tcp-$_run_time-$n & 
					echo $! >>/tmp/._$1_pid	#_pid=$!  #get pid  
					 sleep 0.001
					 if [ $_udp_bandwidth_switch = yes ];then
						 iperf -c $send_ip -i $_print_interval  -p $n  -b $(($_udp_speed*1024000))	-t $_run_time  -u -P $_threads 2>&1  >>/tmp/.$1-udp-$_run_time-$n  &
					  else
						 iperf -c $send_ip -i $_print_interval  -p $n  -t $_run_time  -u  -P $_threads 2>&1  >>/tmp/.$1-udp-$_run_time-$n  &
						fi
					 echo $! >>/tmp/._$1_pid  #get pid
					 #echo "$_port  $_protocol"
				done
				#get log;
				_end_time=$((`date +%s`+$_run_time))
				_port=$port
				_end_port=$(($port+$_run_number))
				_log_name=`ls /tmp/.*-*-*-*|sed -n '1p'|awk -F- '{print $1}' |awk -F. '{print $2}'`
		   while [ 1 ] 
		     do
			  if [ $_end_time -ge `date +%s` ];then 
				 sleep $_print_interval
				 #echo $_log_name:$_end_time-`date +%s`=$(($_end_time-`date +%s`)):$_run_time >>$log
				 echo $_log_name====结束时间:$_end_time====当前时间:`date +%s`====剩余时间:$(($_end_time-`date +%s`))====运行时间:$_run_time >>$log
			 	 for ((i=$_port ;i<$_end_port;i++));
			 	   do
				     #_pid=`ps aux |grep -i $_port|grep -v grep|awk '{print $2}'`
			 	     tcp_log=`tail -n 1 /tmp/.$1-tcp-*-$i`	
			 	     udp_log=`tail -n 1 /tmp/.$1-udp-*-$i`
				     tcp_pid=`ps aux |grep -i $i|grep -v grep|sed -n '1p' |awk '{print $2}'`
			 	     echo "A-->B:A:tcp:$tcp_pid:$i:$tcp_log" 2>&1  >>$log
				     udp_pid=`ps aux |grep -i $i|grep -v grep|sed -n '2p' |awk '{print $2}'`
			 	     echo "A-->B:A:udp:$udp_pid:$i:$udp_log" 2>&1 >>$log
			 	  done
			    else
				  exit
			   fi
		    done
		;;
	  recv_SGG) #AAA-->SGGA==SGGB-->BBB(TCP/UDP)
			  if [ -f "/tmp/._$1_pid" ];then 
				     
					for _pid in `cat /tmp/._$1_pid`
					  do   
						kill -9 $_pid  2>&1  >>/dev/null
					done
				fi 
					rm -rf /tmp/.$1-*   /tmp/._$1_pid
					echo $$ >>/tmp/._$1_pid #获取自身PID 
				_port=$port
				_end_port=$(($port+$_run_number))
				_protocol=tcp-udp
				for ((_port=$_port; _port<$_end_port; _port++));
				 do
					 iperf -s  -i $_print_interval  -p $_port   2>&1  >>/tmp/.$1-tcp-$_run_time-$_port &
					 echo $! >>/tmp/._$1_pid #_pid=$!  #get pid
					 iperf -s  -i $_print_interval  -p $_port   -u 2>&1  >>/tmp/.$1-udp-$_run_time-$_port  & 
					 echo $! >>/tmp/._$1_pid #_pid=$!  #get pid
					 #iperf -s -i 1 -p 1234 2>&1  >>/dev/null    & 
					 #echo $! #get pid
				 done
				#get log;
				_end_time=$((`date +%s`+$_run_time))
				_port=$port
				_end_port=$(($port+$_run_number))
				_log_name=`ls /tmp/.*-*-*-*|sed -n '1p'|awk -F- '{print $1}' |awk -F. '{print $2}'`
		   while [ 1 ] 
		     do
			  if [ $_end_time -ge `date +%s` ];then 
				 sleep $(($_print_interval))
				 #echo $_log_name:$_end_time-`date +%s`=$(($_end_time-`date +%s`)):$_run_time >>$log
				 echo $_log_name====结束时间:$_end_time====当前时间:`date +%s`====剩余时间:$(($_end_time-`date +%s`))====运行时间:$_run_time >>$log
				 #echo $_log_name:$_end_time-`date +%s`:$_run_time >>$log
			 	 for ((i=$_port ;i<$_end_port;i++));
			 	   do
				     #_pid=`ps aux |grep -i $_port|grep -v grep|awk '{print $2}'`
			 	     tcp_log=`tail -n 1 /tmp/.$1-tcp-*-$i`	
			 	     udp_log=`tail -n 1 /tmp/.$1-udp-*-$i`
				     tcp_pid=`ps aux |grep -i $i|grep -v grep|sed -n '1p' |awk '{print $2}'`
			 	     echo "A-->B:B:tcp:$tcp_pid:$i:$tcp_log" 2>&1  >>$log
				     udp_pid=`ps aux |grep -i $i|grep -v grep|sed -n '2p' |awk '{print $2}'`
			 	     echo "A-->B:B:udp:$udp_pid:$i:$udp_log" 2>&1 >>$log
			 	  done
			    else
				  exit
			   fi
		    done
				;;
				*)
				echo $0 send_SGG '#AAA-->SGGA==SGGB-->BBB(TCP:'$port'/UDP:'$port')'
				echo $0 recv_SGG '#AAA-->SGGA==SGGB-->BBB(TCP:'$port'/UDP:'$port')'
		;;
esac
