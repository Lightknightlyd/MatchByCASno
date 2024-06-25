## advance R handout
# and other tricks


# 1、常用包汇总 -------------------------------------------------------

tidy
library(tibble)
library(tidyr)

transform

library(reshape2)
library(forcats)
library(hms)
library(lubridate)

model
library(broom)
library(modelr)
library(survival)
library(lattice)


# 2、常用函数汇总 ------------------------------------------------------------------

# + assign ------------------------------------------------------------------

# 给指定环境的对象赋值

for(i in 1:6) { #-- Create objects  'r.1', 'r.2', ... 'r.6' --
  nam <- paste("r", i, sep = ".")
  assign(nam, 1:i)
}
ls(pattern = "^r..$")



##-- Global assignment within a function:
myf <- function(x) {
  innerf <- function(x) assign("Global.res", x^2, envir = .GlobalEnv)
  innerf(x+1)
}
myf(3) 
Global.res # 16



a <- 1:4
assign("a[1]", 2)
a[1] == 2          # FALSE
get("a[1]") == 2   # TRUE



# + get ----------------------------------------------------------

# 获取指定环境 中对象的值
get("ce")

# + mget ----------------------------------------------------------
# 与get类似，但是x可以为字符向量，返回list，每个子list对应一个字符

x <- "num"
assign(x,1:3)

x
num
get("x")
mget("x")
get(x)
mget(x)






# + exist ------------------------------------------------------------------

exists("ce")

# 一种易读的定义方法
if (exists("ce", envir = .GlobalEnv)) {
  r <- get("ce", envir = .GlobalEnv)
  ## ... deal with r ...
}

## 另一种定义方法
if (!is.null(r <- get0("ce", envir = .GlobalEnv))) {
  ## ... deal with r ...
}

##  Define a substitute function if necessary:
if(!exists("some.fun", mode = "function")) {  ## mode 表示寻找的是一个函数
  some.fun <- function(x) { cat("some.fun(x)\n"); x }
  
} 

search()  ## 列出当前空间和已加载的包
exists("ls", 2) # true even though ls is in pos = 3
exists("ls", 2, inherits = FALSE) # false  #inherits	should the enclosing frames of the environment be searched?


# + identical ------------------------------------------------------------------

## identical 用来检测两个对象是否完全一样
identical(ls,   get0("ls"))
identical(NULL, get0(".foo.bar.")) # default ifnotfound = NULL (!)



# + && 和& -------------------------------------------------------------------
#& 依次比较两个向量中的对应元素，而&&只比较两个向量的首个元素。
# 这样保证了计算结果只有一个标量，这可以和if等只接受一个标量为参数的函数完美结合

c(TRUE,FALSE) & c(TRUE,FALSE)
c(TRUE,FALSE) && c(TRUE,FALSE)

c(TRUE,FALSE) | c(TRUE,TRUE)
c(TRUE,FALSE) || c(FALSE,TRUE)



# + with --------------------------------------------------------------------
#instead using $
summary(mtcars$mpg)
plot(mtcars$mpg,mtcars$disp)
plot(mtcars$mpg,mtcars$wt)

#we can use:
attach(mtcars)
summary(mpg)
plot(mpg,disp)
plot(mpg,wt)
detach(mtcars)
# or we can use：
with(mtcars,{
  stats<-summary(mpg)
  stats
})
#但是with的赋值只在此函数的括号内有效，可用<<-替代<-来将赋值的对象保存到全局环境中
with(mtcars,{
  nokeepstats<-summary(mpg)
  keepstats<<-summary(mpg)
})



# + cut -------------------------------------------------------------------

hw$weightGroup <- cut(hw$weightLb, breaks=c(-Inf, 100, Inf),labels=c("< 100", ">= 100"))



# + subset ----------------------------------------------------------------

clim<-subset(climate,source=="berkeley",select=c("year","anomaly10y","unc10y"))

# + melt和cast -----------------------------------------------------------------
library(reshape)
names(airquality) <- tolower(names(airquality))
aqm <- melt(airquality, id = c("month","day"),na.rm = T) # id 以外的变量每个形成键值对
cast(aqm, day+month~variable)
cast(aqm, month+day~variable)
cast(aqm, month~variable,mean)
cast(aqm, month~variable,mean,margins=c("grand_row", "grand_col")) #边际均值

~前面是类似索引
~后面是将所列变量的每个值都作为一个新变量

