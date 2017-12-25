#!/bin/bash
#set -x 
#20160606 Auto_test_SGG
#echo "---------------------------------" 
#echo "#                               #"
#echo "#    PC_A >>> SGG >>> PC_B      #"
#echo "#                               #"
#echo "---------------------------------"
ping_ck( ) {
 case $1 in
	  p1)
		ping -c $2 $3 >/dev/null
		if [ $? = 0 ];then
			   return 0
		   else
			   return 1
		   fi
		   ;;
      p2)
	  ping -c $2 $3 |grep packets >.ping2
	  p_check=`cat .ping2 | awk '{print $1}'`
	  p_check2=`cat .ping2 | awk '{print $4}'` && rm .ping2 -rf 
	 # echo 1:$p_check2 2:$2
		if [ $p_check2 = $2 ];then
			   return 3
		   else
			   return 4
		   fi
		   ;;
		*)
		echo "#ping_ck p1/p2 ping_number ip; 0=ping success 1=ping nowhere  3=Accurate normal ping packets 4=Precise ping packet loss "
	esac
}
#ping_ck p1/p2 ping_number ip; 0=ping success 1=ping nowhere  3=Accurate normal ping packets 4=Precise ping packet loss 
check_package( ){
  ck_rpm=`rpm -qi $1 |grep Name|awk '{print $3}'` 
  ck_commod=`whereis $1 |awk '{print $2}'` 
 if [ "$ck_rpm" != "$1" -a "$ck_commod" = "" ];then
         echo "You did not "$1" to installation, please install the installation package!!!"
         return 4
    else
         return 0 
    fi
#$?=0 package+ok ; $?=4 No package
}
ssh_login( ) {
#  ck_rpm=`rpm -qi expect |grep Name|awk '{print $3}'` 
# if [ "$ck_rpm" != "expect" ];then
#     echo "You did not expect to installation, please install the installation package!!!"
#     return 0 
#    fi
 case $1 in
     ssh)
	expect -c "
        spawn  ssh $2 ;
	expect {
           \"yes/no\" {send \"yes\r\";exp_continue}	
            \"password:\" {send \"$3\r\"; exp_continue} 
            \"root@\" {send \"$4\r exit\r\"; exp_continue}
	}
	"
	return 11
        ;; 
     scp_down) 
	expect -c "
        spawn   scp root@$2:$4  $5 
	expect {
            \"yes/no\" {send \"yes\r\"; exp_continue}
			\"password:\" {send \"$3\r\"; exp_continue} 
	}
         "
	return 12
         ;; 
     scp_up) 
	expect -c "
        spawn   scp $4 root@$2:$5   
	expect {
            \"yes/no\" {send \"yes\r\"; exp_continue}
			\"password:\" {send \"$3\r\"; exp_continue} 
	}
         "
	return 13
         ;; 
	  *)
	#echo "eg:sh_login ssh/scp 2:x.x.x.x 3:pwd 4:'Command && Command'; 0=ok,1=error; "
	echo "eg:ssh_login 1:ssh 2:x.x.x.x 3:pwd 4:'Command && Command';To execute a command to the remote computer; 0=ok,1=error;"
	echo "eg:ssh_login 1:scp_down 2:x.x.x.x 3:pwd 4:/xx/down_srcfile 5:/xx/ ; Download the SCP file to the local;"
	echo "eg:ssh_login 1:scp_up 2:x.x.x.x 3:pwd  4:/xx/up_srcfile 5:/xxx/ ; SCP upload a local file to the remote computer;"
	return 14
         ;;
esac
 }
  new_number1=0
  new_number2=0
###############################################################################################################################
while  [ 1 ]
   do
###############################################################################################################################
#XingAn SGG
#echo "-----------------------------------------------------" 
#echo "#                                                   #"
#echo "#  mstsc_a       SGG_a       SGG_b         mstsc_b  #"
#echo "#     |            |           |             |      #"
#echo "#    PC_A >>>>>> SGG_a--->---SGG_b >>>>>> PC_B      #"
#echo "#        |                               |          #"
#echo "#       PC_A             -->            PC_B        #"
#echo "#                                                   #"
#echo "-----------------------------------------------------"
###############################################################################################################################
#glgbal
  log=".log"
  channel=2
  ping_num=8
  port=10001
  data_time=10
  delay=5       #SGG 20s/SPG 25s
  time_now=`date +%T`
  n_end=100       #run number 
  time_run=1       #day
  product_type=SPG #product_type=SPG/SGG
