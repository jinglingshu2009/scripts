#!/bin/bash
case 	$1 in
 	home)
		run_python=c:/python27/python.exe
		install_python=c:/python27/Scripts/pyinstaller
		jupyter=c:/python27/Scripts/jupyter-notebook
		#install_python=c:/python27/Scripts/cxfreeze
		install_dir=makefile
	;;
 	cyber)
		run_python=c:/python27/python.exe
		install_python=c:/python27/Scripts/pyinstaller
		jupyter=c:/python27/Scripts/jupyter-notebook
		#install_python=c:/python27/Scripts/cxfreeze
		install_dir=makefile
	;;
	*)
		echo "$0 {home|cyber} 	{run|jupyter|install|debug}	python-script " && exit
	;;
esac
case	$2 in
	run)
		if [ ! $3 ];then
		echo "$0 {home|cyber} 	{run|jupyter|install|debug}	python-script " 
		else
			start $run_python $3
		fi
			
	;;
	install) 
		if [ ! $3 ];then
			echo "$0 {home|cyber} 	{run|jupyter|install|debug}	python-script"
		else
			#第 1 种打包方式(打包成exe程序和相关依赖)
			#start $install_python $3 --target-dir $install_dir 
			#将hello.py文件打包到install_dir目录下，生成hello.exe程序和相关依赖文件
			
			#第 2 种打包方式(仅打包为exe程序，不含相关依赖)
			#start $install_python $3 --target-dir $install_dir --no-copy-deps
			#将hello.py文件打包到install_dir目录下，仅仅生成hello.exe程序
			
			#第 3 种打包方式(打包生成可安装包文件程序)
			#start $run_python setup.py bdist_msi 
			#将hello.py文件打包到install_dir目录下，仅仅生成hello.exe程序
			
			#第 4 种打包方式(可安装包文件程序)
			name_py=`basename $3|awk -F. '{ print $1}'`
			start $install_python   -p `dirname $run_python` -i b.ico -F $3  --clean --version-file=version_info 


		fi
	;;
	debug)
		if [ ! $3 ];then
			echo "$0 {home|cyber} 	{run|jupyter|install|debug}	python-script"
		else
			start $install_python   -p `dirname $run_python` -i a.ico -F $3  -d --clean 
		fi
	;;
	jupyter)
		if [ ! $2 ];then
			echo "$0 {home|cyber} 	{run|jupyter|install|debug}	python-script"
		else
			start $jupyter 
		fi
	;;
	*)
		echo "$0 {home|cyber} 	{run|jupyter|install|debug}	python-script " && exit
	;;
esac
