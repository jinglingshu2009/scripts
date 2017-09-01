#!/bin/bash
path1=/usr/soft
path2=/root/scripts
path3=/data/mysql
path4=/usr/local/mysql
if [ ! -d "$path1" ]; then
mkdir -p "$path1"
fi

if [ ! -d "path2" ]; then
mkdir -p "$path2"
fi

if [ ! -d "$path3" ]; then
mkdir -p "$path3"
fi

if [ ! -d "$path4" ]; then
mkdir -p "$path4"
fi
#安装apache初始环境
yum -y install gcc gcc-c++ automake libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel l
ibxml2 libxml2-devel zlib zlib-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e
2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel openldap openldap-devel nss_ldap
openldap-clients openldap-servers pcre pcre-devel
tar xf httpd-2.4.3.tar.gz
cd $path1
wget http://labs.mop.com/apache-mirror//apr/apr-1.4.6.tar.gz
tar xf apr-1.4.6.tar.gz
cd apr-1.4.6
./configure
make && make install

cd $path1
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.31.tar.gz
tar xf pcre-8.31.tar.gz
cd pcre-8.31
./configure --with-apr=/usr/local/apr
make && make install

cd $path1
wget http://labs.mop.com/apache-mirror//apr/apr-util-1.5.1.tar.gz
tar xf apr-util-1.5.1.tar.gz
cd apr-util-1.5.1
./configure --with-apr=/usr/local/apr
make && make install


cd $path1
wget http://labs.mop.com/apache-mirror//httpd/httpd-2.4.3.tar.gz
tar xf httpd-2.4.3.tar.gz
cd httpd-2.4.3
#配置安装环境
./configure --prefix=/usr/local/apache/ --enable-modules=most --enable-mods-shared=most -enable-suexec --enable-rewrite --enable-so
#安装apache
make && make install
#启动apache
/usr/local/apache/bin/apachectl start

#安装mysql

yum install gcc gcc-c++ autoconf bison automake zlib* flex* libxml* ncurses-devel libtool-ltdl-devel* cmake make -y
groupadd mysql
useradd mysql -M -g mysql -s /sbin/nologin
cd $path1
wget http://cdn.mysql.com/Downloads/MySQL-5.5/mysql-5.5.28.tar.gz
tar xf mysql-5.5.28.tar.gz
cd mysql-5.5.28
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_UNIX_ADDR=/data/mysql/mysql.sock \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_EXTRA_CHARSETS:STRING=utf8,gbk \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DENABLED_LOCAL_INFILE=1 \
-DMYSQL_DATADIR=/data/mysql/ \
-DMYSQL_USER=mysql \
-DMYSQL_TCP_PORT=3306
make && make install
cd $path4
chown mysql.mysql -R .
chown mysql.mysql -R $path3
cp support-files/my-large.cnf /etc/my.cnf 

#初始化mysql
/usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/data/mysql --user=mysql --no-defaults
cp support-files/mysql.server /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig mysqld on
service mysqld start
ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql
#/usr/local/mysql/bin/mysqladmin -u root password '123456'

#安装php

yum install libtool-ltdl-devel net-snmp* curl-devel -y
cd $path1
wget http://sourceforge.net/projects/mcrypt/files/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz/download
tar xf libmcrypt-2.5.8.tar.gz 
cd libmcrypt-2.5.8
./configure
make && make install

#安装mhash
cd $path1
wget http://sourceforge.net/projects/mhash/files/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz/download
tar xf mhash-0.9.9.9.tar.gz
cd mhash-0.9.9.9
./configure
make && make install
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

cd $path1
#安装libmcrypt
wget http://sourceforge.net/projects/mcrypt/files/MCrypt/2.6.8/mcrypt-2.6.8.tar.gz/download
tar xf mcrypt-2.6.8.tar.gz
cd mcrypt-2.6.8
./configure
make && make install

cd $path1
wget http://php.net/get/php-5.4.9.tar.gz/from/cn2.php.net/mirror
#解压
tar xf php-5.4.9.tar.gz
#进入http解压目录
cd php-5.4.9

