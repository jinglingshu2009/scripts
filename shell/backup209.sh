#!/bin/bash
#set -x
export LANG="zh_CN.GB2312"
time2=`date +%F%A%T`
time=`date +%w`
time1=`date +%Y-%m-%d`
time3=`date +%T`
back_log="/home/backup.log"
#echo "^_^### $time1  backup_log ###^_^"  >>$back_log
case "$1" in
	1) #SVN235 backup  20131218
		src_235="/home/backup/SVN235_software/svn"  && dst_235="/home/backup/SVN235_software/svn$time-bak"
		if [ ! -d "$dst_235" ]; then 
			 mkdir  $dst_235
		   fi
		src_235back=`find $src_235  -type f |wc -l` && dst_235back=`find $dst_235  -type f |wc -l`
		backup_235=$[$src_235back-$dst_235back]
		#echo $file_dst  $file_sst  $time  $file_up
		 if  [ $src_235back == $dst_235back ]; then
			   echo  "$time3  SVN235两个目录文件数目相一致,不执行同步任务"   >>  $back_log
			else
				rsync  -avz   $src_235/*  $dst_235/ >> /dev/null &&  sleep 10
				src_235check=`find $src_235  -type f |wc -l` && dst_235check=`find $dst_235  -type f |wc -l`
				if [ $src_235check == $dst_235check ];then
						echo "$time3  $src_235 -> $dst_235 更新成功,共更新文件$backup_235个"  >> $back_log   
				  else
						echo  " $src_235 -> $dst_235 更新任务执行失败 !!!"  >> $back_log  
						echo "错误警告SVN235备份任务 $time3执行失败！！！请检查软件SVN服务器235备份脚本及目录是否正常，详细错误信息请查看$back_log" | mail -s "错误警告，`date +\%F-\%T` 执行备份任务失败！！！" likun@[192.168.2.199] -c lilong@[192.168.2.199]  
					fi
			fi
		;;
	2) #SVN237 backup  20131218
		#back_log="/home/backup.log "
		src_237="/home/backup/SVN237_resource/Subversion"  && dst_237="/home/backup/SVN237_resource/Subversion$time-bak"
		if [ ! -d "$dst_237" ]; then 
			 mkdir  $dst_237
		   fi
		src_237back=`find $src_237  -type f |wc -l` && dst_237back=`find $dst_237  -type f |wc -l`
		backup_237=$[$src_237back-$dst_237back]
		#echo $file_dst  $file_sst  $time  $file_up
		 if  [ $src_237back == $dst_237back ]; then
				echo  "$time3 SVN237两个目录文件数目相一致,不执行同步任务"   >>  $back_log
			else
				echo  "$time3 SVN237两个目录文件数目不一致,开始执行同步任务。"  >> $back_log rsync  -avz   $src_237/*  $dst_237/ >> /dev/null &&  sleep 10
				src_237check=`find $src_237  -type f |wc -l` && dst_237check=`find $dst_237  -type f |wc -l`
				if [ $src_237check == $dst_237check ];then
						echo "$time3  $src_237 -> $dst_237 更新成功,共更新文件$backup_237个"  >> $back_log   
				  else
						echo  " $src_237 -> $dst_237 更新任务执行失败 !!!"  >> $back_log  
						echo "错误警告SVN237备份任务 $time3执行失败！！！请检查软件SVN服务器237备份脚本及目录是否正常，详细错误信息请查看$back_log" | mail -s "错误警告，`date +\%F-\%T` 执行备任务SVN237失败！！！" likun@[192.168.2.199]  -c lilong@[192.168.2.199] 
					fi
			fi
		;;

	3) #QC236 backup  20131218	
		src_236="/home/backup/QC236/QC236"  && dst_236="/home/backup/QC236/QC236BAK$time1" 
		if [ ! -d "$dst_236" ]; then 
			 mkdir  $dst_236      
		   fi
		src_236back=`find $src_236  -type f |wc -l` && dst_236back=`find $dst_236  -type f |wc -l`
		backup_236=$[$src_236back-$dst_236back]
		  if  [ $src_236back == $dst_236back ]; then
				echo  "$time3 SVN236两个目录文件数目相一致,不执行同步任务"   >>  $back_log
				find  /home/backup/QC236/QC236/ -type f   -ctime 0 -exec rm -rf {} \;  >> /dev/null
				find  /home/backup/QC236/ -type d -name  "QC236BAK20*"   -ctime +30 -exec rm -rf {} \;   >> /dev/null		
			else
				echo  "$time3 SVN236两个目录文件数目不一致,开始执行同步任务。"  >> $back_log 
				cp  $src_236/*.bak $dst_236/ >> /dev/null &&  sleep 10
				src_236check=`find $src_236  -type f |wc -l` && dst_236check=`find $dst_236  -type f |wc -l`
				if [ $src_236check == $dst_236check ];then
			                # 	echo  "`date +\%F-\%T` SVN236两个目录文件数目不一致,开始执行同步任务。"  >> $back_log 
						echo "$time3  $src_236 -> $dst_236 更新成功,共更新文件$backup_236个"  >> $back_log  
						find  /home/backup/QC236/QC236/ -type f   -ctime 0 -exec rm -rf {} \;  >> /dev/null
						find  /home/backup/QC236/ -type d -name  "QC236BAK20*"   -ctime +30 -exec rm -rf {} \;   >> /dev/null		
				  else
						echo  " $src_236 -> $dst_236 更新任务执行失败 !!!"  >> $back_log  
						echo "错误警告QC236备份任务 $time3 执行失败！！！请检查软件QC服务器236备份脚本及目录是否正常，详细错误信息请查看$back_log" | mail -s "错误警告，`date +\%F-\%T` 执行备份任务QC236失败！！！" likun@[192.168.2.199]   
					fi
			fi
			#find  $dst_236  -name  "QC236BAK*"  -mtime +90 -exec rm -rf {} \;
		;;

	4) #Check SVN235 mount SVN235-NFS
		file_dst=`find /home/svnbackup  -type f |wc -l`
		back_log="/home/backupSVN235.log"
		if [ $file_dst == 0 ];then
   		      mount -t nfs 192.168.3.209:/home/backup/SVN235_software /home/svnbackup  >>/dev/null && sleep 10
		      file_dst1=`find /home/svnbackup  -type f |wc -l`
		        if [ $file_dst1 == 0 ];then
		  	        echo  "`date +\%F-\%T` 挂载备份目录失败 !!!"  $back_log  &&  echo "错误警告SVN235挂载备份目录NFS失败！！！ 请检查软件SVN服务器235挂载备份目录/home/backup/SVN235_software是否正常或者请查看$back_log文件" | mail -s "错误警告SVN235挂载备份NFS目录失败！！！" likun@[192.168.2.199]   
         		  else
	     			echo " `date +\%F-\%T` 挂载备份NFS目录成功!!!"   >>  $back_log
		  	        echo "`date +\%F-\%T`  power_on  +ok "  >>/home/sys.log
			   fi     
  		   else
    			echo " `date +\%F-\%T` 挂载备份NFS目录成功!!!"   >>  $back_log 
     		        echo "`date +\%F-\%T`  power_on  +ok "  >>/home/sys.log
	       	    fi
		 ;;

	5) #SVN235 -> SVN209bak backup 
		time=`date +\%F-\%T`
		file_dst1=`find /home/svnbackup  -type f |wc -l`
		back_log="/home/backupSVN235.log"
 		if  [ $file_dst1 == 0 ]; then
			echo  " `date +\%T`  挂载目录不存在，请检查备份目录是否挂载正常 !!!"  >>/home/SVN235-update.log  &&  echo "错误警告SVN235 -> SVN209bak备份任务执行失败，请检查软件SVN服务器235挂载备份目录/home/backup/SVN235_software挂载是否正常，详细请参见$back_log日志文件" | mail -s "错误警告备份任务SVN235 -> SVN209bak执行失败，备份目录不存在！！！" likun@[192.168.2.199]   
  		  else
   			 file_dst=`find /home/svnbackup/svn  -type f |wc -l`
			 file_sst=`find /svn  -type f |wc -l`
			 file_up=$[$file_sst-$file_dst]
			 if  [ $file_sst == $file_dst ]; then
        			  echo  "`date +\%T` 两个目录文件数目相一致,不执行同步任务"   >>  $back_log
       			     else 
         			 echo  "`date +\%F-\%T` 两个目录文件数目不一致,开始执行同步任务。"   >>  $back_log 
	     			 ( rsync  -avzu   /svn/*  /home/svnbackup/svn/ >>/dev/null  && echo " SVN235 -> SVN209bak 更新成功,共更新文件$file_up个 "  >>$back_log  ) || ( echo  " SVN235 -> SVN209bak 更新任务执行失败 !!!"  >> $back_log  &&  echo "错误警告SVN235 -> SVN209bak备份任务 `date +\%T`执行失败！！！ 请检查软件SVN服务器235备份脚本及目录是否正常，详细错误信息请查$back_log" | mail -s "错误警告， `date +\%T`执行备份任务SVN235 -> SVN209bak失败！！！" likun@[192.168.2.199]   )
      			      fi	 	
 		  fi
		;;

	6) # yum 
	#	mypath="/media/CentOS"
        #       if [ ! -x "$myPath"]; then 
        #             echo "没有可使用yum源，请确定已经使用连接网络或者挂载iso镜像正确！！！"   
	#	else 
	#		 	 	
	#		if [ "$#" == "0" ] ;then
	#	 		echo "Error,Plase input Servername!!! "  "eg: sh yum.sh Servername "
	#	       	else
	#	  		yum --disablerepo=\* --enablerepo=c6-media install  $1
	#	      	fi
	#	fi
		 ;;	

	7) # 检测硬盘空间超出罚值发出告警邮件
                 network_duty=`df -h |grep sda3 |awk -F ' ' '{printf $5}' |awk -F % '{printf $1}'`
                 backupdir=`df -h |grep sdb5 |awk -F ' ' '{printf $5}' |awk -F % '{printf $1}'`
                 sambadir=`df -h |grep sdb6 |awk -F ' ' '{printf $5}' |awk -F % '{printf $1}'`
           #     svn235=`df -h |grep sda3 |awk -F ' ' '{printf $5}' |awk -F % '{printf $1}'`
                 if [ $network_duty -gt 85 ];then
                       echo "严重警告,`date +\%T`备份服务器network-duty可用空间已不足85%，请及时处理！！！ " | mail -s "严重警告,`date +\%T`备份服务器network-duty可用空间已不足85%，请及时处理！！！" likun@[192.168.2.199] -c lilong@[192.168.2.199]  
                    fi
                 if [ $backupdir -gt 85 ];then
                       echo "严重警告,`date +\%T`备份服务器backup目录可用空间已不足85%，请及时处理！！！ " | mail -s "严重警告,`date +\%T`备份服务器backup目录可用空间已不足85%，请及时处理！！！" likun@[192.168.2.199] -c lilong@[192.168.2.199] 
                    fi
                 if [ $sambadir -gt 95 ];then
                       echo "严重警告,`date +\%T`共享空间samba-share中可用空间已不足95%，请大家及时登陆\\192.168.3.209\samba-share清理与自己相关且已经没有意义的文件或目录，避免空间的浪费，谢谢合作！！!" | mail -s "严重警告`date +\%T`共享服务器209共享目录可用空间已不足95%，请大家及时清理共享目录中与自己相关的目录或文件，谢谢合作！！！"  ceshi@[192.168.2.199] 
                    fi
                # if [ $svn235 -gt 85 ];then
                #       echo "严重警告,`date +\%T`服务器235可用空间已不足85%，请及时处理！！！ " | mail -s "严重警告,`date +\%T`SVN235服务器可用空间已不足85%，请及时处理！！！" likun@[192.168.2.199]  
                #    fi
                 ;;
	8) #SVN237-->backup209(client)  
				if [ ! -d $dst ];then
				 mkdir $dst
				 fi 
				dst="/home/backup/Subversion237back" 
                number_r=`find $dst  -type f |wc -l`
           rsync -avz  --password-file=/etc/rsyncd.secrets administrator@192.168.3.237::backup237  $dst/  >>/dev/null 2>&1
                number_r2=`find $dst  -type f |wc -l`
               new=$[$number_r2-$number_r]
                if [ $number_r == $number_r2 ];then
                         echo  "####################^_^###############$time1###############^_^####################"   >>  $back_log
						 echo  "`date +\%T` 执行同步任务成功，SVN237-->backup209无文件更新！！！"   >>  $back_log
                else
						 echo  "####################^_^###############$time1###############^_^####################"   >>  $back_log                         
						 echo  "`date +\%T` 执行同步任务成功，SVN237-->backup209共更新$new个文件！！！"   >>  $back_log
				fi
				;;
	9) #SVN235-->backup209(client)
				dst="/home/backup/Subversion235back" 
				if [ ! -d $dst ];then
				 mkdir $dst
				 fi 
                number_r=`find $dst  -type f |wc -l`
           rsync -avz  --password-file=/etc/rsyncd.passwd1  root@192.168.3.235::backup235  $dst/   >>/dev/null 2>&1
                number_r2=`find $dst  -type f |wc -l`
               new=$[$number_r2-$number_r]
                if [ $number_r == $number_r2 ];then
                          echo  "`date +\%T` 执行同步任务成功，SVN235-->backup209无文件更新！！！"   >>  $back_log
                else
                          echo  "`date +\%T` 执行同步任务成功，SVN235-->backup209共更新$new个文件！！！"   >>  $back_log
				fi
				;;
	*)  #错误提示
			echo 	"Parameter input error, please see the help or sample"
			echo	"eg: ./$0  1  SVN235 --> SVN235bak localbackup"
			echo	"eg: ./$0  2  SVN237 --> SVN237 localbackup"
			echo	"eg: ./$0  3  QC236  --> QC236 localbackup"
			echo	"eg: ./$0  4  Check SVN235 mount SVN235-NFS"
			echo	"eg: ./$0  5  SVN235 --> SVN209bak backup"
			echo	"eg: ./$0  6  yum"
			echo	"eg: ./$0  7  检测硬盘空间超出罚值发出告警邮件"
			echo	"eg: ./$0  8  SVN237-->backup209(client)"
			echo	"eg: ./$0  9  SVN235-->backup209(client)"
		;;
			
esac

