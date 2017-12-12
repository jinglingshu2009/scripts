GIT 使用说明
ssh-keygen -t rsa -C "youremail@example.com" :创建SSH Key	id_rsa.pub是公钥,
登陆GitHub，打开“Account settings”，“SSH Keys”页面：然后，点“Add SSH Key”，填上任意Title，在Key文本框里粘贴id_rsa.pub文件的内容

git config --global user.email "you@example.com"   :设置全局user.email
git config --global user.name "Your Name"		   :设置全局user.name

git  clone  git@github.com:jinglingshu2009/scripts  :clone远程github项目scripts到本地
 
git add file				:添加文件或目录到临时工作区.
git commit -m "备注信息"    :将临时工作区文件进行提交并添加备注说明信息.
git status					:查看临时工作区或文件的目前状态.
git log						:查看git相关更新日志.
git log  --pretty=oneline	:以简洁模式显示git日志信息.

