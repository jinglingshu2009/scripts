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
scripts = "ceshi.bat"

for id in range (1):
    script = scripts.split()[id]
    script_name = os.path.dirname(os.path.realpath(__file__)) + os.sep + os.path.basename(script)
    # 获取脚本全路径+名称
    exe_script = script_name.split(".")[0] + "_X." + script_name.split(".")[1]
    # 获取移除注视后的可执行文件名称
    if os.path.exists(exe_script) :
        # 判断可执行脚本是否存在，若存在先删除可执行脚本
        os.remove(exe_script)
    script_type =  os.path.basename(script).split(".")[1]
    # 获取脚本后缀类型名称（bat、pyt、sh）
    if script_type == "bat" :
        # 判断脚本后缀为bat
        sn = 0
        for line in open (script_name):
            # 逐行读取文件
            if  line[:20].lstrip()[:3].upper() != "REM" :
                # 逐行判断移除空格后的前3个字符转换为大写后不等于“REM”
                if line[:20].lstrip()[:2].upper() != "::"   :
                    # 逐行判断移除空格后的前2个字符转换为大写后不等于“REM”
                    with open(exe_script,'a') as f:
                        # 打开文件exe_script并逐行追加写入
                        f.write(line)
                        f.close()
    elif script_type == "sh" :
        print(id,"This is bash script.")
    elif script_type == "py" :
        print(id,"This is python script.")
