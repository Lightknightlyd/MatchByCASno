-- Created on 2019/9/1 by 12630 
declare 
  -- Local variables here
  v_name VARCHAR(20) := '小明';
  v_sal NUMBER;
  v_addr VARCHAR(200);

begin
  -- Test statements here 
  --直接赋值
  v_sal := 4500;

  --语句赋值
  select 'alibaba' into v_addr from table;

   --java: System.out.println(Hello world!); 
  DBMS_OUTPUT.PUT_LINE('姓名：'||v_name||'，薪水：'||v_sal||',地址：'|| v_addr);

end;




--#####################################################引用型变量
--#######################################################
declare 
  -- Local variables here
  v_name VARCHAR(20) := '小明';
  v_sal emp.sal%TYPE;



--#################################################记录型变量 接受表中一整行记录 如果引用型变量过多，此时可使用记录型变量
--####################################################
declare 
  -- Local variables here
  	v_emp emp%ROWTYPE;

begin 

	select * into v_emp from emp where v_name = '小明';

  	DBMS_OUTPUT.PUT_LINE('姓名：'||v_name.name||'，薪水：'||v_sal||',地址：'|| v_addr);

end;



-- ################################################流程控制
--######################################################
begin 
	
	if condition then ...

		elsif condition then  ...

		else  ...

	end if;

end;





begin

	loop

	exit when condition

	end loop;


end;



--######################################################################### 游标
--############################################################
--## 用于临时存储一个查询返回的多行数据
-- 声明  打开  读取  关闭

-- 使用游标查询emp表中所有员工的姓名和工资，并将其打印出来
declare 
  -- 声明游标
  	CURSOR c_emp IS select ename,sal from emp;
  -- 声明表里用于接收游标中的数据

  v_ename emp.ename&TYPE;
  v_sal emp.sal%TYPE;


begin 
--打开游标
	open c_emp;

		loop

			fetch c_emp into v_ename,v_sal;

		exit when c_emp%NOTFOUND;


		DBMS_OUTPUT.PUT_LINE(v_ename||'-'||v_sal);


		end loop;

--关闭游标
	close c_emp;
end;

--###################带参数游标

declare 
  -- 声明游标
  	CURSOR c_emp(v_deptno emp.deptno%TYPE) IS select ename,sal from emp where deptno = v_deptno;
  -- 声明表里用于接收游标中的数据

  v_ename emp.ename&TYPE;
  v_sal emp.sal%TYPE;

begin 
--打开游标
	open c_emp(10); -- (10)这个是 v_deptno 参数的值，即只查 10 号

		loop

			fetch c_emp into v_ename,v_sal;

		exit when c_emp%NOTFOUND;


		DBMS_OUTPUT.PUT_LINE(v_ename||'-'||v_sal);


		end loop;

--关闭游标
	close c_emp;
end;



--###############################################################
--#############################################  存储过程

--带参数存储过程
--查询并打印某个员工的姓名和薪水--存储过程：
--要求，调用的时候传入员工编号，自动控制台打印


create or replace procedure p_querynamesal(
	i_empno IN emp.empno%TYPE)


as 

--声明变量
		v_name emp.ename%TYPE;
		v_sal emp.sal%TYPE;

	begin
	
		select ename,sal into v_name,v_sal from emp  where empno  = i_empno;

		DBMS_OUTPUT.PUT_LINE(v_ename||'-'||v_sal);

	end;


--带输出的存储过程
--查询并打印某个员工的姓名和薪水--存储过程：
--要求，调用的时候传入员工编号，将薪水作为输出值


create or replace procedure p_querynamesal(
	i_empno IN emp.empno%TYPE,
	o_sal OUT emp.sal%TYPE)


as 

	begin
	
		select sal into v_sal from emp  where empno  = i_empno;


	end;

-- 如何接受参数

--plsql 中声明并传值

declare 
  	v_sal emp.sal%TYPE;

begin 

	p_querynamesal(2564,v_sal);

end;
