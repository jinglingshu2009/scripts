#*****************************************************
#This script only for RHEL and SLES linux.
#*****************************************************
#!/bin/bash
#set auto networking
#2013-08-18 23:15
hostname CentOS-test2
ifcfg=$(ifconfig -a |grep  HWaddr |awk '{print $1 }')
ifcfg1=$(ifconfig -a |grep  HWaddr |awk '{print $1 }'|awk 'END {print NR}')
  if [ "$ifcfg1" = " " ]; then 
       echo " Network No Link !!! " >>/home/sys.log
     fi
    for ((i=1;i<=$ifcfg1;i++)) 
       do
          ethx=$(echo $ifcfg |awk -v a=$i '{print $a }')
          ifconfig $ethx 192.168.199.101 netmask 255.255.255.0 up
          ping_1=$(ping -c 3 192.168.100.1 |grep transmitted |awk '{print $4}' )
            if [ "$ping_1" == "0" ] ;then 
                # echo "Ping 192.168.0.1 time out" >>/home/sys.log
                 ifconfig $ethx 192.168.1.222  netmask 255.255.255.0 up
                 ping_2=$(ping -c 3 192.168.1.1 |grep transmitted |awk '{print $4}' )
                     if [ "$ping_2" == "0" ] ;then 
                             # echo "Ping 192.168.1.1 time out" >>/home/sys.log
                             ifconfig $ethx 192.168.3.222 netmask 255.255.255.0 up
                             ping_3=$(ping -c 3 192.168.3.1 |grep transmitted |awk '{print $4}' )
                               if [ "$ping_3" == "0" ] ;then
                                    # echo "ping 192.168.3.1 time out" >>/home/sys.log
                               	    echo "`date +%F-%T`  Network 192.168.3.0/24 error, Set tmpNetwork 192.168.78.209/24 !!!  " >> /home/sys.log
                               	    #echo "Set tmpNetwork 192.168.78.209/24 !!!" >> /home/sys.log
                                   #ifconfig eth0 192.168.78.209 netmask 255.255.255.0 up
                                 else
                                  route add default gw 192.168.3.1 dev  $ethx 
                                  echo "nameserver 192.168.2.104" > /etc/resolv.conf
                               	 # echo "Network 192.168.3.0/24 +ok" >> /home/sys.log
				  exit
                                 fi
                        else  
                         route add default gw 192.168.1.1 dev  $ethx 
                         echo "nameserver 202.106.0.20" > /etc/resolv.conf
                         echo "nameserver 8.8.8.8" >> /etc/resolv.conf
                         #echo "Network 192.168.1.0/24 +ok" >> /home/sys.log
 			 exit 
                        fi
              else
               route add default gw 192.168.0.1 dev  $ethx 
               echo "nameserver 202.106.0.20" > /etc/resolv.conf
               echo "nameserver 8.8.8.8" >> /etc/resolv.conf
               #echo "Network 192.168.0.0/24 +ok" >> /home/sys.log
               exit
              fi
        done
    
