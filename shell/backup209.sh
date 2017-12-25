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
			   echo  "$time3  SVN235����Ŀ¼�ļ���Ŀ��һ��,��ִ��ͬ������"   >>  $back_log
			else
				rsync  -avz   $src_235/*  $dst_235/ >> /dev/null &&  sleep 10
				src_235check=`find $src_235  -type f |wc -l` && dst_235check=`find $dst_235  -type f |wc -l`
				if [ $src_235check == $dst_235check ];then
						echo "$time3  $src_235 -> $dst_235 ���³ɹ�,�������ļ�$backup_235��"  >> $back_log   
				  else
						echo  " $src_235 -> $dst_235 ��������ִ��ʧ�� !!!"  >> $back_log  
						echo "���󾯸�SVN235�������� $time3ִ��ʧ�ܣ������������SVN������235���ݽű���Ŀ¼�Ƿ���������ϸ������Ϣ��鿴$back_log" | mail -s "���󾯸棬`date +\%F-\%T` ִ�б�������ʧ�ܣ�����" likun@[192.168.2.199] -c lilong@[192.168.2.199]  
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
				echo  "$time3 SVN237����Ŀ¼�ļ���Ŀ��һ��,��ִ��ͬ������"   >>  $back_log
			else
				echo  "$time3 SVN237����Ŀ¼�ļ���Ŀ��һ��,��ʼִ��ͬ������"  >> $back_log rsync  -avz   $src_237/*  $dst_237/ >> /dev/null &&  sleep 10
				src_237check=`find $src_237  -type f |wc -l` && dst_237check=`find $dst_237  -type f |wc -l`
				if [ $src_237check == $dst_237check ];then
						echo "$time3  $src_237 -> $dst_237 ���³ɹ�,�������ļ�$backup_237��"  >> $back_log   
				  else
						echo  " $src_237 -> $dst_237 ��������ִ��ʧ�� !!!"  >> $back_log  
						echo "���󾯸�SVN237�������� $time3ִ��ʧ�ܣ������������SVN������237���ݽű���Ŀ¼�Ƿ���������ϸ������Ϣ��鿴$back_log" | mail -s "���󾯸棬`date +\%F-\%T` ִ�б�����SVN237ʧ�ܣ�����" likun@[192.168.2.199]  -c lilong@[192.168.2.199] 
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
				echo  "$time3 SVN236����Ŀ¼�ļ���Ŀ��һ��,��ִ��ͬ������"   >>  $back_log
				find  /home/backup/QC236/QC236/ -type f   -ctime 0 -exec rm -rf {} \;  >> /dev/null
				find  /home/backup/QC236/ -type d -name  "QC236BAK20*"   -ctime +30 -exec rm -rf {} \;   >> /dev/null		
			else
				echo  "$time3 SVN236����Ŀ¼�ļ���Ŀ��һ��,��ʼִ��ͬ������"  >> $back_log 
				cp  $src_236/*.bak $dst_236/ >> /dev/null &&  sleep 10
				src_236check=`find $src_236  -type f |wc -l` && dst_236check=`find $dst_236  -type f |wc -l`
				if [ $src_236check == $dst_236check ];then
			                # 	echo  "`date +\%F-\%T` SVN236����Ŀ¼�ļ���Ŀ��һ��,��ʼִ��ͬ������"  >> $back_log 
						echo "$time3  $src_236 -> $dst_236 ���³ɹ�,�������ļ�$backup_236��"  >> $back_log  
						find  /home/backup/QC236/QC236/ -type f   -ctime 0 -exec rm -rf {} \;  >> /dev/null
						find  /home/backup/QC236/ -type d -name  "QC236BAK20*"   -ctime +30 -exec rm -rf {} \;   >> /dev/null		
				  else
						echo  " $src_236 -> $dst_236 ��������ִ��ʧ�� !!!"  >> $back_log  
						echo "���󾯸�QC236�������� $time3 ִ��ʧ�ܣ������������QC������236���ݽű���Ŀ¼�Ƿ���������ϸ������Ϣ��鿴$back_log" | mail -s "���󾯸棬`date +\%F-\%T` ִ�б�������QC236ʧ�ܣ�����" likun@[192.168.2.199]   
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
		  	        echo  "`date +\%F-\%T` ���ر���Ŀ¼ʧ�� !!!"  $back_log  &&  echo "���󾯸�SVN235���ر���Ŀ¼NFSʧ�ܣ����� �������SVN������235���ر���Ŀ¼/home/backup/SVN235_software�Ƿ�����������鿴$back_log�ļ�" | mail -s "���󾯸�SVN235���ر���NFSĿ¼ʧ�ܣ�����" likun@[192.168.2.199]   
         		  else
	     			echo " `date +\%F-\%T` ���ر���NFSĿ¼�ɹ�!!!"   >>  $back_log
		  	        echo "`date +\%F-\%T`  power_on  +ok "  >>/home/sys.log
			   fi     
  		   else
    			echo " `date +\%F-\%T` ���ر���NFSĿ¼�ɹ�!!!"   >>  $back_log 
     		        echo "`date +\%F-\%T`  power_on  +ok "  >>/home/sys.log
	       	    fi
		 ;;

	5) #SVN235 -> SVN209bak backup 
		time=`date +\%F-\%T`
		file_dst1=`find /home/svnbackup  -type f |wc -l`
		back_log="/home/backupSVN235.log"
 		if  [ $file_dst1 == 0 ]; then
			echo  " `date +\%T`  ����Ŀ¼�����ڣ����鱸��Ŀ¼�Ƿ�������� !!!"  >>/home/SVN235-update.log  &&  echo "���󾯸�SVN235 -> SVN209bak��������ִ��ʧ�ܣ��������SVN������235���ر���Ŀ¼/home/backup/SVN235_software�����Ƿ���������ϸ��μ�$back_log��־�ļ�" | mail -s "���󾯸汸������SVN235 -> SVN209bakִ��ʧ�ܣ�����Ŀ¼�����ڣ�����" likun@[192.168.2.199]   
  		  else
   			 file_dst=`find /home/svnbackup/svn  -type f |wc -l`
			 file_sst=`find /svn  -type f |wc -l`
			 file_up=$[$file_sst-$file_dst]
			 if  [ $file_sst == $file_dst ]; then
        			  echo  "`date +\%T` ����Ŀ¼�ļ���Ŀ��һ��,��ִ��ͬ������"   >>  $back_log
       			     else 
         			 echo  "`date +\%F-\%T` ����Ŀ¼�ļ���Ŀ��һ��,��ʼִ��ͬ������"   >>  $back_log 
	     			 ( rsync  -avzu   /svn/*  /home/svnbackup/svn/ >>/dev/null  && echo " SVN235 -> SVN209bak ���³ɹ�,�������ļ�$file_up�� "  >>$back_log  ) || ( echo  " SVN235 -> SVN209bak ��������ִ��ʧ�� !!!"  >> $back_log  &&  echo "���󾯸�SVN235 -> SVN209bak�������� `date +\%T`ִ��ʧ�ܣ����� �������SVN������235���ݽű���Ŀ¼�Ƿ���������ϸ������Ϣ���$back_log" | mail -s "���󾯸棬 `date +\%T`ִ�б�������SVN235 -> SVN209bakʧ�ܣ�����" likun@[192.168.2.199]   )
      			      fi	 	
 		  fi
		;;

	6) # yum 
	#	mypath="/media/CentOS"
        #       if [ ! -x "$myPath"]; then 
        #             echo "û�п�ʹ��yumԴ����ȷ���Ѿ�ʹ������������߹���iso������ȷ������"   
	#	else 
	#		 	 	
	#		if [ "$#" == "0" ] ;then
	#	 		echo "Error,Plase input Servername!!! "  "eg: sh yum.sh Servername "
	#	       	else
	#	  		yum --disablerepo=\* --enablerepo=c6-media install  $1
	#	      	fi
	#	fi
		 ;;	

	7) # ���Ӳ�̿ռ䳬����ֵ�����澯�ʼ�
                 network_duty=`df -h |grep sda3 |awk -F ' ' '{printf $5}' |awk -F % '{printf $1}'`
                 backupdir=`df -h |grep sdb5 |awk -F ' ' '{printf $5}' |awk -F % '{printf $1}'`
                 sambadir=`df -h |grep sdb6 |awk -F ' ' '{printf $5}' |awk -F % '{printf $1}'`
           #     svn235=`df -h |grep sda3 |awk -F ' ' '{printf $5}' |awk -F % '{printf $1}'`
                 if [ $network_duty -gt 85 ];then
                       echo "���ؾ���,`date +\%T`���ݷ�����network-duty���ÿռ��Ѳ���85%���뼰ʱ�������� " | mail -s "���ؾ���,`date +\%T`���ݷ�����network-duty���ÿռ��Ѳ���85%���뼰ʱ��������" likun@[192.168.2.199] -c lilong@[192.168.2.199]  
                    fi
                 if [ $backupdir -gt 85 ];then
                       echo "���ؾ���,`date +\%T`���ݷ�����backupĿ¼���ÿռ��Ѳ���85%���뼰ʱ�������� " | mail -s "���ؾ���,`date +\%T`���ݷ�����backupĿ¼���ÿռ��Ѳ���85%���뼰ʱ��������" likun@[192.168.2.199] -c lilong@[192.168.2.199] 
                    fi
                 if [ $sambadir -gt 95 ];then
                       echo "���ؾ���,`date +\%T`����ռ�samba-share�п��ÿռ��Ѳ���95%�����Ҽ�ʱ��½\\192.168.3.209\samba-share�������Լ�������Ѿ�û��������ļ���Ŀ¼������ռ���˷ѣ�лл��������!" | mail -s "���ؾ���`date +\%T`���������209����Ŀ¼���ÿռ��Ѳ���95%�����Ҽ�ʱ������Ŀ¼�����Լ���ص�Ŀ¼���ļ���лл����������"  ceshi@[192.168.2.199] 
                    fi
                # if [ $svn235 -gt 85 ];then
                #       echo "���ؾ���,`date +\%T`������235���ÿռ��Ѳ���85%���뼰ʱ�������� " | mail -s "���ؾ���,`date +\%T`SVN235���������ÿռ��Ѳ���85%���뼰ʱ��������" likun@[192.168.2.199]  
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
						 echo  "`date +\%T` ִ��ͬ������ɹ���SVN237-->backup209���ļ����£�����"   >>  $back_log
                else
						 echo  "####################^_^###############$time1###############^_^####################"   >>  $back_log                         
						 echo  "`date +\%T` ִ��ͬ������ɹ���SVN237-->backup209������$new���ļ�������"   >>  $back_log
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
                          echo  "`date +\%T` ִ��ͬ������ɹ���SVN235-->backup209���ļ����£�����"   >>  $back_log
                else
                          echo  "`date +\%T` ִ��ͬ������ɹ���SVN235-->backup209������$new���ļ�������"   >>  $back_log
				fi
				;;
	*)  #������ʾ
			echo 	"Parameter input error, please see the help or sample"
			echo	"eg: ./$0  1  SVN235 --> SVN235bak localbackup"
			echo	"eg: ./$0  2  SVN237 --> SVN237 localbackup"
			echo	"eg: ./$0  3  QC236  --> QC236 localbackup"
			echo	"eg: ./$0  4  Check SVN235 mount SVN235-NFS"
			echo	"eg: ./$0  5  SVN235 --> SVN209bak backup"
			echo	"eg: ./$0  6  yum"
			echo	"eg: ./$0  7  ���Ӳ�̿ռ䳬����ֵ�����澯�ʼ�"
			echo	"eg: ./$0  8  SVN237-->backup209(client)"
			echo	"eg: ./$0  9  SVN235-->backup209(client)"
		;;
			
esac

