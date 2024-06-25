######################################################
############################# 软件的安装
##########################################################

####################### rpm 安装命令

rpm -ivh /mnt/Packages/httpd-2.2.15-15.el6.centos.l.x86_64.rpm  # 安装httpd
-i install
-v 查看安装信息细节
-h 显示安装进度

rpm -Uvh /mnt/Packages/httpd-2.2.15-15.el6.centos.l.x86_64.rpm  # 更新httpd
-U update

rpm -e httpd  # 卸载httpd 注意！后面跟的是包名，而不是全名，在任何目录都可进行卸载
-e erase

rpm -q httpd  # 查询软件包是否安装某软件

rpm -qa  # 查询所有已经安装的rpm包
rpm -qa | grep httpd

rpm -qi httpd  # 查询软件包详细信息

rpm -ql httpd  # 查询软件安装位置

rpm -qf 系统文件名  # 查询某个文件属于哪个软件包
-f file

rpm -qR httpd  # 查询软件包的依赖性


####################### yum 在线安装
yum list #查询所有可以安装的软件

yum search 关键字 #搜索服务器上所有和关键字相关的包

yum install 包名 #安装软件

yum update 包名 #升级软件

####constant work ## crontab
# one time task
systemctl restart atd # restart this service
systemctl enable atd # start this service once on the computer
systemctl status atd # check the status of atd

################  tar 包
tar -zxvf jdk-11.0.4_linux-x64_bin.tar.gz -C /opt/module

-c ：创建打包文件，可搭配 -v 来察看过程中被打包的文件名（filename）
-t ：察看打包文件的内容含有哪些文件名，重点在察看“文件名”就是了；
-x ：解打包或解压缩的功能，可以搭配 -C （大写） 在特定目录解开
特别留意的是， -c, -t, -x 不可同时出现在一串命令行中。

-z ：通过 gzip 的支持进行压缩/解压缩：此时文件名最好为 *.tar.gz
-j ：通过 bzip2 的支持进行压缩/解压缩：此时文件名最好为 *.tar.bz2
-J ：通过 xz 的支持进行压缩/解压缩：此时文件名最好为 *.tar.xz
特别留意， -z, -j, -J 不可以同时出现在一串命令行中

-v ：在压缩/解压缩的过程中，将正在处理的文件名显示出来！
-f filename：-f 后面要立刻接要被处理的文件名！建议 -f 单独写一个选项啰！（比较不会忘记）
-C 目录 ：这个选项用在解压缩，若要在特定目录解压缩，可以使用这个选项。


##JAVA_HOME
export JAVA_HOME=/opt/module/jdk-11
export PATH=$PATH:$JAVA_HOME/bin
source /etc/profile


安装 MySQL
在 WSL 上安装 MySQL （Ubuntu 18.04）：
打开 WSL 终端（即 Ubuntu 18.04）。
更新 Ubuntu 包：sudo apt update
更新包后，使用以下内容安装 MySQL：sudo apt install mysql-server
确认安装并获取版本号：mysql --version
你可能还需要运行包含的安全脚本。 这会更改远程根登录名和示例用户之类的一些安全默认选项。 运行安全脚本：
启动 MySQL server：sudo /etc/init.d/mysql start
启动安全脚本提示：sudo mysql_secure_installation
第一个提示将询问你是否要设置 "验证密码" 插件，该插件可用于测试 MySQL 密码的强度。 然后，你将为 MySQL 根用户设置密码，决定是否要删除匿名用户，决定是否允许根用户本地和远程登录，确定是否要删除测试数据库，最后确定是否要立即重新加载特权表。
若要打开 MySQL 提示符，请输入：sudo mysql
若要查看可用数据库，请在 MySQL 提示符下输入：SHOW DATABASES;
若要创建新数据库，请输入：CREATE DATABASE database_name;
若要删除数据库，请输入： DROP DATABASE database_name;


apt-get install 命令安装了一些软件，但这些软件的源码以及那些安装完以后的文件放在哪个文件夹下面？？？

dpkg -L 软件名

sudo apt-get update  更新源
sudo apt-get install package 安装包
sudo apt-get remove package 删除包
sudo apt-cache search package 搜索软件包
sudo apt-cache show package  获取包的相关信息，如说明、大小、版本等
sudo apt-get install package --reinstall  重新安装包
sudo apt-get -f install  修复安装
sudo apt-get remove package --purge 删除包，包括配置文件等
sudo apt-get build-dep package 安装相关的编译环境
sudo apt-get upgrade 更新已安装的包
sudo apt-get dist-upgrade 升级系统
sudo apt-cache depends package 了解使用该包依赖那些包
sudo apt-cache rdepends package 查看该包被哪些包依赖
sudo apt-get source package  下载该包的源代码
sudo apt-get clean && sudo apt-get autoclean 清理无用的包
sudo apt-get check 检查是否有损坏的依赖

#中科大源
deb https://mirrors.ustc.edu.cn/ubuntu/ bionic main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse

#阿里云源
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse

#清华源
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse

A、下载的软件的存放位置：/var/cache/apt/archives
B、安装后软件的默认位置：/usr/share
C、可执行文件位置：/usr/bin
D、配置文件位置：/etc
E、lib文件位置：/usr/lib