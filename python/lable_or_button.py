#!/usr/bin/python
#^_^ coding:utf-8 ^_^
# Filename:lable_or_button.py
import time
import tkinter as tk



time.sleep(5)
print '##############################'
time.sleep(5)
window = tk.TK()
window.title('my_window')
window.geometry('200*100')
l = tk.Label(window,text='OME!',bg='green',font=('Arial',12),width=15,
        height=2)
l.pack()
print '##############################'
time.sleep(5)
window.mainloop()