cast(aqm, month+variable~day)


# + spread和gather -----------------------------------------------------------------

library(tidyr)
stocks <- data.frame(
  time = as.Date('2020-01-01') + 0:9,
  x = rnorm(10,0,1),
  y = rnorm(10,0,2),
  z = rnorm(10,0,4)
)

stocksm <- stocks %>%
  gather(stock,price,-time)

stocksm %>% spread(stock,price)
stocksm %>% spread(time,price)

# + rownames_to_column -----------------------------------------------------------------





# 3、缺失值检测和处理 ----------------------------------------------------------------------

all.equal("1","2")  # 不是简单的返回F 或T 而是详细报告差异情况

d45 <- pi*(1/4 + 1:10)
stopifnot(
  all.equal(tan(d45), rep(1, 10)))          # TRUE, but

all.equal(tan(d45), rep(1, 10), tolerance = 0)  # to see difference


###
complete.cases()

x <- airquality[,-1] # x is a regression design matrix
y <- airquality[,1] # y is the corresponding response

stopifnot(complete.cases(y) != is.na(y))
ok <- complete.cases(x,y)  # 如果一条观测没有任何缺失返回T，存在缺失返回F
sum(!ok) # how many are not "ok" ?
x <- x[ok,]
y <- y[ok]

library(mice)
md.pattern(airquality)

####
is.finite(pi / 0 )
pi / 0 ## = Inf a non-zero number divided by zero creates infinity
0 / 0  ## =  NaN  not a number




# 缺失值处理 

## 将缺失值更改为0
na<-function(x){
  ifelse (is.na(x),0, x)
}

v10<-colwise(na)(v9)

## 排除缺失值
x<-c(1,2,NA,5)
y<-sum(x,na.rm=TRUE)##计算之前移除缺失值

na.omit()##删除所有含有缺失数据的行



# 4、基本数学函数 ------------------------------------------------------------------

x <- -1:12
x %% 2 #-- is periodic 取余数
x %/% 5 #取结果整数

##round
Rate_dead_Ent_Y2010t2017<-round(EndEnt_Y2010t2017/NewEnt_Y2010t2017*100,2)


abs
sign
acos
asin
atan
atan2
sin
cos
tan
ceiling
floor
round
trunc
ignif
exp
log
log10
log2
sqrt
max
min
prod
sum
cummax
cummin
cumprod
cumsum
diff
pmax
pmin
range
mean
median
cor
sd
var
rle



# 5、逻辑和集合 ------------------------------------------------------------------


xor
all
any
intersect
union
setdiff
setequal

# in match which 

#%in% 匹配并返逻辑值
1:10 %in% c(1,3,5,9) # 分别判断1：10

#match()匹配并返位置值
match(c(1:10),c(1,3,5,9))

# which() 返回逻辑值为真的位置
which(LETTERS == "R") # LETTERS 是系统存好的字母



# 6、矩阵和矩阵运算 ------------------------------------------------------------------
matrix

length
dim
ncol
nrow
cbind
rbind
names
colnames
rownames
sweep
as.matrix
data.matrix

# 矩阵代数
crossprod
tcrossprod
eigen
qr
svd
outer
rcond

#矩阵转置
t(mat)

#求逆矩阵
solve(mat)

#矩阵相乘
mat %*% mat

#n阶对角矩阵
diag(3)


# 7、创建向量 ------------------------------------------------------------------

rep
rep_len
seq
seq_len
seq_along
Vocabulary
rev
sample
choose
factorial
combn



# 8、列表和数据框 ------------------------------------------------------------------


list
unlist
data.frame
as.data.frame
split
expand.grid


# 9、列联表 ------------------------------------------------------------------

sample_simple2<-data.frame(xtabs(~ViewerID+status,data = sample_simple1))
margin.table(sample_simple2,1) # 边际频数
prop.table(sample_simple2,1) # 边际比例 # 1 表示~ViewerID+status 公式中的第一个变量
addmargins(sample_simple2)
addmargins(prop.table(sample_simple2)) # 添加边际和，默认行列均添加
addmargins(prop.table(sample_simple2),2) # 仅添加行和 1 为仅列和

# 当处理三维及以上的列联表时：

mytable <- xtabs(~treatment + sex + improved,data=Arthritis)
ftable(mytable) # 仅使用xtabs输出的结果很长，不易阅读 ftable可以生成一种更简洁的形式


