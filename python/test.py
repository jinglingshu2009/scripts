#!/usr/bin/python
#^_^ coding:utf-8 ^_^
#Filename:get_systeminfo.py
import psutil
def PrintNetIfAddr():
    dic = psutil.net_if_addrs()
    for adapter in dic:
        snicList = dic[adapter]
        mac = '无 mac 地址'
        ipv4 = '无 ipv4 地址'
        ipv6 = '无 ipv6 地址'
        for snic in snicList:
           # print snic[0]
            if  -1 == snic[0]:
                mac = snic.address
            elif 2 == snic[0]:
                ipv4 = snic.address
            elif 23 == snic[0]:
                ipv6 = snic.address
        #print('%s, %s, %s, %s' % (adapter, mac, ipv4, ipv6))
        print '%s, %s, %s, %s' % (adapter, mac, ipv4, ipv6)


PrintNetIfAddr()