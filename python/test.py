#!/usr/bin/python
#^_^ coding:utf-8 ^_^
#Filename:get_systeminfo.py
import psutil
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

cpu = psutil.cpu_times(percpu=True)
cpu1 = psutil.cpu_times()
#nic = psutil.net_io_counters(pernic=True)
nic = psutil.net_io_counters(pernic=True)
#print nic
K=1
for item_nic in nic :
    print K,item_nic
    K=K+1