# 10、控制流 ------------------------------------------------------------------

next
break
switch
stopifnot


# ifelse 的使用 
total_sample2$xianma<-ifelse(is.na(total_sample2$区县编码)==TRUE,total_sample2$xianma,total_sample2$区县编码)

total_sample2<-mutate(total_sample2,newfy_id=ifelse(is.na(total_sample2$访员编号),paste(total_sample2$xianma,"01",sep = ""),total_sample2$访员编号))


indco4_3<-mutate(indco4_2,indco_3=ifelse((indco4_2$indco_4<=999),substr(indco4_2$indco_4,1,2),substr(indco4_2$indco_4,1,3)))
indco4_4<-mutate(indco4_3,indco_2=ifelse((indco4_3$indco_4<=999),substr(indco4_3$indco_4,1,1),substr(indco4_3$indco_4,1,2)))

out_sample_exist1<-mutate(out_sample_exist,number_c=ifelse(number<10,paste("00",number,sep=""),(ifelse(number<100,paste("0",number,sep=""),number))))


# 流程循环控制

#repeat
i<-5
repeat{if(i>25)break else {print(i);i<-i+5;}}

#while
i<-5
while(i<=25){print(i);i<-i+5}

#for 

for(i in seq(from=5,to=25,by=5))print(i)

#foreach
sqrts.1to5<-foreach(i=1:5) %do% sqrt(i)  ###顺序执行
sqrts.1to5<-foreach(i=1:5) %dopar% sqrt(i)  ###并行执行

###sapply
v<-1:20
w<-NULL
for (i in 1:length(v)){w[i]<-v[i]^2}
#
v<-1:20
w<-sapply(v,function(i){i^2})




# 11、管道函数 与 排序 ---------------------------------------------------------------

unique
rank
quantile
sort

v23<-v22%>% 
  group_by(YEAR_REG)%>% 
  mutate(rank_trademark=row_number(desc(TRADEMARK_INDEX)))%>%
  arrange(rank_trademark)

sample_simple_v1<- sample_all%>%
  group_by(CountyCode)%>%
  mutate(number=row_number(desc(CountyCode)))%>%
  arrange(CountyCode)

sample_all<-arrange(sample_all,ProvinceCode_V2018,CityCode_V2018,CountyCode_V2018)

###排序
newdata<-leadership[order(leadership$age),]

attach(leadership)
newdata<-leadership[order(gender,-age),]
detach(leadership)




# 12、去重 ----------------------------------------------------------------------
index<-duplicated(total_sample5[,1])
total_sample6<-total_sample5[!index,]
total_sample_repeated<-total_sample5[index,]




# 13、线性模型相关函数  ------------------------------------------------------------------

fitted()
predict()
resid()
rstandard()
lm()
glm()
hat()
influence.measures()
logLik()
df()
deviance()
formula()
anova()
coef()
confint()
vcov()
contrasts()




# 14、工作空间   ------------------------------------------------------------------

#列出环境中的对象
ls()  # 查看已有对象
ls.str() # 已有对象分别看str()信息

installed.packages()   # 以安装的包
(.packages())   # 已加载的包
exists()
rm()
getwd()
setwd()
q()
source()
require()
file.edit()


# 15、用于函数的函数 ------------------------------------------------------------------

missing
on.exit
return
invisible


# 16、调试 ------------------------------------------------------------------


traceback()
browser()
recover()
options(error = )
stop()
warning()
message()
tryCatch()
try()



# 17、自建函数 --------------------------------------------------------------------


# Given a model, predict values of yvar from xvar 
# This supports one predictor and one predicted variable 
# xrange: If NULL, determine the x range from the model object. If a vector with 
#   two numbers, use those as the min and max of the prediction range. 
# samples: Number of samples across the x range. 
# ...: Further arguments to be passed to predict()
predictvals  <-  function(model,  xvar,  yvar,  xrange=NULL,  samples=100,  ...)  { 
  # If xrange isn't passed in, determine xrange from the models. # Different ways of extracting the x range, depending on model type 
  if  (is.null(xrange))  {
    if  (any(class(model)  %in%  c("lm",  "glm")))
      xrange  <- range(model$model[[xvar]])
    else  if  (any(class(model)  %in%  "loess"))
      xrange  <- range(model$x) }   
  newdata  <- data.frame(x  =  seq(xrange[1],  xrange[2],  length.out  =  samples))   
  names(newdata)  <- xvar   
  newdata[[yvar]]  <- predict(model,  newdata  =  newdata,  ...)   
  newdata 
}




