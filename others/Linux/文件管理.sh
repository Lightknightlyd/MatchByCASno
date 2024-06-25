#####################################################
################################################################ 路径管理
###############################################################

pwd [-p]# print working directory  
#-p show real directory instead of link directory

mkdir [-mp]#create a new directory
-m #set limitation
mkdir -m 711 test2

-p # create several dir
mkdir -p test1/test2/test3/test4

rmdir [-p]#remove a direction
-p #remove several

rmdir -p test1/test2/test3/test4

########### PATH
#add a dir into PATH
PATH="${PATH}:/root"

########################################### 复制
cp [-adfilprsu] source destination
cp [options] source1 source2... directory
#注：目录文件的拥有着通常是指令操作者本身，因此在使用cp时，要考虑文件权限

#用root身份，将主文件夹下的.bashrc 复制到 /tmp 下，并更名为 bashrc
cp ~/.bashrc /tmp/bashrc
cp -i ~/.bashrc /tmp/bashrc

#变换目录到/tmp，并将/var/log/wtmp复制到/tmp
cd /tmp
cp /var/log/wtmp .

########################################## 删除
rm [-fir] 文件或目录

##删除刚在范例中创建的bashrc
cd /tmp
rm -i bashrc

##删除/tmp/etc这个目录
rm -r /tmp/etc

############################### 移动文件和目录、或更名
mv [-fiu] source destination
##复制一文件，创建一目录，将文件移动到目录中
cd /tmp
cp ~/.bashrc bashrc
mkdir mvtest
mv bashrc mvtest

## 将刚刚的目录名称更名为mvtest2
mv mvtest mvtest2 


###############################修改文件时间或创建新文件 touch
##将bashrc日期修改为2018/0806/21：40
touch -t 201808062140 bashrc

############################### 文件的默认权限 umask 分数是指默认值需要减掉的限权
##设置默认文件权限为003,既拿掉wx限权
umask 003
#文件为 -rw-rw-r--
#目录为 drwxrwxr--

############################### 文件隐藏属性
##设置文件隐藏属性
chattr [+-=] [Asacdistu]
##显示文件隐藏属性
lsattr [-adR] filename

################################## 文件特殊限权
SUID 
SGID
SBIT

################################### 指令和文件的搜寻
which [-a] command
whereis [-bmsu] filename
locate [-ir] keyword
find 


#如何查看yum安装的软件被安装到了哪个目录
rpm -qa|grep nodejs
rpm -ql nodejs-8.11.2-1nodesource.x86_64 # 一般安装到/usr/lib64 同时帮助文件安装到/usr/share






# 下载文件





