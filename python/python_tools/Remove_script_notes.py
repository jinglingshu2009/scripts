#!/bin/python
#-*- coding:utf-8 -*-
"""
时间：2018-11-04 22:02:23
作者：likun by  LK_SOFT
版本：V1.0.0.0
作用：
    移除python、shell、bat脚本中的注释行，生成新的可执行脚本 script_X；
    使用方法  Remove_script_notes.py  [python|shell|bat] scripts.
"""
import os
import sys

# script = sys.argv[1]
# 获取第2个位移变量(第1个参数)，sys.argv[0]:脚本自身名称
scripts = "D:\\test\Auto_file_copy_old1.bat"

for id in range (1):
    script = scripts.split()[id]
    script_name = os.path.dirname(os.path.realpath(__file__)) + os.sep + os.path.basename(script)
    # 获取脚本全路径+名称
    script_type =  os.path.basename(script).split(".")[1]
    # 获取脚本后缀类型名称
    if script_type == "bat" :
     # 处理bat脚本中"REM"注释
        sn = 0

        for line in open (script,'rb'):
            sn += 1
            print(sn, line.find("::", 0, len(line)),line)
            #print(sn, line.find('REM'))
            if line.find('::') == -1:
                pass
                with open("D:\\test\Auto_file_copy-old_X.bat", "a") as f:
                   f.write(line)
        print(id,"This is bat script.",script)
    elif script_type == "sh" :
        print(id,"This is bash script.")
    elif script_type == "py" :
        print(id,"This is python script.")
