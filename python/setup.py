#!/usr/bin/python
#^_^ coding:utf-8 ^_^
# Filename:setup.py
#import sys
from cx_Freeze import setup,Executable

#build_exe_options={'packages':[],'excludes':[]}

# setup(  name = '<程序名>',
        # version = '<程序版本>',
        # description = '<程序描述>',
        # options = {'build_exe': build_exe_options},
        # executables = [Executable('main.py')])

executables = [
        Executable('hello.py')
        ]

setup(  name = 'hello',
        version = '1.0.0.1',
        description = 'Python study frist one',
        executables = executables
        )


