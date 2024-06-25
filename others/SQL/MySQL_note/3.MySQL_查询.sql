###################################### 例子

SELECT * FROM 
	(SELECT * FROM 
		(SELECT t.NAME as NAME_R FROM Cypher_Relation t group BY t.NAME) t2 
			right JOIN Cypher_Person ON t2.NAME_R = Cypher_Person.NAME) t3
	WHERE t3.NAME_R IS null;



############################################################################
##################################################################### 连接查询

# 内连接查询 类似于merge(all=T)，两表根据某一字段关联查询

SELECT * FROM Cypher_Person, Cypher_Relation WHERE Cypher_Person.NAME=Cypher_Relation.NAME and Cypher_Relation.ID>=50;

SELECT * FROM Cypher_Person JOIN Cypher_Relation ON Cypher_Person.NAME=Cypher_Relation.NAME;

# 外连接查询 分为左外连接、右外连接、全外连接

左外连接 merge(all.X=T,all.Y=F)

SELECT * FROM Cypher_Person LEFT JOIN Cypher_Relation ON Cypher_Person.NAME=Cypher_Relation.NAME;

右外连接 merge(all.X=F,all.Y=T)

SELECT * FROM Cypher_Person RIGHT JOIN Cypher_Relation ON Cypher_Person.NAME=Cypher_Relation.NAME;

全外连接

SELECT * FROM Cypher_Person LEFT JOIN Cypher_Relation ON Cypher_Person.NAME=Cypher_Relation.NAME
UNION ALL (不去重) 
SELECT * FROM Cypher_Person RIGHT JOIN Cypher_Relation ON Cypher_Person.NAME=Cypher_Relation.NAME;



############################################################################
##################################################################### 子查询
select * from tb_login where user in (select user from tb_book);
select id,book,row from tb_book where row >= (select row from tb_row where id =1);
select * from tb_row where exists (select * from tb_book where id=27);
select * from tb_row where row>=90 and exists (select * from tb_book where id=27);
select id,book,row from tb_book where row <any (select row from tb_row );
select id,book,row from tb_book where row >=all (select row from tb_row );









############################################################################
##################################################################### 查询

# concat 联合多个字段，构成一个总的字符串
select id,concat(bookname,":",price) as info,type from tb_mrbook;
# limit 限制行数
select * from tb_mrbook order b price desc limit 3;
# sum()
select sum(price) as total,type from tb_mrbook group by type;




#########################################################################
##################################################################### 查询2

select * from mytable
	where primary_constraint
	group by grouping_columns
	order by sorting_columns
	having secondary_constraint
	limit count;

# in
select * from mytable 
	where name in ("xiaoming","xiaohong","xiaowang");

# between and
select * from table_login where id between 5 and 7;

# 去重
select distinct name from tb_login; // 去除重复行

# exists
select * from tb_login where exists(select * from tb_book where id =21); // exists 返回一个逻辑值，为真时外层开始查询

# like
select * form mytable where user like '%mr%';






时间格式

%S, %s  两位数字形式的秒（ 00,01, ..., 59）
%I, %i  两位数字形式的分（ 00,01, ..., 59）
%H  两位数字形式的小时，24 小时（00,01, ..., 23）
%h  两位数字形式的小时，12 小时（01,02, ..., 12）
%k  数字形式的小时，24 小时（0,1, ..., 23）
%l  数字形式的小时，12 小时（1, 2, ..., 12）
%T  24 小时的时间形式（hh:mm:ss）
%r  12 小时的时间形式（hh:mm:ss AM 或hh:mm:ss PM）
%p  AM或PM
%W  一周中每一天的名称（Sunday, Monday, ..., Saturday）
%a  一周中每一天名称的缩写（Sun, Mon, ..., Sat）
%d  两位数字表示月中的天数（00, 01,..., 31）
%e  数字形式表示月中的天数（1, 2， ..., 31）
%D  英文后缀表示月中的天数（1st, 2nd, 3rd,...）
%w  以数字形式表示周中的天数（ 0 = Sunday, 1=Monday, ..., 6=Saturday）
%j  以三位数字表示年中的天数（ 001, 002, ..., 366）
%U  周（0, 1, 52），其中Sunday 为周中的第一天
%u  周（0, 1, 52），其中Monday 为周中的第一天
%M  月名（January, February, ..., December）
%b  缩写的月名（ January, February,...., December）
%m  两位数字表示的月份（01, 02, ..., 12）
%c  数字表示的月份（1, 2, ...., 12）
%Y  四位数字表示的年份
%y  两位数字表示的年份