###############################################################################################################################
#SPG/SGG/TEST
  #SGG_a=a3 && SGG_a_passwd=Cyber@XA\#2009
  #SGG_a=a3 && SGG_a_passwd=Cyber@XA\#2009
   PC_A=172.168.31.98 && PC_A_passwd=123qwe         
   PC_B=172.168.31.99  && PC_B_passwd=123qwe
  SGG_a=$PC_A && SGG_a_passwd=$PC_A_passwd
  SGG_b=$PC_B && SGG_b_passwd=$PC_B_passwd
#_______________________________________________________________________________________________________________________________
# Judge #0 run times or time or check package
   if [ ! -f ".a" ];then
       echo "0" >.a
#_______________________________________________________________________________________________________________________________
# check package
#     check_package iperf  >>$log 
#      if [ $? = 4 ];then
#          break
#       fi 
#     check_package expect  >>$log
#      if [ $? = 4 ];then
#          break
#       fi 
    fi
#_______________________________________________________________________________________________________________________________
   export a=$(cat .a) >>/dev/null
   end=$(($a+1))  && echo $end >.a
   if [ "$n_end" -lt "$end" ];then
    while [ 1 ]
        do
            ping_ck p2 $ping_num $SGG_a 2>&1 >>/dev/null
	        ping_a=$?	
            ping_ck p2 $ping_num $SGG_b 2>&1 >>/dev/null
	        ping_b=$?	
      	       p_sum=$(($ping_a+$ping_b))
           # ping_ck p2 $ping_num $SGG_b 2>&1 >>/dev/null
      	       p_sum=$?   #p_sum=3 ok
		if [ $p_sum = 6 ];then
                    #ssh_login ssh $SGG_a $SGG_a_passwd 'shutdown -h now' 2>&1 >>/dev/null
                    #ssh_login ssh $SGG_b $SGG_b_passwd 'shutdown -h now' 2>&1 >>/dev/null
                    echo "shutdown a/b" >>$log  
				    break
                  fi
       done
              
	echo -e "\n" >>$log
   	echo -e "\033[1m ^_^############ $end=$n_end #################################################^_^  the_end `date +%Y-%m-%d-%T`\033[0m" >>$log
	rm .a -rf 2>&1 >>/dev/null
	 break 
  else
        echo -e "\n" >>$log
   	echo -e "\033[1m ^_^############ $end #################################################^_^  ok `date +%Y-%m-%d-%T`\033[0m" >>$log
  fi
#______________________________________________________________________________________________________________________________
#^_^check network ^_^
while [ 1 ]
  do
     ping_ck p2 $ping_num $SGG_a 2>&1 >>/dev/null
	    ping_a=$?
     ping_ck p2 $ping_num $SGG_b 2>&1 >>/dev/null
	    ping_b=$?
            p_sum=$(($ping_a+$ping_b))
            ping_ck p2 $ping_num $SGG_b 2>&1 >>/dev/null
