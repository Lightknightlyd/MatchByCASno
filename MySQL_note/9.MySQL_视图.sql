##################################################################
##########################################################  视图

# 查看用户是否具有创建视图的权限
select Selete_priv,Create_view_priv from mysql.user where user='用户名';

# 创建视图
create view book_view1(v_sort,v_talk,v_books) as
	select sort,talk,books from tb_book;

# 创建视图2 在两张表上
create algorithm=merge
	view book_view2(v_sort,v_talk,v_books,v_name) as 
	select sort,talk,books,tb_user.name
	from tb_book,tb_name where tb_book.id=tb_name.id
	with local check option;

# 查看视图
desc 视图名;

show create view 视图名;

# 修改视图
create or replace view view(...)...
alter view book_view1(...)...

# 更新视图
更新视图其实是通过视图去修改原表

update book_view1 set v_sort='科幻',v_book='三体' where id=123;

不能更新的情形：
含有count()\sum()\max()\min()
union\union all\distinct\group by\having
常量视图；
视图中的select中包含子查询；
视图导出的视图；
algorithm 为temptable

# 删除视图

drop view if exists book_view1;

