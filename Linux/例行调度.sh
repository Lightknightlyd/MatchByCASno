# 例行调度

############################################################################
##################################################3at #处理仅执行一次就结束调度的指令

# 启动与状态
systemctl restart atd # 重新启动 atd 这个服务
systemctl enable atd # 让这个服务开机就自动启动
systemctl status atd # 查阅一下 atd 目前的状态

# 权限配置文件
/etc/at.allow 与 /etc/at.deny 这两个文件来进行 at 的使用限


#示例

at [-mldv] TIME
at -c 工作号码

-m #当指定的任务被完成之后，将给用户发送邮件，即使没有标准输出
-M #不发送邮件
-l #atq的别名
-d #atrm的别名
-r #atrm的别名
-v #显示任务将被执行的时间,显示的时间格式为：Thu Feb 20 14:50:00 1997
-c #打印任务的内容到标准输出
-V #显示版本信息
-q #后面加<队列> 使用指定的队列
-f #后面加<文件> 从指定文件读入任务而不是从标准输入读入
-t #后面<时间参数> 以时间参数的形式提交要运行的任务

atq #列出用户的计划任务，如果是超级用户将列出所有用户的任务，结果的输出格式为：作业号、日期、小时、队列和用户名
atrm #根据Job number删除at任务


# 创建at任务
#1、文件输入
cd /var/spool/at/
touch at.sh
vim at.sh
	#!/bin/bash
	#testing the at command
	echo `date` >> result.txt
at -f at.sh now +1 minutes
atq


#控制台输入
at now +2 minutes
at> echo `date` >> result1.txt
at> ctrl+d

#栗子
at 5pm+3 days #3天后的下午5点
at 18:00 tomorrow # 明天18：00


#####################################################################
########################################################## crontab 
crontab  #循环调度crontab 除了可以使用指令执行外，亦可编辑/etc/crontab 来支持

/etc/cron.allow
/etc/cron.deny
/var/spool/cron/ 目录下存放的是每个用户包括root的crontab任务，每个任务以创建者的名字命名
/etc/crontab 这个文件负责调度各种管理和维护任务
/etc/cron.d/ 这个目录用来存放任何要执行的crontab文件或脚本
#我们还可以把脚本放在/etc/cron.hourly、/etc/cron.daily、/etc/cron.weekly、/etc/cron.monthly目录中，让它每小时/天/星期、月执行一次


当使用者使用 crontab 这个指令来创建工作调度之后，该项工作就会被纪录到
/var/spool/cron/ 里面去了，而且是以帐号来作为判别的喔！举例来说， dmtsai 使用 crontab
后， 他的工作会被纪录到 /var/spool/cron/dmtsai 里头去！但请注意，不要使用 vi 直接编辑该
文件， 因为可能由于输入语法错误，会导致无法执行 cron 喔！另外， cron 执行的每一项工
作都会被纪录到 /var/log/cron 这个登录文件中，所以啰，如果你的 Linux 不知道有否被植入
木马时，也可以搜寻一下 /var/log/cron 这个登录文件呢！


# 语法
crontab [-u username]
-u #只有 root 才能进行这个任务，亦即帮其他使用者创建/移除 crontab 工作调度
-e #编辑 crontab 的工作内容
-l #查阅 crontab 的工作内容
-r #移除所有的 crontab 的工作内容，若仅要移除一项，请用 -e 去编辑


# 例子 每五分钟执行/home/dmtsai/test.sh
crontab -e
*/5 * * * * /home/dmtsai/test.sh

# yuedong
*/3 * * * * /home/yuedong/Cls_crawler/Cls_crawle.sh >> /home/yuedong/Cls_crawle.log
*/60 * * * * /home/yuedong/Cls_crawler/duplicate.sh >> /home/yuedong/duplicate.log
59 23 * * * /home/yuedong/Cls_crawler/final.sh >> /home/yuedong/final.log
# root

4 0 * * * "/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" > /dev/null
0 3 * * * /sbin/reboot


# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed


#第一步：在linux上编写一个.sh脚本（test.sh）
#!/bin/bash
source /etc/profile
echo "start: `date`"
/usr/local/bin/Rscript /home/test.R  
echo "end:`date`"

#代码说明：第二行是要加载环境变量，比较重要，如果没增加这行，定时计划在执行R脚本时，会跳过，只执行shell的脚本
#第四行空格前面为R安装在linux的目录，要指定到Rscript
#空格后面为要定时执行的R脚本(一般要写绝对路径)


#第二步：使用crontab定时执行test.sh
0 4 * * * nohup /home/test.sh >>/home/test.log

*/3 * * * * /home/yuedong/Cls_crawle.sh >> /home/yuedong/Cls_crawle.log

MAIL (mailed 102 bytes of output but got status 0x004b#012)