#            p_sum=$?   #p_sum=3 ok
    if [ $p_sum  = 6 ];then
             echo "check network OK `date +%T`" 2>&1  >>$log
             ssh_login ssh $SGG_a $SGG_a_passwd 'rm /root/.SGG_a_ETH -rf && ifconfig -a  |grep -v grep |grep -i Ethernet >/root/.SGG_a_ETH' 2>&1 >>/dev/null
             ssh_login ssh $SGG_b $SGG_b_passwd 'rm /root/.SGG_b_ETH -rf && ifconfig -a  |grep -v grep |grep -i Ethernet >/root/.SGG_b_ETH' 2>&1 >>/dev/null 
             ssh_login scp_down $SGG_a $SGG_a_passwd /root/.SGG_a_ETH  .SGG_a_ETH 2>&1 >>/dev/null
             ssh_login scp_down $SGG_b $SGG_b_passwd /root/.SGG_b_ETH  .SGG_b_ETH 2>&1 >>/dev/null
             check_eth_a=$(cat .SGG_a_ETH |awk '{print $5}'|uniq -c |wc -l) 
             check_eth_b=$(cat .SGG_b_ETH |awk '{print $5}'|uniq -c |wc -l) 
             check_eth_x=$[$check_eth_a+$check_eth_b] && rm .SGG_a_ETH .SGG_b_ETH -rf
             #echo $check_eth_x
             #exit
	 case $check_eth_x in
            24|16)
               echo "SGG-GAP-3000 ETH_A=$check_eth_a;ETH_B=$check_eth_b OK `date +%T`" 2>&1 >>$log
              ;;
            28|20|30)
               echo "SPG-GAP-3000 ETH_A=$check_eth_a;ETH_B=$check_eth_b OK `date +%T`" 2>&1 >>$log
              ;;
              *)
               echo "An-unknown-device ETH_A=$check_eth_a;ETH_B=$check_eth_b OK `date +%T`" 2>&1 >>$log
              ;;
            esac 
		 break
           fi 
        echo "check network error `date +%T`" 2>&1 >>$log  >>/dev/null
  done
#______________________________________________________________________________________________________________________________
##^_^ check license_a or license_b ^_^
if [ "$product_type" = "SGG" ];then
     ssh_login scp_down $SGG_a  $SGG_a_passwd /tmp/.think  .a.think 2>&1 >>/dev/null
     ssh_login scp_down $SGG_b  $SGG_b_passwd /tmp/.think  .b.think 2>&1 >>/dev/null
     license_a=`cat .a.think` 2>&1 >>/dev/null 
     license_b=`cat .b.think` 2>&1 >>/dev/null && rm .a.think .b.think -rf 
     if [ "$license_a" = "+" -a "$license_b" = "+" ];then
        echo "SGG License OK `date +%T`" >>$log
       else
        echo "SGG License error `date +%T`" >>$log
      fi
     #______________________________________________________________________________________________________________________________
     ^_^ check gap_a or gap_b ^_^
     ssh_login ssh $SGG_a $SGG_a_passwd 'ps -ef |grep -v grep |grep -i gap$  >/root/.gap_a'  2>&1 >>/dev/null
     ssh_login ssh $SGG_b $SGG_b_passwd 'ps -ef |grep -v grep |grep -i gap$  >/root/.gap_b'  2>&1 >>/dev/null
     ssh_login scp_down $SGG_a $SGG_a_passwd /root/.gap_a  .gap_a  2>&1 >>/dev/null
     ssh_login scp_down $SGG_b $SGG_b_passwd /root/.gap_b  .gap_b  2>&1 >>/dev/null
     gap_a1=`cat .gap_a  |sed -n '1p'|awk '{print $2}'` 2>&1 >>/dev/null
     gap_a2=`cat .gap_a  |sed -n '2p'|awk '{print $2}'` 2>&1 >>/dev/null  
     gap_b1=`cat .gap_b  |sed -n '1p'|awk '{print $2}'` 2>&1 >>/dev/null
     gap_b2=`cat .gap_b  |sed -n '2p'|awk '{print $2}'` 2>&1 >>/dev/null && rm .gap_a .gap_b -rf 
     if [ "$gap_a1" = "" -a "$gap_a2" = "" ];then
            echo "SGG gap_a1/gap_a2 error `date +%T`" >>$log
         else
            echo "SGG gap_a1:$gap_a1/gap_a2:$gap_a2 OK `date +%T`" >>$log
          fi
     if [ "$gap_b1" = "" -a "$gap_b2" = "" ];then
            echo "SGG gap_b1/gap_b2 error `date +%T`" >>$log
         else
            echo "SGG gap_b1:$gap_b1/gap_b2:$gap_b2 OK `date +%T`" >>$log
          fi
   else 
     echo "product_type is XingAn SPG!" >>/dev/null
    fi 