#函数的组成部分
#函数体
#形参列表
#环境  函数自身的环境，储存着函数内部定义的变量

f <- function(x) x^2
f
formals(f)
body(f)
environment(f)

#像R 语言中的所有对象一样，函数还可以拥有任意数量的附加属性。 被基础R 语
#言使用的一个属性，称为"srcref"，它是源引用(source reference)的简称，它指向
#用于创建函数的源代码



is.function(f)  # 判断是否是函数
is.primitive(sum) #判断是否是原语函数--直接调用C语言代码

#一下代码创建了base包中所有函数的列表
objs <- mget(ls("package:base"),inherits = T)

##----词法作用域
#-1名字屏蔽  
# 如果一个名字在函数中没有定义，那么R 语言将向上一个层次查找

x <- 2
g <- function() {
  y <- 1
  c(x, y)
}
g()


#2-函数和变量   
#和搜索变量一样，函数内部定义的对象优先级更高

n <- function(x) x / 2
o <- function() {
  n <- 10
  n(n)
}
o()
rm(n, o)

#3-全新的开始状态  
#函数内部定义的对象每次执行完都会归零，然后下一次调用时重新创建出来


#4-动态查找 
#R 语言在函数运行时查找值，而不是在函数创建时查找值
#这意味着，函数的输出是可以随着它所处的环境外面的对象，而发生变化的
f <- function() x
x <- 15
f()
#> [1] 15
x <- 20
f()
#> [1] 20


### 所有操作都是函数调用
x <- list(1:3, 4:9, 10:12)
sapply(x, "[", 2)
#> [1] 2 5 11
# 相当于
sapply(x, function(x) x[2])
#> [1] 2 5 11


##----函数参数

#函数匹配参数的顺序是：首先是精确的名称匹配(完美匹配)，然后通过前缀匹配，最后通过位置匹配。
#####  不同参数并行传入函数
##  给定一个参数列表来调用函数
#假设你有一个函数的参数列表：

args <- list(1:10, na.rm = TRUE)

# 怎样把这个列表传递给mean()函数呢？ 这时候，你需要do.call()函数：
do.call(mean, args)

# 由于在R语言中参数都是延迟计算的，所以参数的默认值可以使用其它参数来定义

g <- function(a = 1, b = a * 2) { 
  c(a, b) 
} 

g()

# 默认情况下，R语言函数的参数是延迟计算的。 仅当实际用到这些参数的时候，它们才会被计算出来：

f <- function(x){
  force(x)  # 必须传入参数，否则报错
  10
}
f()

#---
add <- function(x) {
  function(y) x + y
}

adders <- lapply(1:10, add) #返回10个function

adders[[1]](10) # adders里第一个函数传入10，注意这个函数中的x已经有值为1了，因此在调用函数时必须考虑函数环境中的值


#----延迟性

if (is.null(a)) stop("a is null")

#> Error: a is null

#你可以这样写:

!is.null(a) || stop("a is null")

#> Error: a is null


#### 中辍函数

#-- 一般的函数名位于参数前面，而中缀函数则位于参数中间



#### 替换函数

# 如： 将一个值替换为其他
names()


####  return

#在函数中定义一个已存在对象的值，不会真的改变这个对象

f <- function(x) {
  x$a <- 2
  x
}

x <- list(a = 1)

f(x)

x$a



#### 退出时

#除了返回一个值以外，在函数结束时，函数也可以使用on.exit()函数，表示函数结束时执行操作

#----------例1
in_dir <- function(dir, code) {
  old <- setwd(dir)
  on.exit(setwd(old))
  force(code)
}
getwd()

in_dir("~", getwd())



#----------例2

capture.output2 <- function(code) {
  temp <- tempfile()
  on.exit(file.remove(temp), add = TRUE)
  sink(temp)
  on.exit(sink(), add = TRUE)
  force(code)
  readLines(temp)
}
capture.output2(cat("a", "b", "c", sep = "\n"))




error_t <- function(){
  stop("what!")
}

error_t()




# 18、输入和输出数据  ------------------------------------------------------------------
# data.table包和sparkR fastR 读写数据的性能研究


# 导入数据

## 手动赋值

x<<-3  #这一操作能强制赋值给一个全局变量，而不是局部变量


