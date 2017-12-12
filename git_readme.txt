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



