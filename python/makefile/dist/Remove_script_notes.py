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

script = sys.argv[1]
#获取第2个位移变量(第1个参数)，sys.argv[0]:脚本自身名称
script_name = os.path.dirname(os.path.realpath(__file__))+os.sep+os.path.basename(script)
#获取脚本全路径+名称

print(script,file_name)