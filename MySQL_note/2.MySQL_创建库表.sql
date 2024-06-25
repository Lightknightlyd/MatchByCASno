#################################################################################
##################################################################### 创建库表
create database Mydatabase;
drop database Mydatabase;
show databases;
use databases;

create [temporary] table mytable [(create_definition...)] [table_options] [select_statemenet]

其中，create_definition:
col_name type [not null|null] [default default_value] [auto_increment] [primary key] [reference_definition]

其中：
col_name
type
not null|null
default 默认值
auto_increment 是否主动编号



例子：
CREATE TABLE `test` (
	`DATE` CHAR(50) NULL DEFAULT '123',  # 第一个null允许空值
	`EVENT` VARCHAR(500) NULL DEFAULT NULL
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;


## 查看表结构
show columns from teble;


## 修改表结构

alter [ignore] table mytable alter_spec;

add [column] create_definition //添加新字段
add index [index_name] //添加索引名称
add primary key //
add unique 
alter col_name

例子：
ALTER TABLE `test`
	CHANGE COLUMN `DATE` `DATEnew` CHAR(30) NULL DEFAULT '123' FIRST,
	ADD COLUMN `Column 2` CHAR(30) NULL DEFAULT NULL AFTER `DATEnew`,
	DROP COLUMN `EVENT`;



alter table t add primary key (id); //加主键
alter table t drop primary key (id); //删主键


## 重命名表
rename table tableold to tablenew

## 插入值
INSERT INTO `www_yuedong_site`.`test` (`DATE`, `EVENT`) VALUES ('112', '222');

## 删除值
DELETE FROM `www_yuedong_site`.`test` WHERE  `DATE`='112' AND `EVENT`='222' LIMIT 1;


# 修改已存在的值
UPDATE `www_yuedong_site`.`test` SET `EVENT`='3' WHERE  `DATE`='123' AND `EVENT`='222' LIMIT 1;