for(i in 1:3){
  assign(paste("p", i, sep=""), i) # assign 可以在循环中进行方便赋值
  tmp <- get(paste("p", i, sep=""))
  print(tmp)
}


#生成数列
seq<-seq(from=1,to=5,by=2) # 间隔取数
seq<-rep(1,time=5) # 重复取数

mydata<-data.frame(age=numeric(0),gender=character(0),weight=numeric(0))

mydata<-edit(mydata)####or fix(mydata)

####  读取文件
library(readr) # Read Rectangular Text Data

read_delim(file, delim, quote = "\"", escape_backslash = FALSE,
           escape_double = TRUE, col_names = TRUE, col_types = NULL,
           locale = default_locale(), na = c("", "NA"), quoted_na = TRUE,
           comment = "", trim_ws = FALSE, skip = 0, n_max = Inf,
           guess_max = min(1000, n_max), progress = show_progress(),
           skip_empty_rows = TRUE)

read_delim("a|b\n1.0|2.0", delim = "|")


read_csv(file, col_names = TRUE, col_types = NULL,
         locale = default_locale(), na = c("", "NA"), quoted_na = TRUE,
         quote = "\"", comment = "", trim_ws = TRUE, skip = 0,
         n_max = Inf, guess_max = min(1000, n_max),
         progress = show_progress(), skip_empty_rows = TRUE)


read_csv2() # 分号分隔 read_csv2("a;b\n1,0;2,0")
 
read_tsv() # tab分隔 read_tsv("a\tb\n1.0\t2.0")






library(readxl)
library(haven)
library(httr)
library(rvest)
library(xml2)
library(foreign)
library(readstata13)
library(data.table)

print()
cat()
message()
warning()
dput()
format()
sink()
capture.output()



##read in a file
data<-read.csv("datafile.csv")
##if the data does not have headers in the first row
data<-read.csv("datafile.csv",header=FALSE)
##manually assign the header names
names(data)<-c("column1","column2","column3")
##R will automaticly treat strings as factors ,to prevent this
data<-read.csv("datafile.csv",stringAsFactors=FALSE)
##if you want to load data from an Excel file

##only the first sheet of an Excel
install.packages("xlsx")
library(xslx)
data<-read.xlsx("datafile.xlsx",1)

##for .xls
install.package("gdata")
library(gdata)
data<-read.xls("datafile.xls")

##其他读取方式
library(openxlsx)
data<-read.xlsx("datafile.xlsx")

##stata数据
library(readstata13)
data_test<-read.dta13("毕业数据.dta",convert.factors = TRUE,generate.factors = TRUE)
data_test$time<-paste("01",substr(data_test$time,1,2),"/",substr(data_test$time,4,7),sep = "")
data_test$time<-as.Date(data_test$time,"%d%m/%Y")

##
library(foreign)
mydataframe<-read.dta("mydata.dta")


# 读写数据
data
count.fields
read.csv
write.csv
read.delim
write.delim
read.fwf
readLines
writeLines
readRDS
saveRDS
load
save
library(foreign)





# 19、文件和路径 ------------------------------------------------------------------

dir()
basename()
dirname()
tools::file_ext()
file.path()
path.expand()
normalizePath()
file.choose()
file.copy()
file.create()
file.remove()
file.rename()
dir.create()
file.exists()
file.info()
tempdir()
tempfile()
download.file()
library(downloader)





# linux 公共包和私有包
# 不同的用户 初始包路径不同，如用yuedong登录可以执行的，用root就不一定能执行，
# 因为root包路径只包含R安装路径下的包，要附加yuedong的私用包，使用以下命令：

.libPaths(c(.libPaths(),"/home/yuedong/R/x86_64-redhat-linux-gnu-library/3.6")) 
# R包会默认安装到第一个路径下,每次启动R都要附加一遍

.libPaths()
[1] "/cluster/apps/R/3.5.1/lib64/R/library" "/cluster/home/jlu/R/x86_64-unknown-linux-gnu-library/3.5.1" 
[3] "/usr/local/lib64/R/library"






# 20、执行R脚本文件 -----------------------------------------------------------------
sink ("myoutput",append=TRUE,split=TRUE) ###结果输出到文本
pdf("mygraphs.pdf")
source("script2.R") ##文件script2中的代码将执行，结果也将显示在屏幕上。除此之外，文本输出将被追加到myoutput中，图形输出将保存到文件mygraphs.pdf中

