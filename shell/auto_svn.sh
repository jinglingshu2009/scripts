#!/bin/bash
# 20170314 svn_linux_
export LANG=zh_CN.UTF-8
svn_ip1=192.168.9.12
svn_ip2=192.168.9.7
svn_name=likun
svn_pwd=123456
log=/var/log/svn.log
bak_svn=/home/svn
case $1 in 
	   day_svn_bak) #day back update svn ....
	      echo `date` update svn ... >>$log
		  svn  update  https://$svn_ip1/svn/TestResources  	$bak_svn/TestResources  --username=$svn_name  --password=$svn_pwd   2>&1  >>$log
		  svn  update  https://$svn_ip1/svn/testlog  	$bak_svn/testlog  --username=$svn_name  --password=$svn_pwd         2>&1  >>$log
		  svn  update  https://$svn_ip1/svn/Newtesttools  	$bak_svn/Newtesttools  --username=$svn_name  --password=$svn_pwd    2>&1  >>$log
		  svn  update  svn://$svn_ip2/NEW_SGG  		$bak_svn/NEW_SGG  --username=$svn_name  --password=$svn_pwd         2>&1  >>$log
		  svn  update  svn://$svn_ip2/NEW_SPG  		$bak_svn/NEW_SPG  --username=$svn_name  --password=$svn_pwd         2>&1  >>$log
		  svn  update  svn://$svn_ip2/EVM_1.0  		$bak_svn/EVM_1.0  --username=$svn_name  --password=$svn_pwd         2>&1  >>$log
		  svn  update  svn://$svn_ip2/Install-package/BOA-100B  		$bak_svn/BOA/Install-package  --username=$svn_name  --password=$svn_pwd   2>&1  >>$log
		  svn  update  svn://$svn_ip2/BOA_LICENSE  		$bak_svn/BOA/BOA_LICENSE  --username=$svn_name  --password=$svn_pwd   2>&1  >>$log
		  svn  update  svn://$svn_ip2/BOA_GAP/  		$bak_svn/BOA/update-package  --username=$svn_name  --password=$svn_pwd   2>&1  >>$log
		  #ftp 192.168.1.12 likun ceshibu ---->192.168.7.101:/home/svn/svnback/QC 21:00
	 	  find $bak_svn/svnback/QC -mtime +1 -name "*.zip" -exec rm -rf {} \; && echo "week_svn_bak rm -rf *.zip(QC) ok"    #>>$log
	      echo "############################################################################################################################" >>$log
	  	;;
	 checkout) #checkout svn .....
	      echo `date` checkout svn ... >>$log
		  svn  checkout  https://$svn_ip1/svn/TestResources   $bak_svn/TestResources  --username=$svn_name  --password=$svn_pwd   2>&1  >>$log
		  svn  checkout  https://$svn_ip1/svn/testlog  	$bak_svn/testlog  --username=$svn_name  --password=$svn_pwd         2>&1  >>$log
		  svn  checkout  https://$svn_ip1/svn/Newtesttools    $bak_svn/Newtesttools  --username=$svn_name  --password=$svn_pwd    2>&1  >>$log
		  svn  checkout  svn://$svn_ip2/NEW_SGG  		$bak_svn/NEW_SGG  --username=$svn_name  --password=$svn_pwd         2>&1  >>$log
		  svn  checkout  svn://$svn_ip2/NEW_SPG  		$bak_svn/NEW_SPG  --username=$svn_name  --password=$svn_pwd         2>&1  >>$log
		  svn  checkout  svn://$svn_ip2/"EVM_1.0"			$bak_svn/"EVM_1.0"  --username=$svn_name  --password=$svn_pwd         2>&1  >>$log
		  svn  checkout  svn://$svn_ip2/Install-package/BOA-100B  		$bak_svn/BOA/Install-package --username=$svn_name  --password=$svn_pwd   2>&1  >>$log
		  svn  checkout  svn://$svn_ip2/BOA_LICENSE  	$bak_svn/BOA/BOA_LICENSE  --username=$svn_name  --password=$svn_pwd   2>&1  >>$log
		  svn  checkout  svn://$svn_ip2/BOA_GAP/  		$bak_svn/BOA/update-package  --username=$svn_name  --password=$svn_pwd   2>&1  >>$log
	      echo "############################################################################################################################" >>$log
	  	;;
          week_svn_bak) #backup svn week ....
	        echo `date` backup svn work=`date +%W`... >>$log
		svnback=/home/svn/svnback
		if [ ! -x /home/svn/svnback ];then
			mkdir $svnback
		  fi
		#cp -aR $bak_svn/NEW_SPG  $bak_svn/NEW_SGG  /home/svn/svnback`date +%Y%m%d`
		_time=`date +%Y%m%d_%W`
		rsync -auv --exclude ".svn" $bak_svn/NEW_SPG   $svnback >>/dev/null && echo "Rsync backup svn  NEW_SPG ok `du -sh $svnback/NEW_SPG|awk '{print $1}'`" >>$log
		rsync -auv --exclude ".svn" $bak_svn/NEW_SGG   $svnback >>/dev/null && echo "Rsync backup svn  NEW_SGG ok `du -sh $svnback/NEW_SGG|awk '{print $1}'`">>$log
		rsync -auv --exclude ".svn" $bak_svn/"EVM_1.0"   $svnback >>/dev/null && echo "Rsync backup svn  EVM_1.0 ok `du -sh $svnback/"EVM_1.0"|awk '{print $1}'`">>$log
		rsync -auv --exclude ".svn" $bak_svn/BOA   $svnback >>/dev/null && echo "Rsync backup svn  BOA ok `du -sh $svnback/BOA|awk '{print $1}'`">>$log
                rsync -auv --exclude ".svn" --exclude "检测工具" $bak_svn/TestResources $svnback >>/dev/null && echo "Rsync backup svn  TestResources ok `du -sh $svnback/TestResources|awk '{print $1}'`" >>$log
                rsync -auv --exclude ".svn" --exclude "QC暂停项目备份" $bak_svn/testlog $svnback >>/dev/null && echo "Rsync backup svn  Testlog ok `du -sh $svnback/testlog|awk '{print $1}'`" >>$log	
	        echo "Backup QC(FTP) ok `du -sh $svnback/QC |awk '{print $1}'`" >>$log	
		tar -zcvf $bak_svn/ZLtest_svnback$_time.tgz  -C /home/svn svnback >>/dev/null && echo "Backup svn  ZLtest_svnback$_time.tgz ok `du -sh  $bak_svn/ZLtest_svnback$_time.tgz|awk '{print $1}'`" >>$log
	 	find $bak_svn -mtime +15 -name "ZLtest_*_*.tgz" -exec rm -rf {} \; && echo "week_svn_bak rm -rf ZLtest_*_*.tgz ok" #>>$log
	 	#find $bak_svn/svnback/QC -mtime +1 -name "*.zip" -exec rm -rf {} \; && echo "week_svn_bak rm -rf *.zip(QC) ok"    #>>$log
	        echo "############################################################################################################################" >>$log
	        ;;
	month_svn_bak) #backup svn mounth ....
	        #echo `date` backup svn mouth=`date +%m`... >>$log
		
		ym=`date +%m" "%Y`
		month_time=`date +%Y%m%d%H%M`
		if [ `date +%d` = `cal $ym|xargs|awk '{print $NF}'` ];then
	        echo `date` backup svn mouth=`date +%m`... >>$log
		svnback=/home/svn/svnback
		if [ ! -x /home/svn/svnback ];then
			mkdir $svnback
		  fi
		#cp -aR $bak_svn/NEW_SPG  $bak_svn/NEW_SGG  /home/svn/svnback`date +%Y%m%d`
		_time=`date +%Y%m%d_%W`
		rsync -auv --exclude ".svn" $bak_svn/NEW_SPG   $svnback >>/dev/null && echo "Rsync backup svn  NEW_SPG ok `du -sh $svnback/NEW_SPG|awk '{print $1}'`" >>$log
		rsync -auv --exclude ".svn" $bak_svn/NEW_SGG   $svnback >>/dev/null && echo "Rsync backup svn  NEW_SGG ok `du -sh $svnback/NEW_SGG|awk '{print $1}'`">>$log
		rsync -auv --exclude ".svn" $bak_svn/"EVM_1.0"   $svnback >>/dev/null && echo "Rsync backup svn  EVM_1.0 ok `du -sh $svnback/"EVM_1.0"|awk '{print $1}'`">>$log
		rsync -auv --exclude ".svn" $bak_svn/BOA   $svnback >>/dev/null && echo "Rsync backup svn  BOA ok `du -sh $svnback/BOA|awk '{print $1}'`">>$log
                rsync -auv --exclude ".svn" --exclude "检测工具" $bak_svn/TestResources $svnback >>/dev/null && echo "Rsync backup svn  TestResources ok `du -sh $svnback/TestResources|awk '{print $1}'`" >>$log
                rsync -auv --exclude ".svn" --exclude "QC暂停项目备份" $bak_svn/testlog $svnback >>/dev/null && echo "Rsync backup svn  Testlog ok `du -sh $svnback/testlog|awk '{print $1}'`" >>$log	
	        echo "Backup QC(FTP) ok `du -sh $svnback/QC |awk '{print $1}'`" >>$log	
			
			tar -zcvf $bak_svn/ZLtest_svnback$month_time.tgz  -C /home/svn svnback >>/dev/null && echo "Backup svn  ZLtest_svnback$month_time.tgz ok	`du -sh  $bak_svn/ZLtest_svnback$month_time.tgz|awk '{print $1}'`" >>$log
	 	find $bak_svn -mtime +63 -name "ZLtest_svnback*.tgz" -exec rm -rf {} \; &&  echo "month_svn_bak rm -rf ZLtest_svnback*.tgz(month) ok" >>$log
	        echo "############################################################################################################################" >>$log
			tail -n 11 $log >>/home/svn/readme
		fi
		;;
     	     *)
	      echo "######################################################################"
	      echo "eg:$0 day_svn_bak     #day update svn ...."
	      echo "eg:$0 checkout        #checkout svn ...."
	      echo "eg:$0 week_svn_bak    #week backup svn ...."
	      echo "eg:$0 month_svn_bak   #month backup svn ...."
	      echo "######################################################################"
	   	;;
  esac 
