
--创建表空间
--DATAFILE: 表空间数据文件存放路径
--SIZE: 起初设置为200M
--空间名称MOF_TEMP与数据文件名称不要求相同,可随意命名.
--AUTOEXTEND ON/OFF 表示启动/停止自动扩展表空间
create tablespace EPS_DATA_20180929
logging
datafile 'D:\app\Dominic\oradata\orcl\EPS_DATA_20180929.dbf'
size 200m
autoextend on next 100m
maxsize 20480m
extent management local;


--创建用户
--用户名
create user FH_20180929
--密码
identified by 111
default tablespace EPS_DATA_20180929;
-- 给权限
grant dba to FH_20180929;

SELECT * FROM BASE_ORGANIZATION WHERE ORGANIZATION_ID = 1
 
--查看所有用户
--select * from dba_users;
 
--impdp、expdp创建目录
create or replace directory expdir as 'D:\DBTemp';
grant read,write on directory expdir to public;


-- 导入数据
-- dumpfile 数据文件名称
-- logfile 日志文件名称
-- schemas 数据对象集合所属用户
-- remap_schema 当数据不同源时，需设置此项
-- remap_tablespace 当两个用户表空间不一致时，需设置此项
-- version 当数据库版本不同时，需设置此项
impdp FH_20180929/111@orcl directory=expdir dumpfile=FH_20180710.DMP logfile=FH_20180710.DMP_impdp.log schemas=FENGHUO_20180710 remap_schema=FENGHUO_20180710:FH_20180929 remap_tablespace=EPS_DATA:EPS_DATA_20180929


-- 导出数据
-- dumpfile 数据文件名称
-- logfile 日志文件名称
expdp FH_20180929/111@orcl directory=expdir dumpfile=TEST_EXPDP.dmp logfile=TEST_EXPDP.log


---------------------------------------------------------------------

--字符串拼接
--BD2,ORACLE.POSTGRESQL
select str1,str2,str1||str2 as str_concat from samplestr;

--mysql 这个数据库支持concat函数
select concat（str1,'and',str2）as str_concat from samplestr;

--sql server
select str1 + 'and' + str2 as str_concat from samplestr;


--字符串长度

select str1,length(str1) as len_str from samplestr;
--##### notice!!  SQL server len(str1) as len_str

--谓词 case
select price,
	case when merchendise = 'cloth'
	then 'A:'||merchendise
	when merchendise = 'shoes'
	then 'B:'||merchendise
	else null
	end as type_goods
	from shopping;


--限制返回的行数
DB2
select * from data fetch first 5 rows only

mysql POSTGRESQL
select * from data limit 5

ORACLE 
select * from data where rownum<=5

sql server
select top 5 * from data

--从表中随机返回n条记录
DB2 
同时使用内置函数RAND、ORDER BY、fetch
select name,job
	from emp 
order by rand() fetch first 5 rows only

mysql 
select name;job 
	from emp
order by rand() limit 5

ORACLE 
select * 
	from (
		select name,job
			from emp
			order by dbms_random.value()
		)
	where rownum<=5

sql server
select top 5 name,job
	from emp
	order by newid()


--通配符
返回名字中有一个I或职务中以ER结尾的记录
select name,job
	from emp
	where name like '%I%' or job like '%ER' 


--按字串排序
--按字符串的某一部分对查询结果排序。例如，要从EMP表中返回员工名字和职位，并且按照职位字段的最后两个字符排序
select name,job 
	from emp
	oredr by substr(job,length(job)-2)

SQL server
select name,job
	from emp
	order by substring(job,len(job)-2,2)



--排序时考虑空值的排列，解决方案：多加一列识别是否空值，排序时用上这列
select name,sa1,comn
	from(
			select name,sa1,comn,
			case when comn is null then 0 else 1 end as is_null
			from emp
		)x
	order by is_null desc,comn


--根据条件逻辑来排序，例如，如果job是salesman，则根据comm排序，否则根据sal排序
select name,sa1,job,comm
	from emp
	order by case when job = 'salesman' then comm else sa1 end;



--纵向拼接
select name as new_name,deptno
	from emp where deptno=10
	union all
select name2,deptno
	from dept


--插入新的记录

insert into dept (deptno,name,loc) values (50,'PROGRAMMING','BALTIMORE')


--插入默认值
insert into dept values(default)

insert into dept(id) values(default)


--删除一个表中存在，而另一个表中不存在
delete from emp
	where not exists(
			select * from dept
			where dept.deptno=emp.deptno
		)

--或者
delete from emp
	where deptno not in (select deptno from dept)

--translate\replace 函数