##
sink()
dev.off()
source("script3.R") #脚本文件将被执行，结果仅显示在屏幕上






# 21、随机抽样 --------------------------------------------------------------------

set.seed(42)
capital_sample3301_s100<-capital_pro_sample3301[sample(1:nrow(capital_pro_sample3301),100,replace = FALSE),]
capital_sample2101_s100<-capital_pro_sample2101[sample(1:nrow(capital_pro_sample2101),100,replace = FALSE),]



#分层抽样
library(sampling)

strata(data,stratanames=NULL,size,method=c("srswor","srswr","poisson","systematic"),pik,description=FALS)

#stratanames: 进行分层所依据的变量名称。

#size: 各层中要抽出的观测样本数。

#method: 选择4中抽样方法，分别为无放回、有放回、泊松、系统抽样，默认为srswor。

#pik: 设置各层中样本的抽样概率。

#description: 选择是否输出含有各层基本信息的结果。


#####################   example
#A、B、C分别为分类变量

#A有2个分类变量，B有5个分类变量，C有2个分类变量

#第一步按照这三个变量进行排序

sourui=sourui[order(sourui$A,sourui$B,sourui$C),]

#第二步筛选变量，size参数对应20个比例20=2*5*2，比例可以自己设置

sub_train=strata(sourui,stratanames=c("A","B","C"),
                 size=c(21,269,806,2325,3420,1972,2474,1500,1419,741,3,7,58,42,313,70,685,209,696,210),
                 method="srswor")

#第三步：分为训练集和测试集，ID_unit变量在第二步产生。

data_train <- sourui[sub_train$ID_unit,]
data_test<- sourui[-sub_train$ID_unit,]




# 22、帮助 -------------------------------------------------------------------

help.search
apropos
RSiteSearch
citation
demo
example
vignette




# 23、ddply 应用 ---------------------------------------------------------------
each_cnty_situ1<-ddply(each_cnty_situ,.(CountyCode_V2018,行业),summarize,sum_ind=sum(end_mark))
each_cnty_situ2<-ddply(each_cnty_situ1,.(CountyCode_V2018),summarize,sum_cnty=sum(sum_ind))

v12<-ddply(v11_percapital,.(YEAR_REG),transform, 
           V1_INVENTION_index=(log(V1_INVENTION+0.01)-mean(log(V1_INVENTION+0.01)))/sd(log(V1_INVENTION+0.01)),
           V1_UTILITY_index=(log(V1_UTILITY+0.01)-mean(log(V1_UTILITY+0.01)))/sd(log(V1_UTILITY+0.01)),
           V1_DESIGN_index=(log(V1_DESIGN+0.01)-mean(log(V1_DESIGN+0.01)))/sd(log(V1_DESIGN+0.01)),
           V1_TRADEMARK_index=(log(V1_TRADEMARK+0.01)-mean(log(V1_TRADEMARK+0.01)))/sd(log(V1_TRADEMARK+0.01)),
           V1_NEWFIRM_index=(log(V1_NEWFIRM+0.01)-mean(log(V1_NEWFIRM+0.01)))/sd(log(V1_NEWFIRM+0.01)),
           V1_OUTINV_index=(log(V1_OUTINV+0.01)-mean(log(V1_OUTINV+0.01)))/sd(log(V1_OUTINV+0.01)),
           V1_OUTPERSON_index=(log(V1_OUTPERSON+0.01)-mean(log(V1_OUTPERSON+0.01)))/sd(log(V1_OUTPERSON+0.01)),
           V1_VCPE_index=(log(V1_VCPE+0.01)-mean(log(V1_VCPE+0.01)))/sd(log(V1_VCPE+0.01)),
           V1_VCPE_C_index=(log(V1_VCPE_C+0.01)-mean(log(V1_VCPE_C+0.01)))/sd(log(V1_VCPE_C+0.01)),
           V1_PERSON_index=(log(V1_PERSON+0.01)-mean(log(V1_PERSON+0.01)))/sd(log(V1_PERSON+0.01)))

