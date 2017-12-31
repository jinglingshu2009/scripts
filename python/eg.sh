#!/bin/bash
_name=`echo $1 |awk -F. '{ print $2}'`
if [ ! "$1" ];then
	echo "$0 filename"
fi
if [  "$_name" = "py" ];then
	head -n 2 hello.py >>$1
	echo "# Filename:$1" >>$1
	chmod u+x $1
else 
	head -n 2 hello.py >>$1.py
	echo "# Filename:$1.py" >>$1.py
	chmod u+x $1.py
fi
