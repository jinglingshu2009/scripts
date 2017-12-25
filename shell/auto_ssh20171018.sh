#!/bin/bash
#auto_ssh.sh for Cyber-likun by 20171018
 case $1 in
     ssh)
	expect -c "
        spawn  ssh $2 ;
	expect {
           \"yes/no\" {send \"yes\r\";exp_continue}	
            \"password:\" {send \"$3\r\"; exp_continue} 
			\"Password:\" {send \"$3\r\"; exp_continue} 
            \"root@\" {send \"$4\r exit\r\"; exp_continue} 
	} 
	" >>/tmp/.ssh_tmp
     _wc=`wc -l /tmp/.ssh_tmp|awk '{print $1}'`
	 _choic=`tail -n 1  /tmp/.ssh_tmp|grep -wq "exit" && echo "yes" ||echo "no"`
	 if [ "$_wc" -lt "5" ];then
       rm -rf /tmp/.ssh_tmp && exit
	 elif [ "$_choic" == "yes" ];then
		 sed -n '5,'$(($_wc-5))'p' /tmp/.ssh_tmp  && rm -rf /tmp/.ssh_tmp
		 echo $_choic
	 else
		 sed -n '5,'$(($_wc-3))'p' /tmp/.ssh_tmp  && rm -rf /tmp/.ssh_tmp
	     fi
	#" |sed -n "5p" 
        ;; 
     scp_down) 
	expect -c "
        spawn   scp root@$2:$4  $5 
	expect {
            \"yes/no\" {send \"yes\r\"; exp_continue}
			\"password:\" {send \"$3\r\"; exp_continue}
			\"Password:\" {send \"$3\r\"; exp_continue} 			
	}
     " >>/dev/null
         ;; 
     scp_up) 
	expect -c "
        spawn   scp $4 root@$2:$5   
	expect {
            \"yes/no\" {send \"yes\r\"; exp_continue}
			\"password:\" {send \"$3\r\"; exp_continue} 
			\"Password:\" {send \"$3\r\"; exp_continue} 
	}
     " >>/dev/null
         ;; 
	  *)
	echo "eg:$0 1:ssh 2:x.x.x.x 3:pwd 4:'Command && Command'; 0=ok,1=error; "
	echo "eg:$0 1:scp_down 2:x.x.x.x 3:pwd 4:src_down_file 5:local_down_file; 0=ok,1=error; "
	echo "eg:$0 1:scp_up 2:x.x.x.x 3:pwd 4:local_up_file 5:up_dir; 0=ok,1=error; "
         ;;
esac
