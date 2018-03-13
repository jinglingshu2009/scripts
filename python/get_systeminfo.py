#!/usr/bin/python
#^_^ coding:utf-8 ^_^
#Filename:get_systeminfo.py
import sys
import os
import wmi
import time

def SYS_OS():
    c = wmi.WMI()
    for sys in c.Win32_OperatingSystem():
        print "获取操作系统信息"
        print u"SYS_OS:",platform.platfrom(sys),sys.OSArchitecture.encode("UTF-8"),sys.BuildNumber;
        # print  sys.OSArchitecture.encode("UTF8")#系统是32位还是64位的
        # print sys.NumberOfProcesses #当前系统运行的进程总数

def SYS_CPU():
    c = wmi.WMI()
    for processor in c.Win32_Processor():
        #获取CPUL类型
        # print "Processor ID: %s" % processor.DeviceID
        print u"SYS_CPU: %s" % processor.Name.strip();

def SYS_MEM():
    c = wmi.WMI()
    for Memory in c.Win32_PhysicalMemory():
        # 获取内存信息
        print "SYS_MEM: %.fMB" % (int(Memory.Capacity) / 1048576);

def SYS_NIC():
    c = wmi.WMI()
    # 获取MAC和IP地址
    #print wmi.WMI().Win32_NetworkAdapterConfiguration(IPEnabled=1)
    for interface in c.Win32_NetworkAdapterConfiguration(IPEnabled=1):
        print u"NIC:",interface.Description,"MAC:",interface.MACAddress ,"IP: ",interface.IPAddress;
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

    #time.sleep(3)

SYS_OS()
SYS_CPU()
SYS_MEM()
SYS_NIC()
SYS_DISK()
time.sleep(2)

