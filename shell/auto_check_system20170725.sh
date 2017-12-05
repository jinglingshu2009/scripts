#!/bin/bash
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
#####################################################
ip_list="HM65-B"
#ip_list="HM65-A HM65-B"
_passwd=123qwe
#_passwd=Cyber@XA\#2009
_end=100
log=$0.log
ping_num=10
if [ ! -f ".a" ];then
   echo "1" >.a && rm -rf $0.log
   fi
while [ 1 ] 
do 
  while [ 1 ]
	      do 
		#	ping_ck p2 $ping_num D525-A 2>&1 >>/dev/null
		#	p1=$?
		#	ping_ck p2 $ping_num D525-B 2>&1 >>/dev/null
		#	p2=$?
	#		ping_ck p2 $ping_num HM65-A 2>&1 >>/dev/null
	#		p3=$?
			ping_ck p2 $ping_num HM65-B 2>&1 >>/dev/null
			p4=$?
			sun_p=$(($p3+$p4))

		      if [ "$sun_p" == "3" ];then
			      break
			#  else 
			#    echo ID=$_run_number error HM65-A=$p3  HM65-B=$p4 >>$log
			#	break 
                fi				  
			  done
for  _ip_list in  `echo $ip_list`
  do  
   case $_ip_list in 
        D525-A)
			_network=`./auto_ssh.sh ssh $_ip_list $_passwd 'ifconfig -a |grep Ethernet |wc -l'`
		    if [ -z $_network ];then 
			   _name1=`$_ip_list=start error!`
			   break
			 fi
			if [ "$_network" == "10" ];then
			   _name1=`$_ip_list=$_network`
			   ./auto_ssh.sh ssh $_ip_list $_passwd 'reboot'  			
			else 
			   _name1=`$_ip_list=$_network error!`
			  fi
			;;
		D525-B)
			_network=`./auto_ssh.sh ssh $_ip_list $_passwd 'ifconfig -a |grep Ethernet |wc -l'`
			 if [ -z $_network ];then 
			   _name2=`$_ip_list=start error!`
			   break
			  fi
			 if [ "$_network" == "10" ];then
			   _name2=`$_ip_list=$_network`
			   ./auto_ssh.sh ssh $_ip_list $_passwd 'reboot'
			else 
			   _name2=`$_ip_list=$_network error!`
			  fi
			;;
		HM65-A)	
			./auto_ssh.sh ssh $_ip_list $_passwd 'ifconfig -a |grep Ethernet |wc -l >/.tmp' >>/dev/null
			./auto_ssh.sh scp_down $_ip_list $_passwd  /.tmp  /.tmp >>/dev/null
			_network=`cat /.tmp|tr -d '\r'` && rm -rf /.tmp   >>/dev/null
			 if [ -z $_network ];then 
			   _name3=`echo "$_ip_list start error!"`
			   break
			   fi
			  if [ "$_network" == "2" ];then
			   _name3=`echo "$_ip_list=$_network"`
			   ./auto_ssh.sh ssh $_ip_list $_passwd 'reboot'
		           #echo "$_run_number=$_ip_list=$_network ssh reboot ok" >>$log
			else 
			   _name3=`echo "$_ip_list-$_network error!"`
			   fi
			;;		
		HM65-B)
			#_network=`./auto_ssh.sh ssh $_ip_list $_passwd 'ifconfig -a |grep Ethernet |wc -l'`
			#_network=`echo $_network|tr -d '\r'`
			./auto_ssh.sh ssh $_ip_list $_passwd 'ifconfig -a |grep Ethernet |wc -l >/.tmp' >>/dev/null
			./auto_ssh.sh scp_down $_ip_list $_passwd  /.tmp  /.tmp >>/dev/null
			_network=`cat /.tmp|tr -d '\r'` && rm -rf /.tmp 
			 if [ -z $_network ];then 
			   _name4=`echo "$_ip_list start error!"`
			   break
			 fi
			if [ "$_network" == "3" ];then
			   _name4=`echo "$_ip_list=$_network"`
			  ./auto_ssh.sh ssh $_ip_list $_passwd 'reboot'
		          #echo "$_run_number=$_ip_list=$_network ssh reboot ok" >>$log
			else 
			   _name4=`echo "$_ip_list=$_network error!"`
			   fi
			;;
	esac
done
 _run_number=`cat .a|tr -d '\r'`
    if [ $_run_number != $_end ];then
	echo ID=$_run_number ping_all=$sun_p $_name1 $_name2 $_name3 $_name4   >>$log
        echo $(($_run_number+1))>.a			
	 else
		echo ID=$_run_number=$_end >>$log
		for _ip_list in  `echo $ip_list`
		  do
		#echo "ID=$_end ssh shutdown -h now" >>$log
		./auto_ssh.sh ssh $_ip_list $_passwd 'shutdown -h now'
		done
		exit
	 fi
done 
