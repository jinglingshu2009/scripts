#!/bin/python
#^_^ coding:utf-8 ^_^
#自动生产指定大小文件脚本
#20180423 likun v1.0.0.0
#文件类型（TXT\DOC\随机）

python -V            
'''
file_type="txt,xml"
file_size="9kB"
file_num=100
for num in range(file_num+1):

    _list=file_type.split(",")
    for file_type_num in range(len(_list)):
        file_name ="%s-%s.%s" % (num,file_type_num,_list[file_type_num])
        tmp_unit=file_size[-2].upper()  
        if tmp_unit == "K":
            tmp_size=file_size.upper().split(tmp_unit)[0]
            K_size="CBXA"*256*int(tmp_size)
            with open(file_name,"w") as f:
                f.write(K_size)
                f.close()
        elif tmp_unit == "M":
            tmp_size=file_size.upper().split(tmp_unit)[0]
            M_size=1024*1024*int(tmp_size)
            fp = open(file_name,"w")
            fp.truncate(M_size) 
            fp.close()
        elif tmp_unit == "G":
            tmp_size=file_size.upper().split(tmp_unit)[0]
            G_size=1024*1024*1024*int(tmp_size)
            fp = open(file_name,"w")
            fp.truncate(G_size)
            fp.close()
    print num,file_size.upper().split(tmp_unit)[0],tmp_unit,file_name
'''
    
