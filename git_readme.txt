GIT 使用说明
ssh-keygen -t rsa -C "youremail@example.com" :创建SSH Key	id_rsa.pub是公钥,
登陆GitHub，打开“Account settings”，“SSH Keys”页面：然后，点“Add SSH Key”，填上任意Title，在Key文本框里粘贴id_rsa.pub文件的内容

git config --global user.email "you@example.com"   :设置全局user.email
git config --global user.name "Your Name"	   :设置全局user.name

git remote add origin git@github.com:michaelliao/learngit.git  :添加远程库
git push -u origin master		:第一次推送master分支的所有内容
git push origin master       	:此后每次本地提交,推送最新修改
git  clone  git@github.com:jinglingshu2009/scripts  :clone远程github项目scripts到本地
 
git add file		    :添加文件或目录到临时工作区.
git commit -m "备注信息"    :将临时工作区文件进行提交并添加备注说明信息.
git status		    :查看临时工作区或文件的目前状态.
git log			    :查看git相关更新日志.
git log  --pretty=oneline   :以简洁模式显示git日志信息.

git push 	:推送本地更新到远程github服务器中
git pull 	:更新本地

git reset --hard xxxxxxx     :回退到指定版本
git revert -n xxxxxxx        :用一次新的commit来回滚到之前的commit

切换分支：git checkout name
撤销修改：git checkout -- file
删除文件：git rm file
查看状态：git status
添加记录：git add file 或 git add .
添加描述：git commit -m "miao shu nei rong"
同步数据：git pull
提交数据：git push origin name

分支操作
查看分支：git branch
创建分支：git branch name
切换分支：git checkout name
创建+切换分支：git checkout -b name
合并某分支到当前分支：git merge name
删除分支：git branch -d name
删除远程分支：git push origin :name