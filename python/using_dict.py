#!/usr/bin/python
#^_^ coding:utf-8 ^_^
# Filename:using_dict.py
ab={'Swaroop':'Swaroop@163.com',
        'Larry':'Larry@163.com',
        'Matsumoto':'Matsumoto@126.com',
        'Spammer':'Spammer@tet.com'
        }
print "Swaroop'saddress is %s"%ab['Swaroop'] #获取字典ab中Swaroop的字典值

ab['Guido']='guido@python.org' #增加了一个新的键/值对

del ab['Spammer'] #del语句来删除键/值对
print 'ab字典中具有字典数目为 %d' %len(ab) #获取字典ab中字典数目
#print ab
for name,address in ab.items():#使用字典items方式获取字典ab中数值
    print '名字：%s,地址：%s'%(name,address)
if 'Guido' in ab:#在字典中查找有关Guido所对应的值
    print "Guido's address is %s"%ab['Guido'] #使用元素打印方式调用Guido的值
