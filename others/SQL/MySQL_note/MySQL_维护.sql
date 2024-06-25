SELECT * FROM Cls_crawle t WHERE str_to_date(t.DATE,'%Y-%m-%d %H:%i:%s')>='2019-09-28'

mysql -u guest -p






######################################################################################
########################################################## linux 安装配置MySQL 主从库


##### 从命令行手动启动和关闭MySQL




##### 设置在系统开机关机时自动启动和关闭MySQL




##### 主从库配置




######################################################################################
################################################################ MySQL架构组成


## 物理文件组成
# 数据目录的位置
原代码安装：/usr/local/mysql/var
RPM文件安装：/var/lib/mysql
二进制安装：/usr/local/mysql/data

查找目录
SHOW VARIABLES LIKE 'datadir';

# 数据目录的结构
0、每个数据库
1、MySQL服务器的选项文件my.cnf
2、MySQL服务器的进程ID（PID）文件
3、MySQL服务器所生成的状态和日志文件

####### 命名规范
库名最长14个字符
表名最长10个字符，因为要留出4个字符给末尾的句点和3个字符的扩展名

大小写是否敏感取决于所在系统，如unix敏感，Windows和macos不敏感

####### 状态文件和日志文件
进程ID文件     hostname.pid  MySQL服务进程的ID
///服务启动时写入，结束时删除该日志，用于其它进程调用，如关闭系统时先根据pid关闭MySQL

常规查询日志   hostname.log  连接、断开时间和查询信息
///哪些人正从哪些地方进行连接，发出哪些查询命令

慢查询日志     hostname-slow.log 耗时很长的查询命令的文本
变更日志       hostname.nnn 创建、变更了数据表结构或者修改了数据表内容的查询命令文本
二进制变更日志  hostname-bin.nnn 变更日志的二进制表示法
/// 变更日志和其二进制形式主要用于崩溃恢复工作

二进制变更日志的索引文件 hostname-bin.index 使用中的二进制变更日志文件的清单
错误日志      hostname.err 启动、关机事件和异常情况

########## 日志文件管理


########## 系统架构






####### 崩溃修复
1、对表进行检查和修复的工具程序
2、如何利用备份文件来恢复数据
3、利用变更日志来恢复最近一次备份后又发生的数据修改操作



####### 预防性维护






######################################################################################
###################################################################### 数据库备份和恢复 迁移

mysqldump 可以将数据库中的数据备份成一个文本文件
工作原理：将需要备份的表以create语句和insert语句的形式存在文本文件中

# 备份一个数据库
mysqldump -u username -p dbname table table2 ...>backupname.sql
没有具体table名称时，会备份整个数据库
backupsql.sql 表示备份文件的名称，文件名前面可以加上一个绝对路径


# 备份多个数据库
mysqldump -u username -p --databases dbanme1 dbname2 >BackupName.sql

# 备份所有数据库
mysqldump -u username -p --all -databases >backupname.sql


######## 使用mysqlhotcopy工具快速备份
比mysqldump快
工作原理是：先将需要备份的数据库加上一个读操作锁，然后用flush tables将内存中的数据写回到
硬盘上的数据库中，最后，把需要备份的数据库文件复制到目标目录

需要安装Perl的数据接口包；只能备份MyISAM类型的表，不能用来备份InnoDB类型的表

mysqlhotcopy[option] dbname1 dbname2 ... backupdir/

####### 数据还原

mysql -u root -p[dbname] <backup.sql
其中，dbname参数表示数据库名称，指定数据库名时，表示还原该数据库下的表，
不指定时，表示还原一个特定的数据库，而备份文件中有创建数据库的语句。


####### 数据库迁移
指将数据库从一个系统移动到另一个系统上。

# MySQL相同版本的数据库之间的迁移
mysqldump -h host1 -u root -password=password1 -all-databases |
mysql -h host2 -u root -password=password2


###### 导出数据到文本文档
select * from student INTO OUTFILE 'D:\student.txt'
FIELDS TERMINATED BY '\,'     # 字段分隔符
OPTIONALLY ENCLOSED BY '\"'   # 字符串加上引号
LINES STARTING BY '\>'        # 每行开头的字符
TERMINATED BY '\r\n';         # 每行的结束符




######################################################################################
###################################################################### 性能优化

####### 数据目录结构对性能的影响
1、由于每个进程所允许打开的文件个数有限，因此当涉及打开多个文件时
2、查询时间随涉及文件数量增多而增长，这时可以考虑换一个文件系统，或者将多个结构相同而用户不同的表合并为一个
3、使用InnoDB类型表

####### 查询数据库当前性能情况
show status like 'value';
其中，value可以是：
Connections  连接MySQL服务器的次数
Uptime MySQL服务器的上线时间
Slow_queries 慢查询的次数
Com_select 查询操作的次数
Com_insert 插入操作的次数
Com_delete 删除操作的次数


####### 分析查询语句
explain select 语句;
describe select 语句;
desc select 语句;

以上效果相同
rows 下的数字表示存在的n条数据都被查询了一遍

####### 添加索引

create index index_name on financialnews_test(date);
即在date字段添加索引，然后再用explain分析查询语句

####### 优化数据库结构
1、字段特别多且有些字段使用频率很低，可以分解成多个表
2、插入数据时禁用索引
alter table 表名 disable keys;
alter table 表名 enable keys;
3、插入数据时禁用唯一性检查
set unique_checks=0;
set unique_checks=1;

