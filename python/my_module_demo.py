#!/usr/bin/python
#^_^ coding:utf-8 ^_^
# Filename:my_module_demo.py
import my_module
import sys
print 'Version,',my_module.version
print '__doc__',my_module.sayhi.__doc__
print '###########################'
print 'fil3',my_module.__file__
print 'package',my_module.__package__
print 'sayhi',my_module.sayhi()
print '###########################'
print dir(my_module)
print '###########################'
print dir(sys)
