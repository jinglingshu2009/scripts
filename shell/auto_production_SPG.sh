#!/bin/bash
get_sn ( ) {
while [ 1 ]
do
    read -p "Please enter the device SN:"	input_sn
    read -p "Please comfirm the input device $input_sn Y|N:" check_sn
    if [ $check_sn == Y ];then
	    echo input_sn=$input_sn
	    break
    fi
    done


	}
	get_id ( ) {
	# get_id x.x.x.x  get device License ID.
	ssh auto_ssh20171018.sh ssh $1 Cyber@XA#2009 'sh /usr/gap/scripts/getHardID.sh'>/tmp/.get_id
	get_id=`cat /tmp/.get_id|head -n 1 |awk -F% '{print $1}'|tr -d '\r'`
}
	
	get_net ( ) {
	# get_net x.x.x.x  get device	networking info.
	ssh auto_ssh20171018.sh ssh $1 Cyber@XA#2009 'ifconfig -a |grep HWaddr'>/tmp/.get_net
	get_net=`cat /tmp/.get_net|tr -d '\r'`
}