#_______________________________________________________________________________________________________________________________
#^_^ for check PC_A->PC_B(TCP/UDP) ^_^ 
ssh_login ssh $PC_B $PC_B_passwd 'killall /usr/local/bin/iperf'>>/dev/null 
ssh_login ssh $PC_A $PC_A_passwd 'killall /usr/local/bin/iperf'>>/dev/null 
port=$(($port-1))
for ((i=1;i<=$channel;i++)) 
do
   	case $i in
			  1|2|3|4)
			    type=$(($i-1))
				dev_type=eth$type
				send_ip=$i.$i.$i.2
				recv_ip=$i.$i.$i.4
				new_number1=$(($i+$new_number1))
			#if [ $new_number1 -lt 11 ];then 
                                echo "+++++++++++++++new_number1=$new_number1" >>/dev/null
				ssh_login ssh $PC_A $PC_A_passwd 'ifconfig '$dev_type' '$send_ip' netmask 255.255.255.0 up' >>/dev/null
				ssh_login ssh $PC_B $PC_B_passwd 'ifconfig '$dev_type' '$recv_ip' netmask 255.255.255.0 up' >>/dev/null
                             #exit  
			#    else 
                                echo  "This send_ip==$send_ip  recv_ip==$recv_ip ok  " >>/dev/null
                        #       fi
			    #tcp	
				port=$(($port+1))
				ssh_login ssh $PC_B $PC_B_passwd 'rm -rf /root/.server_tcp'$i' && /usr/local/bin/iperf -s -i 1 -p '$port' >>/root/.server_tcp'$i' &' >>/dev/null
				ssh_login ssh $PC_A $PC_A_passwd 'rm -rf /root/.client_tcp'$i' && /usr/local/bin/iperf -c '$recv_ip' -i 1 -p '$port' -t '$data_time' >>/root/.client_tcp'$i' &' >>/dev/null
		            #udp
				port=$(($port+1))
				ssh_login ssh $PC_B $PC_B_passwd 'rm -rf /root/.server_udp'$i' && /usr/local/bin/iperf -s -i 1 -p '$port' -u  >>/root/.server_udp'$i' &' >>/dev/null
				ssh_login ssh $PC_A $PC_A_passwd 'rm -rf /root/.client_udp'$i' && /usr/local/bin/iperf -c '$recv_ip' -i 1 -p '$port' -u -t '$data_time' >>/root/.client_udp'$i' &' >>/dev/null
				;;
			  5|6|7|8)
			    type=$(($i+3))
				dev_type=eth$type
				send_ip=$i.$i.$i.2
				recv_ip=$i.$i.$i.4
                                new_number2=$(($i+$new_number2))
                        #    if [ $new_number2 -lt 27 ];then 
				   echo "+++++++++++++++new_number2=$new_number2" >>/dev/null
				ssh_login ssh $PC_A $PC_A_passwd 'ifconfig '$dev_type' '$send_ip' netmask 255.255.255.0 up' >>/dev/null
				ssh_login ssh $PC_B $PC_B_passwd 'ifconfig '$dev_type' '$recv_ip' netmask 255.255.255.0 up' >>/dev/null
                        #       else 
                                 echo "This send_ip==$send_ip  recv_ip==$recv_ip  ok" >>/dev/null
                        #        fi
			    #tcp	
				port=$(($port+1))
				ssh_login ssh $PC_B $PC_B_passwd 'rm -rf /root/.server_tcp'$i' && /usr/local/bin/iperf -s -i 1 -p '$port' >>/root/.server_tcp'$i' &' >>/dev/null
				ssh_login ssh $PC_A $PC_A_passwd 'rm -rf /root/.client_tcp'$i' && /usr/local/bin/iperf -c '$recv_ip' -i 1 -p '$port' -t '$data_time' >>/root/.client_tcp'$i' &' >>/dev/null
		    	    #udp
				port=$(($port+1))
				ssh_login ssh $PC_B $PC_B_passwd 'rm -rf /root/.server_udp'$i' && /usr/local/bin/iperf -s -i 1 -p '$port' -u >>/root/.server_udp'$i' &' >>/dev/null
				ssh_login ssh $PC_A $PC_A_passwd 'rm -rf /root/.client_udp'$i' && /usr/local/bin/iperf -c '$recv_ip' -i 1 -p '$port' -u -t '$data_time' >>/root/.client_udp'$i' &' >>/dev/null
				;;
	     	esac