v13<-ddply(v12,.(YEAR_REG), transform,
           IEI_INDICATOR=(1/8)*V1_INVENTION_index+(3/40)*V1_UTILITY_index+(1/20)*V1_DESIGN_index+
             (3/20)*V1_TRADEMARK_index+
             (1/10)*V1_NEWFIRM_index+ 
             (3/40)*V1_OUTINV_index+(3/40)*V1_OUTPERSON_index+
             (1/8)*V1_VCPE_index+(1/8)*V1_VCPE_C_index+
             (1/10)*V1_PERSON_index,
           OUT_INDICATOR=(1/2)*V1_OUTINV_index+(1/2)*V1_OUTPERSON_index,
           VCPE_INDICATOR=(1/2)*V1_VCPE_index+(1/2)*V1_VCPE_C_index,
           PATENT_INDICATOR=(1/2)*V1_INVENTION_index+(3/10)*V1_UTILITY_index+(1/5)*V1_DESIGN_index)

v14<-ddply(v13,.(YEAR_REG),transform, 
           standard_IEI_INDICATOR=(IEI_INDICATOR-mean(IEI_INDICATOR))/sd(IEI_INDICATOR),
           standard_NEWFIRM_INDICATOR=(V1_NEWFIRM_index-mean(V1_NEWFIRM_index))/sd(V1_NEWFIRM_index),
           standard_OUT_INDICATOR=(OUT_INDICATOR-mean(OUT_INDICATOR))/sd(OUT_INDICATOR),
           standard_VCPE_INDICATOR=(VCPE_INDICATOR-mean(VCPE_INDICATOR))/sd(VCPE_INDICATOR),
           standard_ENTREPRENUR_INDICATOR=(V1_PERSON_index-mean(V1_PERSON_index))/sd(V1_PERSON_index),
           standard_PATENT_INDICATOR=(PATENT_INDICATOR-mean(PATENT_INDICATOR))/sd(PATENT_INDICATOR),
           standard_TRADEMARK_INDICATOR=(V1_TRADEMARK_index-mean(V1_TRADEMARK_index))/sd(V1_TRADEMARK_index))

v15<-ddply(v14,.(YEAR_REG),transform, 
           IEI_INDEX=100*pnorm(standard_IEI_INDICATOR,0,1),
           NEWFIRM_INDEX=100*pnorm(standard_NEWFIRM_INDICATOR,0,1),
           OUT_INDEX=100*pnorm(standard_OUT_INDICATOR,0,1),
           VCPE_INDEX=100*pnorm(standard_VCPE_INDICATOR,0,1),
           ENTREPRENUR_INDEX=100*pnorm(standard_ENTREPRENUR_INDICATOR,0,1),
           PATENT_INDEX=100*pnorm(standard_PATENT_INDICATOR,0,1),
           TRADEMARK_INDEX=100*pnorm(standard_TRADEMARK_INDICATOR,0,1))







# 24、批量读取当前文件夹与合并 -----------------------------------------------------------------

list.files(pattern ="*.R")
temp1<-list.files(pattern ="*.xlsx")

zhejiang_first_time<-read.xlsx(paste(temp1[1]))       
for(i in 2:length(temp1)){zhejiang_first_time=rbind(zhejiang_first_time,read.xlsx(paste(temp1[i])))}  




# 25、按省份代码分段输出文件 -------------------------------------------------------------

for(i in 300000:340000){
  if(nrow(subset(zhejiang_all_v3,zhejiang_all_v3$CountyCode_V2018==i))!=0){
    write.xlsx(subset(zhejiang_all_v3,zhejiang_all_v3$CountyCode_V2018==i),paste(i,".xlsx"))
  }
}




# 26、截取样本编号后缀 ----------------------------------------------------------------
library(openxlsx)
answer_sa1_v2<-read.xlsx("answer_sa1_v2.xlsx")
library(plyr)
answer_sa1_v3<-mutate(answer_sa1_v2,sample_id=substr(样本编号,1,10),suffix=gsub("[0-9.*]{10}","",answer_sa1_v2$样本编号))
answer_sa1_v3_formal<-subset(answer_sa1_v3,suffix!="test"&suffix!="testv2"&nchar(sample_id)==10)




# 27、计算每一行某个关键字出现的数量 ---------------------------------------------------------
library(dplyr)

miss_sum1<-data.frame(miss_sum=sum(is.na(data_touch_sample2[1,])))
for(i in 2:49252){miss_sum1=rbind(miss_sum1,data.frame(miss_sum=sum(is.na(data_touch_sample2[i,]))))}  

