###################################################
##################################### BASH
#################################################################

##命令别名设置 alias
alias lm='ls -al'

##如果指令串太长，如何使用两行来输出
cp /var/spool/mail/root /etc/crontab \
 /etc/fastab/root

####shell 的变量功能
##变量的取用
echo ${PATH}
echo ${HOME}
echo ${MAIL}


## 文件系统和程序的限制关系 ulimit 限制CPU的使用时间、内存使用量

ulimit [-SHacdfltu] [配额]
##限制使用者仅能创建10mb一下容量的文件

ulimit -f 10240

##变量内容的删除、取代与替换

##命令执行的判断依据 ；  &&   ||
#在关机前先执行两次sync同步写入磁盘后才shutdown计算机
sync; sync; shutdown -h now

#&& 若cmd1执行完毕且正确执行，则开始执行cmd2
#|| 若cmd1执行完毕且为错误，则开始执行cmd2

#使用ls查阅目录 /tmp/abc 是否存在，若不存在则用touch 创建 /tmp/abc/hehe
ls /tmp/abc || touch /tmp/abc/hehe

##管线命令
ls -al /etc | less

##攫取命令 cut grep
cut -d'分隔字符' -f fields
-d #后面接分隔字符，与-f一起使用
-f #依据-d的分割字符将一段信息分为数段，用-f取出第几段的意思
-c #以字符(characters) 的玩味取出固定字符区间

##将PATH变量去除，找出第３和５个路径
echo ${PATH} | cut -d ':' -f 3,5

#grep
grep [-acinv] [--color=auto] '搜寻字串' filename
-i #忽略大小写的不同

#将last中，有出现root的那一行取出来
last | grep 'root'
#将last中，没有出现root的那一行取出来
last | grep -v 'root'









###########################################################
######################################## shell scripts
###############################################################
#!/bin/bash
# Program:
#		this program shows "Hello world!" in your screen.
# history:
#2018/07/09 lyd first release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH #主要环境变量的宣告
echo -e "Hello world! \a \n"
exit 0

##执行shell
sh hello.sh
