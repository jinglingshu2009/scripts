#!/usr/bin/python
#^_^ coding:utf-8 ^_^
#Filename:get_systeminfo.py


import sys
import os
import wmi
import time
import platform
import psutil
import re
reload(sys)
sys.setdefaultencoding('utf-8')

def check_ip(ipAddr):
    #判断输入地址是否为IPV4
  compile_ip=re.compile('^(1\d{2}|2[0-4]\d|25[0-5]|[1-9]\d|[1-9])\.(1\d{2}|2[0-4]\d|25[0-5]|[1-9]\d|\d)\.(1\d{2}|2[0-4]\d|25[0-5]|[1-9]\d|\d)\.(1\d{2}|2[0-4]\d|25[0-5]|[1-9]\d|\d)$')
  if compile_ip.match(ipAddr):
    return True
  else:
    return False

def SYS_OS():
    c = wmi.WMI()
    _sys_os  = platform.platform();
    for sys in c.Win32_OperatingSystem():
        #print "获取操作系统信息",platform.platform(sys);
        print "SYS_OS:",_sys_os,sys.OSArchitecture.encode("UTF-8");
        # print  sys.OSArchitecture.encode("UTF8")#系统是32位还是64位的
        # print sys.NumberOfProcesses #当前系统运行的进程总数

def SYS_CPU():
    c = wmi.WMI()
    for processor in c.Win32_Processor():
        #获取CPU类型
        # print "Processor ID: %s" % processor.DeviceID
        print u"SYS_CPU: %s" % processor.Name.strip();

def SYS_MEM():
    c = wmi.WMI()
    a=1
    for Memory in c.Win32_PhysicalMemory():
        # 获取内存信息
        print "SYS_MEM%s: %.fMB"% (a,int(Memory.Capacity) / 1048576);
        a=a+1

def SYS_NIC():
    c = wmi.WMI()
    # 获取MAC和IP地址
    #print wmi.WMI().Win32_NetworkAdapterConfiguration(IPEnabled=1)
    z=1
    for interface in c.Win32_NetworkAdapterConfiguration(IPEnabled=1):
        print 'NET%s:%s\n' % (z,interface.Description),'MAC = %s' % (interface.MACAddress)
        b = 1
        for IPAddress in interface.IPAddress:
            if  check_ip(IPAddress):
                print 'IP%s = %s' % (b, IPAddress)
                b = b + 1
        z=z+1
        #print "NIC%s:%s; MAC:%s; IP:%s" % (b,interface.Description,interface.MACAddress,interface.IPAddress);
    #for ip_address in interface.IPAddress:
     #   print "ip_add: %s" % ip_address

def SYS_DISK():
    c = wmi.WMI ()
    #获取硬盘序列号及分区、剩余空间
    for physical_disk in c.Win32_DiskDrive ():
        print "SYS_DISK_ID:",physical_disk.Caption.encode("UTF8");
        for partition in physical_disk.associators ("Win32_DiskDriveToDiskPartition"):
            for logical_disk in partition.associators ("Win32_LogicalDiskToPartition"):
                print partition.Caption.encode("UTF8"), logical_disk.Caption,"%0.2f%% free" % (100.0 * long (logical_disk.FreeSpace) / long (logical_disk.Size));
    #获取硬盘使用百分情况
    #for disk in c.Win32_LogicalDisk (DriveType=3):
     #   print disk.Caption, "%0.2f%% free" % (100.0 * long (disk.FreeSpace) / long (disk.Size))

def sys_disk():
    k=1
    partitions=psutil.disk_partitions()
    #使用fsutil方式获取磁盘信息
    for partitions_list in partitions:
        if partitions_list.fstype == "" :
            partitions_fstype=partitions_list.opts
            disk_total=0
        else:
            partitions_fstype=partitions_list.fstype
            disk_total=psutil.disk_usage(partitions_list.device).total/1048576/1024 
            #disk_total分区总空间大小，单位GB 
            disk_used=psutil.disk_usage(partitions_list.device).used/1048576/1024   
            #disk_used已使用空间大小，单位GB 
            disk_free=psutil.disk_usage(partitions_list.device).free/1048576/1024   
            #disk_free剩余空间大小，单位GB 
            disk_percent=psutil.disk_usage(partitions_list.device).percent          
            #disk_percent磁盘使用率，单位%
            print '分区%s:%s Type:%s total:%sGB used:%sGB   free:%sGB   percent:%s' % (k,partitions_list.device,partitions_fstype,disk_total,disk_used,disk_free,disk_percent)
        k=k+1




#log_file=os.getcwd()+'/get_systeminfo.log'
#output=sys.stdout
#log=open(log_file,'w+')
#sys.stdout=log
#SYS_OS()
#SYS_CPU()
#SYS_MEM()
#SYS_NIC()
#SYS_DISK()
sys_disk()
time.sleep(2)
#log.close()
#sys.stdout=output
#SYS_NIC()
