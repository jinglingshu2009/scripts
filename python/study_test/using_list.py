#!/usr/bin/python
#^_^ coding:utf-8 ^_^
# Filename:using_list.py
def print_1():
    print '#########################'
shoplist=['apple','mango','carrot','banana']
print 'I have', len(shoplist),'items to purchase.'
print_1()
print 'These item sare:',
for item in shoplist:
    print item,
print '\n I also have to buy rice.' #使用\n表示另起行
print_1()
shoplist.append('rice') #使用append向shoplist列表中添加rice
print 'My shopping list is now',shoplist
print_1()
shoplist.sort() #使用sort对shoplist进行排序
print 'Sorted shopping list is',shoplist
print_1()
print 'The first item ,I will buy is',shoplist[0]  #print打印显示shoplist列表的第一个项目
oleitem=shoplist[0]  #将shoplist第一个项目传递给oleitem变量
print_1()
del shoplist[0] #删除shoplist列表中的第一项目
print 'oleitem=',oleitem
print 'shoplist=',shoplist
