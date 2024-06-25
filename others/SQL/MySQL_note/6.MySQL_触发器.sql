

########################################################################
############################################################### 触发器

# 创建触发器
create trigger trig_name before|after 触发事件
	on 表名 for each row 执行语句

触发事件：包括insert、update、delete
for each row： 表示任何一条记录上的操作满足触发事件都会触发该触发器

###
delimiter //
create trigger auto_save_time before insert
	on studentinfo for each row
	insert into timelog(savetime) values(now());
		//
delimiter;

功能是当用户向studentinfo表中执行insert操作时，数据库系统会自动在插入语句执行之前
向timelog表中插入当前时间。

# 具有多个执行语句的触发器

delimiter //
create trigger delete_time_info after delete
	on studentinfo for each row
	begin
	insert into timelog(savetime) values(now());
	insert into timeinfo(info) values ('deleteact');
	end
		//
delimiter;

# 查看触发器

show triggers;

select * from information_schema.triggers where ...;


# 应用触发器

触发器中不能包含start transcation\ commit \rollback等关键词
也不能包含call语句


# 删除触发器

drop trigger 触发器名称;
