#!/bin/bash
#auto iperf
send_ip=192.168.199.101
_run_number=5
_print_interval=3
#print log time 
_run_day=
_run_hours=1
log=$1.log
#############################
if [ ! -n "$_run_day"  ];then 
	if [ ! -n "$_run_hours" ];then
    	 _run_time=60                    #_run_day=nul _run_hours=nul Default 60s
     else 
    	_run_time=$((60*60*$_run_hours)) #_run_day=nul Default 60*60*$_run_hours
     fi
 else
	_run_time=$((60*60*24*$_run_day))  
 fi
case $1 in 
	  send_SGG) #AAA-->SGGA==SGGB-->BBB(TCP/UDP)
			  if [ -f "/tmp/._$1_pid" ];then   
				  for _pid in `cat /tmp/._$1_pid`
					do   
					  kill -9 $_pid 2>&1  >>/dev/null
				   done	
				fi
				  rm -rf /tmp/.$1-*   /tmp/._$1_pid  /tmp/.md5_tcp
				_port=16100
				_end_port=$((16100+$_run_number))
				_protocol=tcp-udp
				for ((n=$_port; n<$_end_port; n++)); #send iperf data
				 do
					 iperf -c $send_ip -i $_print_interval  -p $n  -t $_run_time 2>&1  >/tmp/.$1-tcp-$_run_time-$n & 
					echo $! >>/tmp/._$1_pid	#_pid=$!  #get pid  
					 sleep 0.001
					 iperf -c $send_ip -i $_print_interval  -p $n  -t $_run_time  -u 2>&1  >/tmp/.$1-udp-$_run_time-$n  & 
					 echo $! >>/tmp/._$1_pid  #get pid
					 #echo "$_port  $_protocol"
				done
				#get log;
				_end_time=$((`date +%s`+$_run_time))
				_port=16100
				_end_port=$((16100+$_run_number))
				_log_name=`ls /tmp/.*-*-*-*|sed -n '1p'|awk -F- '{print $1}' |awk -F. '{print $2}'`
		   while [ 1 ] 
		     do
			  if [ $_end_time -ge `date +%s` ];then 
				 sleep $_print_interval
				 #check_md5=`md5sum  md5sum /tmp/.send_SGG-tcp-3600-16100  |awk '{print $1}'` 
				 echo $_log_name:$_end_time-`date +%s`=$(($_end_time-`date +%s`)):$_run_time >>$log
			 	 for ((i=$_port ;i<$_end_port;i++));
			 	   do
				     tcp_md5=`md5sum /tmp/.$1-tcp-*-$i  |awk '{print $1}'`
					 old_tcp=`cat /tmp/.md5_tcp  |grep -i $i:tcp |awk -F: '{print $3}'`
				     udp_md5=`md5sum /tmp/.$1-udp-*-$i  |awk '{print $1}'` 
					 old_udp=`cat /tmp/.md5_tcp  |grep -i $i:udp |awk -F: '{print $3}'`
					 if [ "$tcp_md5" = "$old_tcp" ];then
						 echo  " iperf tcp 输出无变化！！！"
					  else
						 #_pid=`ps aux |grep -i $_port|grep -v grep|awk '{print $2}'`
				     	 tcp_pid=`ps aux |grep -i $i|grep -v grep|sed -n '1p' |awk '{print $2}'`
			 	     	 echo "A-->B:A:tcp:$tcp_pid:$i:`tail -n 1 /tmp/.$1-tcp-*-$i`" 2>&1  >>$log
					   fi
					 if [ "$udp_md5" = "$old_udp" ];then
					   	 echo  "iperf udp  输出无变化！！！"
					  else
						 udp_pid=`ps aux |grep -i $i|grep -v grep|sed -n '2p' |awk '{print $2}'`
			 	          echo "A-->B:A:udp:$udp_pid:$i:`tail -n 1 /tmp/.$1-udp-*-$i`" 2>&1 >>$log
					   fi
					   wc_md5=`wc -l /tmp/.md5_tcp|awk '{print $1}'`
                       end_wc=$(($_run_number*2))
					   if [ "$wc_md5" =  "$end_wc" ];then
					      sed -i -e "s/^$i:tcp:.*/$i:tcp:$tcp_md5/g" /tmp/.md5_tcp
					      sed -i -e "s/^$i:udp:.*/$i:udp:$udp_md5/g" /tmp/.md5_tcp
					   else
						   echo $i:tcp:$tcp_md5 >>/tmp/.md5_tcp
						   echo $i:udp:$udp_md5 >>/tmp/.md5_tcp
					   fi
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
				_port=16100
				_end_port=$((16100+$_run_number))
				_protocol=tcp-udp
				for ((_port; _port<$_end_port; _port++));
				 do
					 iperf -s  -i $_print_interval  -p $_port   2>&1  >/tmp/.$1-tcp-$_run_time-$_port &
					 echo $! >>/tmp/._$1_pid #_pid=$!  #get pid
					 iperf -s  -i $_print_interval  -p $_port   -u 2>&1  >/tmp/.$1-udp-$_run_time-$_port  & 
					 echo $! >>/tmp/._$1_pid #_pid=$!  #get pid
					 #iperf -s -i 1 -p 1234 2>&1  >>/dev/null    & 
					 #echo $! #get pid
				 done
				#get log;
				_end_time=$((`date +%s`+$_run_time))
				_port=16100
				_end_port=$((16100+$_run_number))
				_log_name=`ls /tmp/.*-*-*-*|sed -n '1p'|awk -F- '{print $1}' |awk -F. '{print $2}'`
		   while [ 1 ] 
		     do
			  if [ $_end_time -ge `date +%s` ];then 
				 sleep $(($_print_interval))
				 echo $_log_name:$_end_time-`date +%s`=$(($_end_time-`date +%s`)):$_run_time >>$log
				 #echo $_log_name:$_end_time-`date +%s`:$_run_time >>$log
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
				*)
				echo $0 send_SGG '#AAA-->SGGA==SGGB-->BBB(TCP:16100/UDP:16100)'
				echo $0 recv_SGG '#AAA-->SGGA==SGGB-->BBB(TCP:16100/UDP:16100)'
		;;
esac
