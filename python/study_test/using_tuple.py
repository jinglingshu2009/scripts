#!/usr/bin/python
#^_^ coding:utf-8 ^_^
# Filename:using_tuple.py0
zoo=('wolf','elephant','penguin')
print 'Number of an imals in the zoo is',len(zoo) #使用len(zoo)获取zoo元组中项目数

new_zoo=('monkey','dolphin',zoo)
print 'Number of an isals in the new zoo is',len(new_zoo)#使用len(zoo)获取zoo元组中项目数

print 'zoo=',zoo #打印zoo元组的所有项目
print 'new_zoo=',new_zoo #打印new_zoo元组的所有项目
print '####################'
print 'new_zoo[2]=',new_zoo[2]#打印new_zoo元组中第三个项目,元组项目等同数列，从0开始
print '####################'
print 'new_zoo[2][2]=',new_zoo[2][2]#打印new_zoo元组中第三个项目的第三个项目