#	ssh_login ssh $PC_B $PC_B_passwd 'rm -rf /root/.server_tcp'$i' && /usr/local/bin/iperf -s -i 1 -p '$port' >>/root/.server_tcp'$i' &' >>/dev/null
#	ssh_login ssh $PC_A $PC_A_passwd 'rm -rf /root/.client_tcp'$i' && /usr/local/bin/iperf -c '$recv_ip' -i 1 -p '$port' -t '$data_time' >>/root/.client_tcp'$i' &' >>/dev/null
done
   c1=$(($data_time+5)) && s1=$(($data_time+9)) && s2=$(($s1+3)) && c2=$(($c1+2))
   u1=$(($data_time+5)) && d1=$(($data_time+9)) && d2=$(($s1+2)) && u2=$(($c1+1))
sleep $(($data_time+$delay))
    ssh_login ssh $PC_B $PC_B_passwd 'rm /root/.pid -rf && ps axu|grep -v grep |grep -i iperf  >/root/.pid ' >>/dev/null
    ssh_login scp_down $PC_B $PC_B_passwd /root/.pid /root/.pid  >>/dev/null
	pid=$(cat /root/.pid|awk '{print $2}') && rm  -rf /root/.pid 
    for id in  `echo  $pid` 
      do
         #sleep 0.1
		  ssh_login ssh $PC_B $PC_B_passwd 'kill '$id'' >>/dev/null
       # kill $id
       #echo -e "$id" >>$log
     done	
#for ((i=1;i<=$channel;i++))
#   do
#     ssh_login scp_down $PC_A $PC_A_passwd /root/.client_tcp$i /home   >>/dev/null
#     ssh_login scp_down $PC_B $PC_B_passwd /root/.server_tcp$i /home   >>/dev/null
#	 ssh_login scp_down $PC_A $PC_A_passwd /root/.client_udp$i /home   >>/dev/null
#     ssh_login scp_down $PC_B $PC_B_passwd /root/.server_udp$i /home   >>/dev/null
##sleep 4
#  done
ssh_login scp_down $PC_A $PC_A_passwd /root/.client_*p* /home/   >>/dev/null
ssh_login scp_down $PC_B $PC_B_passwd /root/.server_*p* /home/   >>/dev/null
	     tcp_file1=/home/.client_tcp
	     tcp_file2=/home/.server_tcp
	     udp_file1=/home/.client_udp
	     udp_file2=/home/.server_udp
for ((i=1;i<=$channel;i++))
  do     
