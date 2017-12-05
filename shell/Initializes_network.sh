#!/bin/bash
#Initializes the network
#2016-6-7 CyberXingAn Test
############################################
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
############################################
adjust_network=path
setparameters=xx
eth_6=eth9
eth_7=eth0
md5_aju=xxxx
md5_set=xxxx
the_end=4
ac=ac
bc=bc
############################################
if [ ! -f ".end" ];then
    echo "0" >.end
   fi   
#ping_ck p2 5 $bc 2>&1 >>/dev/null
#  p_bc=$?
#ping_ck p2 5 $ac 2>&1 >>/dev/null
#  p_ac=$?
#p_sum=$(($p_ac+$p_bc))
eth_6=`ethtool $eth_6 |grep Link |awk  '{print $3}'` >>/dev/null
eth_7=`ethtool $eth_7 |grep Link |awk  '{print $3}'`  >>/dev/null
 if [ "$eth_6" = "yes" -a "$eth_7" = "yes"  ];then
    echo  Nic initializes the success   >>.end.log
   elif [ `cat .end` -lt $the_end  ];then
	  end=$((`cat .end`+1))  
	  echo $end > .end
         md5_1=$md5_aju  && md5_2=$md5_set 
         md5_11=` md5sum $adjust_network | awk  '{print $1 }' `
         md5_22=` md5sum $setparameters | awk  '{print $1 }' ` 
	  if [ "$md5_11" = "$md5_1" -a "$md5_22" = "$md5_2"  ];then
              sh $adjust_network >>/dev/null
              sh $setparameters 	 >>/dev/null
             reboot
	     fi 
    fi
