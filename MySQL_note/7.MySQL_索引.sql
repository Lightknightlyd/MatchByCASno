################################################################################
########################################################################## 索引

////在建表时就创建索引

//普通索引 ///任何数据类型
create table table_name (
	id int(5) auto_increment primary key not null,
	name varchar(50),
	math int(5),
	english int(5),
	chinese int(5),
	index(id)
);

//唯一索引 ///索引的值必须唯一 主键是一种特殊的唯一索引

create table address (
	id int(5) auto_increment primary key not null,
	name varchar(50),
	address varchar(200),
	UNIQUE index address(id ASC)  // address别名 ASC升序 DESC降序
);

//全文索引 ///只能建在char varchar text类型的字段上 适用数据量较大

create table cards (
	id int(5) auto_increment primary key not null,
	name varchar(50),
	info varchar(200),
	FULLTEXT KEY cards_info(info) //只有myisam类型的数据表支持全文索引
);

//单列索引 //针对一个字段进行索引

create table telephone (
	id int(11) primary key auto_increment not null;
	name varchar(50) not null;
	tel varchar(50),
	index tel_num(tel(20))  //创建的索引长度只有20，目的在于提高查询效率，优化查询速度
); 


//多列索引 ///针对多个字段进行索引，使用时必须按第一个字段
create table information (
	id int(11) auto_increment primary key not null;
	name varchar(50),
	sex varchar(5),
	birthday varchar(50),
	index info(name,sex)
);


//空间索引 ///只能建立再空间数据类型上，只有MyISAM支持
create table list(
	id int(11) primary key auto_increment not null;
	goods geometry not null
	spatial index listinfo(goods)
)engine=MyISAM;


////已建表里添加索引

//普通索引
create index stu_info on studentinfo(sid);

//唯一索引
create unique index index_name on teble_name(sid);

//全文索引
create FULLTEXT index index_name on teble_name(sid);

//单列索引
create index index_name on table_name(address(4));

//多列索引
create index index_name on table_name(name,address);

//空间索引
create spatial index index_name on table_name(column);



////修改已经存在的索引 和新建索引功能大体相同

//普通索引
alter TABLE studentinfo add index index_name(time(20));

//唯一索引
alter TABLE studentinfo add unique index index_name(time(20));


//全文索引
alter TABLE studentinfo add FULLTEXT index index_name(time(20));


//单列索引
alter TABLE studentinfo add index index_name(time(20));


//多列索引
alter TABLE studentinfo add index index_name(id,name,..);


//空间索引
alter TABLE studentinfo add spatial index index_name(time(20));





//// 删除索引

drop index index_name on table_name;

/// 添加索引前后看查询的行数变化
CREATE INDEX index_name on financialnews_test(DATE);
DESC SELECT * FROM financialnews_test t WHERE t.DATE>'2019-11-26 21:00:03';
DROP INDEX index_name on financialnews_test;
DESC SELECT * FROM financialnews_test t WHERE t.DATE>'2019-11-26 21:00:03';