case $i in
    1|2|3|4|5|6|7|8)
		number_1=$((30+$i))
                number_2=$(($number_1%2))
                if [[ $number_2 = 0 ]];then
                    se=34
                else
                    se=35
                fi
                #echo $i:$se  >>$log
		#ssh_login scp_down $PC_A $PC_A_passwd /root/.client_tcp* /root/.client_tcp*   >>/dev/null
		# ssh_login scp_down $PC_A $PC_A_passwd /root/.client_tcp$i /home   >>/dev/null
    	        # ssh_login scp_down $PC_B $PC_B_passwd /root/.server_tcp$i /home   >>/dev/null
		# ssh_login scp_down $PC_A $PC_A_passwd /root/.client_udp$i /home   >>/dev/null
    	        # ssh_login scp_down $PC_B $PC_B_passwd /root/.server_udp$i /home   >>/dev/null
         sleep 0.3
		 echo -e  "\033["$se"m_________________________Channel_$i DATE_TCP/UDP _________________________________\033[0m" >>$log  2>&1 
		#DATE_TCP
	    echo  -e "\033["$se"m++++++++++++++++++++++++++TCP+++++++++++++++++++++++\033[0m" >>$log
		 if [[ ! -e $tcp_file1$i ]];then
		    	 #echo "No $tcp_file1$i,error!!!"  >>$log
		    	 echo "NO send tcp_data,error!!!"  >>$log
			 elif [[ ! -s $tcp_file1$i ]];then
		    	 #echo "$tcp_file1$i null,error!!!" >>$log
		    	 echo "Send tcp_data null,error!!!"  >>$log
			  else
				  #echo "send_tcp ok!!!" >>$log 
				  #iperf-3.0.0
				  #cat $tcp_file1$i |sed -n ''"$c1,$c2"'p' >>$log 2>&1 
				  #iperf-2.0.5"
				  tail -n 1 $tcp_file1$i >>$log 2>&1 
				  #cat $tcp_file1$i |wc -l  >>$log 2>&1 
		    fi	     
		 if [[ ! -e $tcp_file2$i ]];then
		    	 #echo "No $tcp_file1$i,error!!!"  >>$log
		    	 echo "No recv data,error!!!"  >>$log
			 elif [[ ! -s $tcp_file2$i ]];then
		    	 #echo "$tcp_file1$i null,error!!!" >>$log
		    	 echo "Recv data null,error!!!"  >>$log
			 else
				 #echo "recv_tcp ok!!!" >>$log  
			     #iperf-3.0.0
				 #cat $tcp_file2$i |sed -n ''"$s1,$s2"'p' >>$log 2>&1  && rm $tcp_file1$i $tcp_file2$i -rf 
			     #iperf-2.0.5
				 tail -n 1 $tcp_file2$i  >>$log 2>&1  && rm $tcp_file1$i $tcp_file2$i -rf 
			fi	
			 rm $tcp_file1$i $tcp_file2$i -rf 
	    #DATE_UDP
	    echo  -e "\033["$se"m++++++++++++++++++++++++++UDP+++++++++++++++++++++++\033[0m" >>$log
		 if [[ ! -e $udp_file1$i ]];then
		    	 #echo "No $udp_file1$i,error!!!"  >>$log
		    	 echo "NO send udp_data,error!!!"  >>$log
			 elif [[ ! -s $udp_file1$i ]];then
		    	 #echo "$udp_file1$i null,error!!!" >>$log
		    	 echo "Send udp_data null,error!!!"  >>$log
			  else 
				 #echo "send_udp ok!!!" >>$log 
			     #iperf-3.0.0
				  #cat $udp_file1$i |sed -n ''"$c1,$c2"'p' >>$log 2>&1 
			     #iperf-2.0.5
				 #cat  $udp_file1$i |grep sec |grep ms    >>$log 2>&1
				 #cat  $udp_file1$i |grep sec |grep ms |grep 0.0-300*   >>$log 2>&1
				 cat  $udp_file1$i |grep sec |tail -n 1    >>$log 2>&1
		    fi	     
		 if [[ ! -e $udp_file2$i ]];then
		    	 #echo "No $udp_file1$i,error!!!"  >>$log
		    	 echo "No recv data,error!!!"  >>$log
			 elif [[ ! -s $udp_file2$i ]];then
		    	 #echo "$udp_file1$i null,error!!!" >>$log
		    	 echo "Recv data null,error!!!"  >>$log
			 else
				 #echo "recv_udp ok!!!" >>$log 
			     #iperf-3.0.0
			     #cat $udp_file2$i |sed -n ''"$d1,$d2"'p' >>$log 2>&1  && rm $udp_file1$i $udp_file2$i -rf 
			     #iperf-2.0.5
			      #tail -n 1 $udp_file2$i   >>$log 2>&1  && rm $udp_file1$i $udp_file2$i -rf 
			      cat  $udp_file2$i |grep sec |tail -n 1 >>$log 2>&1  && rm $udp_file1$i $udp_file2$i -rf 
			fi	     
	    echo  -e "\033["$se"m++++++++++++++++++++++++++++++++++++++++++++++++++++\033[0m" >>$log
			 rm $udp_file1$i $udp_file2$i -rf 
			 ;;
    esac
	 done
       rm -rf /home/.*_*p* >> /dev/null
    echo " reboot A/B " >>$log
    ssh_login ssh $SGG_a $SGG_a_passwd 'reboot' 2>&1 >>/dev/null
    ssh_login ssh $SGG_b $SGG_b_passwd 'reboot' 2>&1 >>/dev/null
done

#exit 0
###check soft or install ###
