#!/usr/bin/python
#^_^ coding:utf-8 ^_^
import hashlib
import os
import time
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

def  get_md5(input_file,md5="off"):
    '''
    1:input_file 源文件或字符串 2：on 开启校验  off  关闭校验
    字符串：开启校验获取字符串md5并返回结果，关闭校验仅返回原字符串,
    文  件：开启校验获取文件(路径)MD5并根据MD5值，关闭校验仅返回原有文件名称（含全路径）
    '''
    #区别文件（file）与字符串（str）
    if len(input_file.split(".")) == 1:
        #获取字符串MD5
        if md5 == "on" :
            input_str_md5 = hashlib.md5((input_file).encode('utf-8')).hexdigest()
            return input_str_md5
        else:
            return ""
    else:
        if md5 == "on":
            md5file = open(input_file,'rb')
            input_file_md5 ="-%s" % (hashlib.md5(md5file.read()).hexdigest())
            md5file.close()
            return  input_file_md5
        else:
            return ""
def compare(x, y):
    # 设置文件存储目录
    path = file_path
    # 按生成时间将文件排序
    stat_x = os.stat(path + "/" + x)
    stat_y = os.stat(path + "/" + y)
    if stat_x.st_ctime < stat_y.st_ctime:
        return -1
    elif stat_x.st_ctime > stat_y.st_ctime:
        return 1
    else:
        return 0
############################################################
file_type="txt,rar"
file_path="C:\Users\Administrator\Desktop\\test"
file_size="10size"   #SIZE|KB|MB|GB
file_num=100
check_md5 = "on"   #on|off
sync_mode="recv"  #send|recv
############################################################
for num in range(1,file_num+1):
    #将文件后缀转换为文件后缀列表你
    _list=file_type.split(",")
    for file_type_num in range(len(_list)):
        #获取文件完整名称（exp编号.后缀）
        tmp_name = "exp%s.%s" % (num,_list[file_type_num])
        #获取文件单位（size/KB/MB/GB），根据单位生产等量级的大小文件
        tmp_unit=file_size[-2].upper()
        if tmp_unit == "Z":
            #获取文件大小数值
            tmp_size=file_size.upper().split("SIZE")[0]
            Z_size=tmp_name+"A"*int(tmp_size)
            #生产指定量级(size)大小文件
            with open(tmp_name,"w") as f:
                f.write(Z_size)
                f.close()
            file_md5=get_md5(tmp_name,check_md5)
            now_filename = "%s/%s%s.%s" % (file_path,tmp_name.split(".")[0],file_md5, tmp_name.split(".")[1])
            os.rename(tmp_name,now_filename)
        elif tmp_unit == "K":
            #获取文件大小数值
            tmp_size=file_size.upper().split(tmp_unit)[0]
            K_size=tmp_name+"CBXA"*256*int(tmp_size)
            #生产指定量级((KB)大小文件
            with open(tmp_name,"w") as f:
                f.write(K_size)
                f.close()
            file_md5 = get_md5(tmp_name, check_md5)
            now_filename = "%s/%s%s.%s" % (file_path, tmp_name.split(".")[0], file_md5, tmp_name.split(".")[1])
            os.rename(tmp_name, now_filename)
        elif tmp_unit == "M":
            #获取文件大小数值
            tmp_size=file_size.upper().split(tmp_unit)[0]
            M_size=1024*1024*int(tmp_size)
            # 生产指定量级((MB)大小文件
            fp = open(tmp_name,"w")
            fp.write(tmp_name)
            fp.truncate(M_size) 
            fp.close()
            file_md5 = get_md5(tmp_name, check_md5)
            now_filename = "%s/%s%s.%s" % (file_path, tmp_name.split(".")[0], file_md5, tmp_name.split(".")[1])
            os.rename(tmp_name, now_filename)
        elif tmp_unit == "G":
            # 获取文件大小数值
            tmp_size=file_size.upper().split(tmp_unit)[0]
            G_size=1024*1024*1024*int(tmp_size)
            now_filename = "%s/%s.%s" % (file_path, tmp_name.split(".")[0],tmp_name.split(".")[1])
            #生产指定量级((MB)大小文件
            fp = open(now_filename,"w")
            fp.write(tmp_name)
            fp.truncate(G_size)
            fp.close()
'''
#获取目录中文件列表
file_list=os.listdir(file_path)
#将文件以生成时间排序
file_list.sort(compare)
#同步模式：发送（SEND）
if sync_mode.upper() == "SEND" :
    for del_file in range (len(file_list)/2):
        if check_md5 == "on":
            # 开启文件删除前的MD5校验
            file_md5 = get_md5(file_path + os.sep + file_list[0], check_md5).split('-')[1]
            old_file_md5 = file_list[0].split(".")[0].split("-")[1].strip()
            # 校验文件MD5，校验正确删除文件并打印日志，不正确保留并打印错误
            if file_md5 == old_file_md5:
                os.remove(file_path + os.sep + file_list[0])
                print "%s   %s  %s  %s" % (del_file + 1, "delete", "ok", file_path + os.sep + file_list[0])
            else:
                print "%s   %s  %s  %s" % (del_file + 1, "delete", "error", file_path + os.sep + file_list[0])
                # print "校验文件MD5失败，请排查文件%s" %  file_list[0]
                pass
        else:
            # 关闭文件删除前的MD5校验
            os.remove(file_path + os.sep + file_list[0])
            print "%s   %s  %s  %s" % (del_file + 1, "delete", "ok", file_path + os.sep + file_list[0])
        del file_list[0]
#同步模式：接收（RECV）
else:
    for del_file in range (len(file_list)/2):
        if check_md5 == "on":
            #开启文件删除前的MD5校验
            file_md5 = get_md5(file_path+os.sep+file_list[0], check_md5).split('-')[1]
            old_file_md5 = file_list[0].split(".")[0].split("-")[1].strip()
            #校验文件MD5，校验正确删除文件并打印日志，不正确保留并打印错误。
            if file_md5 == old_file_md5:
                os.remove(file_path+os.sep+file_list[0])
                print "%s   %s  %s  %s" % (del_file+1,"delete","ok",file_path+os.sep+file_list[0])
            else:
                print "%s   %s  %s  %s" % (del_file+1, "delete", "error", file_path + os.sep + file_list[0])
                #print "校验文件MD5失败，请排查文件%s" %  file_list[0]
                pass
        else:
            # 关闭文件删除前的MD5校验
            os.remove(file_path + os.sep + file_list[0])
            print "%s   %s  %s  %s" % (del_file+1, "delete", "ok", file_path + os.sep + file_list[0])
        del file_list[0]
'''
