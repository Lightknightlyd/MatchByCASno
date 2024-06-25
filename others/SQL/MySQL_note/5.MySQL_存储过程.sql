

###########################################################################
################################################################## 存储过程

////创建存储过程和存储函数
mysql中默认语句结束符号为分号，存储过程中也是分号，为避免冲突，首先用
delimiter // 将结束符设为//，最后用delimiter; 恢复成分号，这和创建触发器时是一样的。

delimiter //
create procedure proc_name (in parameter interger) // in 表示输入类型的变量 out/inout
	begin
		declare variable varchar(20);
		if parameter=1 then 
		set variable="mysql";
		else
		set variable="php";
		end if;
		insert into tb (name) VALUES (variable);
	end
	//
delimiter;


# 删除存储过程
drop procedure proc_name;


### 存储函数

delimiter //
create function name_of_student (std_id int)
	result varchar(50)
	begin
		return(select name from studentinfo where sid=std_id);
	end
	//
delimiter;


### 局部变量和全局变量

# 局部变量
declare age int
declare age int default 18
select ... into age from .. where ..
# 全局变量无需声明
以字符@开头代表全局变量

set @age=18;
select @age;



##########################################  光标的运用
游标要和handler一起使用，并且在handler之前定义

光标使用包括：
声明光标 declare cursor
打开光标 open cursor
使用光标 fetch cursor
关闭光标 close cursor

声明光标：
declare info_of_student cursor for select
	id,name,age,sex
	from studentinfo where id in (1,2,3);

打开光标：
声明光标后，要从光标中提取数据，必须首先打开光标
open info_of_student 

使用光标：
fetch info_of_student into tmp_name,tmp_tel;

关闭光标:
close info_of_student


# 一个使用游标的示例
create procedure cur_demo()
	begin
		declare done INT DEFAULT 0;
		declare _emp_no INT;
		declare _dept_no VARCHAR(10);
		declare cur1 cursor for select emp_no,dept_no from dept_emp;
		declare continue handler for not found set done = 1; // 游标要和handler一起使用,即游标返回数据为空时进行操作
		open cur1;
		read_loop: loop
		fetch cur1 into _emp_no,_dept_no;
		if done then
			leave read_loop;
		end if;
		end loop;
		close cur1;
	end;







### 控制流
# if
delimiter //
create procedure example_if(in x int)
	begin
	if x=1 then
	select 1;
	elseif x=2 then
	select 2;
	else 
	select 3;
	end if;
	end
	//
delimiter;

call example_if(2);

# case
delimiter //
create procedure example_case(in x int)
	begin
	case x
	when 1 then select 1;
	when 2 then select 2;
	else select 3;
	end case;
	end
	//
delimiter;

# while
delimiter //
create procedure example_while(out sum int)
	begin
	declare i int default 1;
	declare s int default 0;
	while i<=100 do
	set s=s+i;
	set i=i+1;
	end while;
	set sum=s;
	end
	//
delimiter;

call example_while(@s) //定义一个s变量用于储存存储过程的输出值
select @s;

# loop
delimiter //
create procedure example_loop(out sum int)
	begin
	declare i int default 1;
	declare s int default 0;
	loop_label:loop
	set s=s+i;
	set i=i+1;
	if i>100 then
	leave loop_label;
	end if;
	end loop;
	set sum=s;
	end
	//
delimiter;

# repeat
delimiter //
create procedure example_repeat(out sum int)
	begin
	declare i int default 1;
	declare s int default 0;
	repeat
	set s=s+i;
	set i=i+1;
	until i>100
	end repeat;
	set sum=s;
	end
	//
delimiter;

### 调用存储过程和函数
call example_if(2);
call example_while(@s) //定义一个s变量用于储存存储过程的输出值
select @s;


### 查看存储过程和函数
show {procedure|function}status[like 'pattern'] //只能看基础信息
show create{procedure|function} sp_name; // 详细定义

### 修改存储过程和函数



### 删除存储过程和函数

drop {procedure|function}[if exists] sp_name 


### 捕获存储过程中的错误