####### 优化表设计
1、建表时优先考虑特定字符长度




######################################################################################
###################################################################### 日常管理

# localhost 连不上（套接字被误删
mysqladmin -h 127.0.0.1 -u root -p shundown

# 忘记root口令

1、关闭MySQL服务器// 查询PID文件再 kill -TERM pid
2、ps命令可能会列出多个mysqld进程，这些都是同一个服务的多个线程，只要终止一个就能终止全部
3、如果是用mysql_safe脚本启动的，它会自动重新启动，所以应先杀mysql_safe进程
4、当所有MySQL服务都停止后，用
--skip_grant_tables 选项重新启动MySQL服务器并修改密码
改密码前尽快刷新一遍权限  flush privileges
5、再次关闭并重启








############################################################################
##################################################################### 用户和权限管理

创建MySQL用户
CREATE USER 'finley'@'localhost' IDENTIFIED BY 'some_pass'; 

CREATE USER 'finley'@'%' IDENTIFIED BY 'some_pass';

删除MySQL用户
通过执行drop user命令删除MySQL用户
DROP USER 'jeffrey'@'localhost';

重命名用户
rename user old_user to new_user;


###### 权限设置

show grants for guest@localhost;
select user,host from mysql.user;
flush privileges // 手动改权限文件时

GRANT ALL PRIVILEGES ON *.* TO 'finley'@'%' WITH GRANT OPTION;

identified by：指定用户的登录密码
with grant option：表示允许用户将自己的权限授权给其它用户

CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin_pass';
GRANT RELOAD,PROCESS ON *.* TO 'admin'@'localhost';
grant select(id) on test.temp to cdq@localhost;

回收MySQL用户权限
通过revoke命令收回用户权限
revoke select on `sys`.`sys_config` from 'mysql.sys'@localhost; 


权限存储在mysql库的几个表中：
user：在user表启用的任何权限均是全局权限，并适用于所有数据库

db：db表列出数据库，而用户有权限访问它们

tables_priv：tables_priv表指定表级权限

columns_priv：列级权限

procs_priv


All/All Privileges权限代表全局或者全数据库对象级别的所有权限
Alter 权限代表允许修改表结构的权限，但必须要求有create和insert权限配合。如果是rename表名，则要求有alter和drop原表，create和 insert新表的权限
Alter routine权限代表允许修改或者删除存储过程、函数的权限
Create权限代表允许创建新的数据库和表的权限

grant create on pyt.* to ‘p1′@’localhost’;

Createroutine权限代表允许创建存储过程、函数的权限
Createtablespace权限代表允许创建、修改、删除表空间和日志组的权限
Create temporary tables权限代表允许创建临时表的权限
Createuser权限代表允许创建、修改、删除、重命名user的权限
Createview权限代表允许创建视图的权限



Delete权限代表允许删除行数据的权限
Drop权限代表允许删除数据库、表、视图的权限，包括truncatetable命令
Event权限代表允许查询，创建，修改，删除MySQL事件
Execute权限代表允许执行存储过程和函数的权限
File权限代表允许在MySQL可以访问的目录进行读写磁盘文件操作，可使用 的命令包括load data infile,select ... into outfile,load file()函数
Grant option 权限代表是否允许此用户授权或者收回给其他用户你给予的权限
Index权限代表是否允许创建和删除索引
Insert权限代表是否允许在表里插入数据，同时在执行analyze table,optimize table,repair table语句的时候也需要insert权限
Lock权限代表允许对拥有select权限的表进行锁定，以防止其他链接对此表的读或写


Process权限代表允许查看MySQL中的进程信息，比如执行showprocesslist,
Reference 权限是在 5.7.6版本之后引入，代表是否允许创建外键
Reload权限代表允许执行flush命令，指明重新加载权限表到系统内存中， refresh命令代表关闭和重新开启日志文件并刷新所有的表
Replication client权限代表允许执行show master status,show slave status,show binary logs命令
Replication slave权限代表允许slave主机通过此用户连接master以便建立主从 复制关系
Select权限代表允许从表中查看数据，某些不查询表数据的select执行则不需 要此权限，如Select 1+1，Select PI()+2;而且select权限在执行update/delete 语句中含有where条件的情况下也是需要的
Showdatabases权限代表通过执行showdatabases命令查看所有的数据库名
Show view权限代表通过执行show create view命令查看视图创建的语句mysqladmin processlist, show engine等命令


Shutdown权限代表允许关闭数据库实例，执行语句包括mysqladmin shutdown
Super权限代表允许执行一系列数据库管理命令，包括kill强制关闭某个连接 命令，change master to创建复制关系命令，以及create/alter/drop server等命令
Trigger权限代表允许创建，删除，执行，显示触发器的权限
Update权限代表允许修改表中的数据的权限
Usage权限是创建一个用户之后的默认权限，其本身代表连接登录权限


##### MySQL账户的密码如何重置

mysqladmin -u user_name -h host_name password "newpassword" //linux 命令行执行

set password for 'guest'@'%' = password('aplple');

set password = password('apple'); //给自己改密码

grant usage on *.* to 'guest'@'%' identified by 'apple';

insert into user (Host,User,Password) VALUES('%','guest',password('apple'));
flush privileges;

update user set Password = password('apple') where Host = '%' and user = 'guest';


--###################################################################改字段长度
alter table 表名 modify 列名 数据类型；

alter table bl_yhsz modify  zcmc varchar2(120);