配置安装环境
./configure --prefix=/usr/local/php --with-mysql=/usr/local/mysql\
--with-mysqli=/usr/local/mysql/bin/mysql_config\
--with-pdo-mysql=/usr/local/mysql\
--with-apxs2=/usr/local/apache/bin/apxs --enable-zip\
--enable-sqlite-utf8 --enable-sockets --enable-soap\
--enable-pcntl --enable-mbstring --enable-calendar\
--enable-bcmath --enable-exif --with-mhash\
--with-gd --with-png-dir --with-jpeg-dir --with-freetype-dir\
--with-libxml-dir --with-curl --with-curlwrappers --with-zlib\
--with-gettext=shared --with-xmlrpc=shared --with-iconv\
--with-snmp --enable-gd-native-ttf --disable-debug --with-mcrypt

#安装php
make && make install

exit 


#####################
#
#
##!/bin/bash
#path1=/usr/soft
#path2=/etc/zabbix
#
#if [ ! -d "$path1" ]; then
#mkdir -p "$path1"
#fi
#
#if [ ! -d "$path2" ]; then
#mkdir -p "$path2"
#fi
#
#yum install mysql-devel mysql-server curl curl-devel net-snmp perl-DBI gcc net-snmp-devel curl-devel perl-DBI
#php-gd php-mysql php-bcmath php-mbstring php-xml
#
#groupadd zabbix
#useradd -g zabbix -M zabbix
#
#cd $path1
#wget http://www.zabbix.com/downloads/2.0.0/zabbix_agents_2.0.0.linux2_6.amd64.tar.gz
#wget http://nchc.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.0.2/zabbix-2.0.2.tar.gz
#tar xf zabbix-2.0.2.tar.gz
#cd zabbix-2.0.2
#./configure --with-mysql --with-net-snmp --with-libcurl --enable-server --enable-agent --enable-proxy --prefix=
#/usr/local/zabbix
#make && make install
#cd /usr/local/zabbix/sbin/
#./zabbix_server
#./zabbix_agent
#./zabbix_proxy
#[root@zabbix ~]# cat zabbix.sh 
##!/bin/bash
#path1=/usr/soft
#path2=/etc/zabbix
#
#if [ ! -d "$path1" ]; then
#mkdir -p "$path1"
#fi
#
#if [ ! -d "$path2" ]; then
#mkdir -p "$path2"
#fi
#
#yum install mysql-devel mysql-server curl curl-devel net-snmp perl-DBI gcc net-snmp-devel curl-devel perl-DBI php-gd php-mysql php-bcmath php-mbstring php-xml
#
#groupadd zabbix
#useradd -g zabbix -M zabbix
#
#cd $path1
#wget http://www.zabbix.com/downloads/2.0.0/zabbix_agents_2.0.0.linux2_6.amd64.tar.gz
#wget http://nchc.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.0.2/zabbix-2.0.2.tar.gz 
#tar xf zabbix-2.0.2.tar.gz
#cd zabbix-2.0.2
#./configure --with-mysql --with-net-snmp --with-libcurl --enable-server --enable-agent --enable-proxy --prefix=/usr/local/zabbix
#make && make install
#cd /usr/local/zabbix/sbin/
#./zabbix_server 
#./zabbix_agent
#./zabbix_proxy 
#cd $path1
#cd frontends/
#mv php/ /data/html/zabbix
#chown -R zabbix:zabbix /data/html/zabbix
#
#
#cat >>/etc/services<<EOF
#zabbix-agent 10050/tcp Zabbix Agent
#zabbix-agent 10050/udp Zabbix Agent
#zabbix-trapper 10051/tcp Zabbix Trapper
#zabbix-trapper 10051/udp Zabbix Trapper
#EOF
#cd $path1
#
##连接mysql并建立数据库授权
##create database zabbix character set utf8;
##grant ALL on zabbix.* to zabbix@'%' identified by '123456';
##flush privileges;
#cd $path1
#cd database/mysql/
#mysql -h localhost -uroot -p'123456' zabbix <schema.sql
#mysql -h localhost -uroot -p'123456' zabbix <images.sql
#mysql -h localhost -uroot -p'123456' zabbix <data.sql
exit
