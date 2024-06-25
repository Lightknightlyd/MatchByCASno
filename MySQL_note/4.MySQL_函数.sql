

#################################################################################
####################################################################  函数

#### 数学函数

ABS() //求绝对值
FLOOR() //返回小于或等于x的最大整数
RAND() //返回0-1 随机数
PI() //返回圆周率
TRUNCATE(x,y) //返回x保留到小数点后y位的值
ROUND(X) //返回离x最近的整数，即四舍五入
ROUND(X,Y) //返回x保留到小数点后y位的值
SQRT() //求平方根

## 字符串函数
INSERT(S1,X,LEN,S2) //将字符串S1中x位置开始长度为len的字符串用s2替换
UPPER(S) //变成大写
UCASE(S) //变成大写
LEFT(s,n) //返回字符串s的前n个字符

RTRIM(s) //用去去掉字符串s结尾处的空格

SUBSTRING(S,N,LEN) //从S的第N个位置开始截取长度为LEN的字符串
reverse(s) //将S的顺序翻转过来
field(s,s1,s2,...) //用于返回第一个与字符串s一样的字符串的位置（即第几个s1,s2,...）

select locate('me','you love me,she love me');
select position('me' in 'you love me,she love me'); // 获取me的起始位置

## 时间函数

curdate()
current_date() //获取当前日期

curtime()
current_time() //获取当前时间

now()
localtime()
sysdate() //当前日期和时间

datediff(d1,d2) //计算相隔的天数
adddate(d,n) //返回日期d加上n天的日期
subdate(d,n) //d减去n天

# 条件判断函数
if(expr,v1,v2)

# 如果expr1成立则...
case when expr1 then v1
	 when expr2 then v2
	 ...
	 else v
end

# 如果expr取值为e1则...
case expr when e1 then v1
		  when e2 then v2
		  ...
		  else v
end





# 加密函数
select password('abc'); //不可逆,主要给账户的密码加密
select md5('abcd'); //主要给普通的数据加密




### 存储函数

delimiter //
create function name_of_student (std_id int)
	result varchar(50)
	begin
		return(select name from studentinfo where sid=std_id);
	end
	//
delimiter;


