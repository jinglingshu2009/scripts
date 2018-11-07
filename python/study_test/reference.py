#!/usr/bin/python
#^_^ coding:utf-8 ^_^
# Filename:reference.py
shoplist=['apple','mango','carrot','banana']
mylist=shoplist
print '##################################'
print shoplist
print '##################################'

del shoplist[0]

print 'mylist=',mylist
print '##################################'
mylist=shoplist[:]
del mylist[0]
print 'shoplist is',shoplist
print 'mylist is',mylist
