#!/usr/bin/python
#^_^ coding:utf-8 ^_^
# Filename:Test_list.py
def say_cut(src_data, cut, dst_data):
    src_data = src_data + cut
    # print src_data,cut,dst_data
    wc = 0
    dst_data = []
    # tmp_data = tmp_data
    for tmp_srcdata in src_data:
        if tmp_srcdata != cut:
            wc = wc + 1
            if wc == 1:
                tmp_data1 = tmp_srcdata
            elif wc == 2:
                tmp_data2 = tmp_srcdata
            elif wc == 3:
                tmp_data3 = tmp_srcdata
            elif wc == 4:
                tmp_data4 = tmp_srcdata
            elif wc == 5:
                tmp_data5 = tmp_srcdata
        else:
            if wc == 1:
                info = tmp_data1
            elif wc == 2:
                info = tmp_data1 + tmp_data2
            elif wc == 3:
                info = tmp_data1 + tmp_data2 + tmp_data3
            elif wc == 4:
                info = tmp_data1 + tmp_data2 + tmp_data3 + tmp_data4
            elif wc == 5:
                info = tmp_data1 + tmp_data2 + tmp_data3 + tmp_data4 + tmp_data5
            dst_data.append(info)
            wc = 0
    #print dst_data

src_data = "1:22:333:4444:55555:fasdf:43:fasdf:fasf:42423:4@#$#:44234:666f76"
cut = ":"
dst_data = "dstdata"

# print tmp_name
#say_cut(src_data, cut, dst_data)
print(len(src_data.split(':')))
print src_data.split(':')
