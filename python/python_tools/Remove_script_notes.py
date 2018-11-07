#!/bin/python
#-*- coding:utf-8 -*-
"""
名称：Remove_script_notes.py（移除bat/py/sh脚本中注释行）
时间：2018-11-04 22:02:23
作者：likun by  LK_SOFT
版本：V1.0.0.0
作用：
    移除python、shell、bat脚本中的注释行，生成新的可执行脚本 script_X；
    使用方法  Remove_script_notes.py  [python|shell|bat] scripts.
"""
import os
import sys
if len(sys.argv) != 2:
    # 判断输入参数是否有效，无效给予提示并退出。
    print(sys.argv[0]+" "*3+"[python|shell|bat]scripts")
    exit(0)
script = sys.argv[1]
# 获取第2个位移变量(第1个参数)，sys.argv[0]:脚本自身名称
#script = "Remove_script_notes.py"

script_name = os.path.dirname(os.path.realpath(__file__)) + os.sep + os.path.basename(script)
# 获取脚本全路径+名称
exe_script = script_name.split(".")[0] + "_X." + script_name.split(".")[1]
# 获取移除注视后的可执行文件名称
if os.path.exists(exe_script) :
    # 判断可执行脚本是否存在，若存在先删除可执行脚本
    os.remove(exe_script)
script_type =  os.path.basename(script).split(".")[1]
# 获取脚本后缀类型名称（bat、pyt、sh）
sn = 0
if script_type == "bat" :
    # 判断脚本后缀为bat

    for line in open (script_name):
        # 逐行读取文件
        if  line[:40].lstrip()[:3].upper() != "REM" :
            # 逐行判断移除空格后的前3个字符转换为大写后不等于“REM”
            if line[:40].lstrip()[:2].upper() != "::"   :
                # 逐行判断移除空格后的前2个字符转换为大写后不等于“REM”
                with open(exe_script,'a') as f:
                    # 打开文件exe_script并逐行追加写入
                    f.write(line)
                    f.close()
elif script_type == "sh" or script_type == "py":
    for line in open (script_name,encoding="UTF-8"):
        # 逐行读取文件
        sn = 1 + sn
        if sn <= 4:
            # 打开文件exe_script前4行并逐行追加写入
            with open(exe_script, 'a') as f:
                f.write(line)
                f.close()
        elif  sn >  4 :
            # 从第4行以后开始移除注释
            if line[:40].lstrip()[:1] != "#":
                # 逐行判断移除空格后的前1个字符不等于“#”
                with open(exe_script,'a') as f:
                    # 打开文件exe_script并逐行追加写入
                    f.write(line)
                    f.close()
print(exe_script)
# 输出移除注视后的可执行文件详细路径
