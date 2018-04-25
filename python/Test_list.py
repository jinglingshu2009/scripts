#!/usr/bin/python
#^_^ coding:utf-8 ^_^
# Filename:Test_list.py
file_name=""
file_type  = "exe,doc,rar,docx,xls,txt,bin,tar,gif,bmp,img"
type_list=file_type.split(",")
for file_type in range(len(type_list)):
    print "%s %s%s.%s " % (file_type,file_name,file_type,type_list[file_type])
