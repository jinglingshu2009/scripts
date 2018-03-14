#!/usr/bin/python
#^_^ coding:utf-8 ^_^
# Filename:file.py
import os
import time
cwd=os.getcowd()
file=cwd+'/file.log'
print(file);
time.sleep(2)
f=open(file,'a+')
f_read=f.read(cwd+'/get_systeminfo.py')
print(f_read)
print "read=-----read"
f.close()
time.sleep(5)
