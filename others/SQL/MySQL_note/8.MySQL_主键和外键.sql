################################################################################
########################################################################## 主键和外键

// 建表时设置
// 单个主键
create table department (
	d_id int(4) not null primary key,
	d_name varchar(20) not null,
	function varchar(50),
	address varchar(50)
);


//联合主键
create table department (
	d_id int(4) not null,
	d_name varchar(20) not null,
	function varchar(50),
	address varchar(50),
	primary key (d_id,d_name)
);

// 建表后修改

alter table department add primary key (id); //加主键
alter table department drop primary key (id); //删主键





// 添加外键
// 建表时设置

create table worker (
	id int(4) not null primary key auto_increment,
	num int(4),
	d_id int(4),
	name varchar(20) not null,
	birthday date,
	constraint worker_fk foreign key(d_id)
	references department(d_id)
);


// 建表后设置

alter table　表名 add constraint  外键名  foreign key (字段1）
	references  主表名2（字段名2）级联操作



// 这时存在外键约束，我们不能删主表，department
alter table worker drop foreign key worker_fk;

// 通过删掉主键约束，我们可以操作主表了
drop table department;


