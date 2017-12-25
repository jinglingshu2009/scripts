#!/bin/bash
#set -x 
#useradd user
#smbpasswd -a passwd  #添加samba用户名及密码
 dr="/root/rsync_file"    
  if [ ! -d $dr ]; then   
          mkdir $dr    
         fi
 srt="$dr/src"     #制造或拷贝同步文件的源目录
 dst="$dr/smb" 	   #samba共享父附录
 nfsdst="$dr/nfs"  #NFS共享父附录
 number=35         #创建smb共享目录的数目
 number_nfs=35     #创建nfs共享目录的数目
number_1=$[$number+1] 
number_nfs_1=$[$number_nfs+1] 
case "$1" in
   1)
    server_samba=`rpm -qa |grep samba`
	samba_conf="/etc/samba/smb.conf"
	if  [ ! -z "$server_samba" ] && [ ! -e $samba_conf ]; then     #判断samba服务和配置是否存在，没安装将给出提示
         echo "The samba service is not installed, install after the implementation of this operation" && exit   
         fi 
	if [ ! -d $dst ]; then     #判断目录是否存在，不存将创建
          mkdir $dst    
         fi 
	dst="$dst/smb"
	for ((i=1;i<$number_1;i++));   #循环指定次数建立共享目录
      do 
      if [ ! -d $dst$i ]; then     #判断目录是否存在，不存将创建
          mkdir $dst$i    && chmod 777 -R $dst$i
         fi 
         if [ $i == 1 ]; then
          # sed -i  's/security = user/security = share/g'  /etc/samba/smb.conf 
           echo ""
           fi
	 #cp /root/backup209.sh  $dst$i/smb$i.sh && chmod 777 -R $dst$i 
      echo -e "[waismb$i] \n path = $dst$i  \n writeable = yes \n browseable = yes \n public = yes \n"  >>/etc/samba/smb.conf  
	#rm -rf  $dst$i/*
    #	ls $dst$i/
     done 
	service smb restart >>/dev/null 2>&1  
  	;;
  2) #copy $srt --> $dst #将源目录中的文件拷贝到对应的共享目录中
        echo "" 
	dst="$dst/smb"
	for ((i=1;i<$number_1;i++));
      do 
      if [ ! -d $dst$i ]; then
          mkdir $dst$i    
         fi 
      cp $srt/*  $dst$i/  && chmod 777 -R $dst$i 
      #rm -rf  $dst$i/*
    	echo  -e "########### copy  $srt ---> $dst$i #############\n"
     done 
	;;   
   3) #delete  $dst/    #将共享目录中的文件删除
   dst="$dst/smb"
	for ((i=1;i<$number_1;i++));
      do 
      if [ ! -d $dst$i ]; then
          mkdir $dst$i    
         fi 
      rm -rf  $dst$i/*
    	echo  -e "########### delete   $dst$i #############\n"
     done 
	;;  
    4) # Show SMB directory file #查看共享目录中的文件个数
	dst="$dst/smb"
    for ((i=1;i<$number_1;i++));   
      do 
      if [ ! -d $dst$i ]; then
          mkdir $dst$i    
         fi 
        number=`find $dst$i  -type f |wc -l` && echo  -e "###########The [waismb$i] directory in the $number file #############\n"	
     done 
	;;   
    5) #Move  $srt/file --> $dst/file #将源目录中的文件copy到目的目录并重新以随机值重命名
	dst="$dst/smb"
        number_1=$[$number+1]  && cd $srt
	for ((i=1;i<$number_1;i++));
           do 
             ls *  > /tmp/list.list 
              for b  in $(cat /tmp/list.list) 
               do	
                 n=`date +%N` && a=` echo $b |awk -F. '{print $1}'` && extension=` echo $b |awk -F. '{print $2}'`
        	 cp $srt/$b $dst$i/$a$n.$extension && echo  -e "########### move $srt/$b   $dst$i/$a$n.$extension  #############\n"
               done 
           done
	;;  
    6) #touch $srt  cont=1k/10k/100k/1M/10M/100M/1G/   #创建指定大小/类型/数目的文件到源目录中，文件填充内容为随机
       	read -p "Please input you need to create the file type,size,number:"  extension size number 
	#echo "$name $extension $size $number" && exit
	 if [ ! -d $srt ]; then
          mkdir $srt    
         fi 
	if [  -n "$extension" ] ;then
             #echo "Parameter input error !!! \n Example: XX TXT 1K 100"
		name="expc_"
                number_1=$[$number+1]
		for ((i=1;i<$number_1;i++));
	      do 
		dd if=/dev/urandom of=$srt/$name$i.$extension  bs=$size  count=1  >>/dev/null 2>&1
	    	echo  -e "########### touch  $srt/$name$i.$extension  #############\n"
	     done 
     	 else
            echo " Parameter input error !!!  Example: ext 1K 100" 
            fi	
	;;  
	7) #touch NFS directory service
	server_nfs=`rpm -qa |grep nfs`
	if [ ! -d $nfsdst ]; then     #判断目录是否存在，不存将创建
          mkdir $nfsdst    
         fi 
	nfsdst="$nfsdst/nfs"
	samba_conf="/etc/exports"
	if  [ ! -z "$server_nfs" ] && [ ! -e $samba_conf ]; then     #判断samba服务和配置是否存在，没安装将给出提示
         echo "The nfs service is not installed, install after the implementation of this operation" && exit   
         fi 
		: > $samba_conf
	for ((i=1;i<$number_nfs_1;i++));   #循环指定次数建立共享目录
      do 
      if [ ! -d $nfsdst$i ]; then     #判断目录是否存在，不存将创建
          mkdir $nfsdst$i     && chmod 777 -R  $nfsdst$i
         fi 
         if [ $i == 1 ]; then
          # sed -i  's/security = user/security = share/g'  /etc/samba/smb.conf 
           echo ""
           fi
	 #cp /root/backup209.sh  $dst$i/smb$i.sh && chmod 777 -R $dst$i 
      echo -e  "$nfsdst$i    *(rw) "  >> $samba_conf 
	#rm -rf  $dst$i/*
    #	ls $dst$i/
     done 
	service rpcbind restart >>/dev/null 2>&1  
  	;;
	 8) # Show NFS directory file #查看共享目录中的文件个数
	 nfsdst="$nfsdst/nfs"
    for ((i=1;i<$number_nfs_1;i++));   
      do 
      if [ ! -d $nfsdst$i ]; then
          mkdir $nfsdst$i    
         fi 
        number=`find $nfsdst$i  -type f |wc -l` && echo  -e "###########The [$nfsdst$i] directory in the $number file #############\n"	
     done 
	;; 
    9) #delete  $nfsdst/    #将共享目录中的文件删除
	nfsdst="$nfsdst/nfs"
	for ((i=1;i<$number_nfs_1;i++));
      do 
      if [ ! -d $nfsdst$i ]; then
          mkdir $nfsdst$i    
         fi 
      rm -rf  $nfsdst$i/*
    	echo  -e "########### delete   $nfsdst$i #############\n"
     done 
	;;  
	10) #copy $srt --> $nfsdst #将NFS源目录中的文件拷贝到对应的共享目录中
	nfsdst="$nfsdst/nfs"
        echo "" 
	for ((i=1;i<$number_nfs_1;i++));
      do 
      if [ ! -d $nfsdst$i ]; then
          mkdir $nfsdst$i    
         fi 
      cp $srt/*  $nfsdst$i/  && chmod 777 -R $nfsdst$i 
      #rm -rf  $dst$i/*
    	echo  -e "########### copy  $srt ---> $nfsdst$i #############\n"
     done 
	;;  
    11) #Move  $srt/file --> $nfsdst/file #将源目录中的文件copy到目的目录并重新以随机值重命名
	nfsdst="$nfsdst/nfs"
        cd $srt
	for ((i=1;i<$number_nfs_1;i++));
           do 
             ls *  > /tmp/list.list 
              for b  in $(cat /tmp/list.list) 
               do	
                 n=`date +%N` && a=` echo $b |awk -F. '{print $1}'` && extension=` echo $b |awk -F. '{print $2}'`
        	 cp $srt/$b $nfsdst$i/$a$n.$extension && echo  -e "########### move $srt/$b   $nfsdst$i/$a$n.$extension  #############\n"
               done 
           done
	;;  	
  *)
          echo "Parameter input error, please see the help or sample"
          echo "eg: $0  1  touch SMB directory service "
          echo "eg: $0  2  Copy  \"$srt --> $dst/smb$i\" directory file "
	  echo "eg: $0  3  Delete \"$dst/smb$i\" directory file "
          echo "eg: $0  4  Show SMB directory file "
          echo "eg: $0  5  Move  \"$srt --> $dst/smb$i\" directory file"
          echo "eg: $0  6  touch  cont=1k/10k/100k/1M/10M/100M/1G/ file"
	  echo "eg: $0  7  touch NFS directory service "
	  echo "eg: $0  8  Show NFS directory file "
	  echo "eg: $0  9  Delete \"$nfsdst/nfs$i/\" directory file "   
          echo "eg: $0  10 Copy  \"$srt --> $nfsdst/nfs$i\" directory file "  	
          echo "eg: $0  11 Move  \"$srt --> $nfsdst/nfs$i\" directory file "  		  
       ;;
esac
     
     
