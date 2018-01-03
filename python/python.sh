#!/bin/bash
case 	$1 in
 	home)
		_python=c:/python27/python.exe
	;;
 	cyber)
		_python=c:/python27/python.exe
	;;
	*)
		echo "$0 {home|cyber} python-script " && exit
	;;
esac
if [ ! $2 ];then
	echo "$0 {home|cyber} python-script " && exit
else
	start $_python $2
fi
