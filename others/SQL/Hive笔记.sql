--建表示例-注意变量类型

CREATE TABLE employees(
	name	STRING,
	salary	FLOAT,
	subordinates	ARRAY<STRING>,
	deductions	MAP<STRING,FLOAT>,
	adress	STRUCT<street:STRING,city:STRING,state:STRING,zip:INT>
)

ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
COLLECTION ITEMS TERMINATED BY '\002'
MAP KEYS TERMINATED BY '\003'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;


subordinates[1]
deductions['STRING']
adress.city

-创建新的数据库
hive> CREATE DATABASE financials;

hive> CREATE DATABASE financials
	> COMMENT 'Holds all financials tables';


-描述数据库
hive> DESCRIBE DATABASE financials;


-查看现有数据库
hive> SHOW DATABASE;
hive> SHOW DATABASE LIKE 'h.*';

-切换当前工作数据库
hive> USE financials;

-删除数据库
hive> DROP DATABASE IF EXISTS financials;

-###################################
-创建新的表

CREATE TABLE IF NOT EXISTS financials.employees(
	name	STRING COMMENT 'Employee name',
	salary	FLOAT,
	subordinates	ARRAY<STRING>,
	deductions	MAP<STRING,FLOAT>,
	adress	STRUCT<street:STRING,city:STRING,state:STRING,zip:INT>
)

COMMENT 'Description if the table'
TBLPROPERTIES('creator'='me','created_at'='2012-01-02 10:00:00')
LOCATION '/user/hive/warehouse/financials.db/employees';

-拷贝一张已经存在的表
CREATE TABLE IF NOT EXISTS financials.employees2
LIKE financials.employees

-显示当前数据库下表
hive> SHOW TABLES IN financials;



-创建外部表
CREATE EXTERNAL TABLE IF NOT EXISTS stocks(

	exchange STRING,
	...
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION '/data/stocks';

-EXTERNAL 表明这个表是外部的
-LOCATION 表明该表映射的数据位于那个路径下


-内部表分区

CREATE TABLE IF NOT EXISTS financials.employees(
	name	STRING COMMENT 'Employee name',
	salary	FLOAT,
	subordinates	ARRAY<STRING>,
	deductions	MAP<STRING,FLOAT>,
	adress	STRUCT<street:STRING,city:STRING,state:STRING,zip:INT>
)

PARTITIONED BY (country STRING,state STRING);
-此分区语句在表目录下创建了子目录
-分区字段一旦创建好，可以和普通字段一样使用，如：
where country = 'US' and state = 'IL';


-查看所有分区
hive> SHOW PARTITIONS employees;


-外部表分区
先创建分区表，再分别为每个分区指定location

-删除表
DROP TABLE IF EXISTS employees;

-操作和修改表


######################################
-向管理表中装载数据
LOAD DATA LOCAL INPATH '${env:HOME}/california-employees'
OVERWRITE INTO TABLE employees
PARTITION (country = 'US',state = 'CA');



-通过查询语句向表中插入数据
INSERT OVERWIRTE TABLE employees
partition(country = 'US',state = 'OR')
select * FROM STAGED_EMPLOYEES se 
where s==se.cnty='US'and 'se.st'='OR';

-自动生成分区（动态分区）

INSERT OVERWIRTE TABLE employees
partition(country ,state )
select ...,se.cnty,se.st
FROM STAGED_EMPLOYEES se ;


-###############################################
-聚合group BY

hive> select year(ynd),avg(price_close) from stocks
	> where exchange = 'NASDAQ' AND symbol = 'APPL'
	> group BY year(ynd);


-使用having 来代替嵌套

hive> select year(ynd),avg(price_close) from stocks
	> where exchange = 'NASDAQ' AND symbol = 'APPL'
	> group BY year(ynd)
		> having avg(price_close)>50.0;



-join函数




-索引