library(stringr)
unknow_sum1<-data.frame(unknow_sum=sum(str_count(data_touch_sample2[1,],c("不知道")),na.rm=TRUE))
for(i in 2:49252){unknow_sum1=rbind(unknow_sum1,data.frame(unknow_sum=sum(str_count(data_touch_sample2[i,],c("不知道")),na.rm=TRUE)))}  

refuse_sum1<-data.frame(refuse_sum=sum(str_count(data_touch_sample2[1,],c("拒答")),na.rm=TRUE))
for(i in 2:49252){refuse_sum1=rbind(refuse_sum1,data.frame(refuse_sum=sum(str_count(data_touch_sample2[i,],c("拒答")),na.rm=TRUE)))}  

data_touch_sample3_1<-cbind(data_touch_sample,miss_sum1)
data_touch_sample3_2<-cbind(data_touch_sample3_1,unknow_sum1)
data_touch_sample3_3<-cbind(data_touch_sample3_2,refuse_sum1)




# 28、根据关键词分组 str_detect ------------------------------------------------------
sample_addr3<-within(sample_addr2,{
  areatype<-NA
  areatype[str_detect(sample_addr2$详细地址,"市")&str_detect(sample_addr2$详细地址,"区")&str_detect(sample_addr2$详细地址,"路")]<-"城区"
  areatype[str_detect(sample_addr2$详细地址,"开发区")|str_detect(sample_addr2$详细地址,"工业")]<-"城区"
  areatype[str_detect(sample_addr2$详细地址,"广场")]<-"城区"
  areatype[str_detect(sample_addr2$详细地址,"县")]<-"乡镇"
  areatype[str_detect(sample_addr2$详细地址,"镇")]<-"乡镇"
  areatype[str_detect(sample_addr2$详细地址,"乡")]<-"乡镇"
  areatype[str_detect(sample_addr2$详细地址,"村")]<-"农村"
  areatype[is.na(areatype)]<-"乡镇"
  
})












# 二、数据类型 -------------------------------------------------------------------


# 向量 ----------------------------------------------------------------------

######原子向量：逻辑类型、整数类型、双精度类型（数值类型）、和字符类型，也有复数类型和raw类型
dbl_var<-c(1,2.5,4.5)
#使用L后缀，可以得到整数而不是双精度
int_var<-c(1L,6L,19L)
#使用TRUE FALSE 来创建逻辑向量
log_var<-c(TRUE,FALSE,T,F)

chr_var<-c("these are","some strings")

##原子向量总是平的（flat）即使是嵌套起来

#######类型和测试
##  typeof()
#住：is.numeric()对整数和双精度向量都会返回TRUE

## 强制转换




# 矩阵 ----------------------------------------------------------------------
thedata<-c(2,4,42,3,6,13,6,4,8,3,74,34)
mat<-matrix(thedata,3,3,byrow = T)

#矩阵转置
t(mat)

#求逆矩阵
solve(mat)

#矩阵相乘
mat %*% mat

#n阶对角矩阵
diag(3)



# 列表 ----------------------------------------------------------------------

g<-"My First List"
h<-c(25,26,2,56)
j<-matrix(1:10,nrow=5)
k<-c("one","two","three")
mylist<-list(title=g,age=h,j,k)

#输出列表中的特定成分
mylist[[2]]
mylist[["ages"]]





# 因子 ----------------------------------------------------------------------

status<-factor(status,order=TRUE,levels=c("Poor","Improved","Excellent"))

kids = factor(c(1,0,1,0,0,0), levels = c(0, 1),labels = c("boy", "girl"))

#不幸的是,在R语言中,大多数的数据读取函数会自动地把字符向量转换成因
#子.这种方式挺理想化的,因为这些函数并没有办法知道所有的因子水平,以及
#因子水平最合理的排序方式.我们可以使用stringsAsFactors = FALSE参数来避免这种行为.
#######值标签
patientdata$gender<-factor(patientdata$gender,levels=c(1,2),labels=c("male","female"))

################  to change factors' level value
birthwt$smoke<-factor(birthwt$smoke)
levels(birthwt$smoke)
library(plyr)#For the revalue()function
birthwt$smoke<-revalue(birthwt$smoke,c("0"="No Smoke","1"="Smoke"))





# 数据框 ---------------------------------------------------------------------

cbind() #横向
rbind() #纵向

#####指定列命
patientdata<-data.frame(patientID,age,diabetes,status,row.names=patientID)

######重命名变量
names(leadership)[6:10]<-c("item1","item1","item1","item1")



