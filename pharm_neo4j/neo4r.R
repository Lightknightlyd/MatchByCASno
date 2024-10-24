# neo4j 试验

library(neo4r)
library(dplyr)
library(RMySQL)
library(magrittr) # 管道函数

con <- neo4j_api$new(
  url = "http://www.yuedong.site:7474",
  user = "neo4j",
  password = rstudioapi::askForPassword()
)


# 能否ping通
con$ping()





# 使用excel表格和neo4j，表格中设置一个mark用来区别是否导入neo4j

# 1. 数据操作 -----------------------------------------------------------------


# + a. 新建标签 添加节点 --------------------------------------------------------------


# 一条向量转换为cypher语句 （可用于创建新记录，也可用于match）

# vec_to_cypher(iris[1,1:3],"Species")

# vec_to_cypher_with_var(iris[1,1:3],"Species",a)


###############################################################################################
##############################################################################################
# 例子

customer_name <- "SV AGROFOOD "
customer_country <- "Russia"
supplier_name <- "Suzhou Vitajoy Bio-Tech"
supplier_country <- "China"

Cypher_Customer <- c(name=customer_name,country=customer_country)
Cypher_Supplier <- c(name=supplier_name,country=supplier_country)
# 新建标签
#paste("CREATE", vec_to_cypher(Cypher_Person, "Person")) %>%
#  call_neo4j(con)
# 已有标签中添加节点
paste("MERGE", vec_to_cypher(Cypher_Customer, "CUSTOMER")) %>%
  call_neo4j(con)
paste("MERGE", vec_to_cypher(Cypher_Supplier, "SUPPLIER")) %>%
  call_neo4j(con)
# + b. 添加关系 --------------------------------------------------------------
#  SUPPLY

paste("match (a:CUSTOMER),(b:SUPPLIER) where a.name =", "\'",customer_name, "\'","and b.name =", "\'",supplier_name, "\'","create (b)-[:`SUPPLY`]->(a);",sep = "")%>%
  call_neo4j(con)

####################################################################################################
####################################################################################################
# 工厂到贸易商

supplier_name2 <- "FUFENG GROUP"
supplier_country2 <- "China"
supplier_name <- "Suzhou Vitajoy Bio-Tech"
supplier_country <- "China"

Cypher_Customer <- c(name=supplier_name,country=supplier_country)
Cypher_Supplier <- c(name=supplier_name2,country=supplier_country2)
# 新建标签
#paste("CREATE", vec_to_cypher(Cypher_Person, "Person")) %>%
#  call_neo4j(con)
# 已有标签中添加节点
paste("MERGE", vec_to_cypher(Cypher_Customer, "SUPPLIER")) %>%
  call_neo4j(con)
paste("MERGE", vec_to_cypher(Cypher_Supplier, "SUPPLIER")) %>%
  call_neo4j(con)
# + b. 添加关系 --------------------------------------------------------------
#  SUPPLY

paste("match (a:SUPPLIER),(b:SUPPLIER) where a.name =", "\'",supplier_name, "\'","and b.name =", "\'",supplier_name2, "\'","create (b)-[:`SUPPLY`]->(a);",sep = "")%>%
  call_neo4j(con)

####################################################################################################
####################################################################################################



# + d. delete 删除节点和关系 --------------------------------------------------------------

'MATCH p=()-[r:`君主`]->(b:Country)
  where b.country="卫国"
  delete p;' %>%
  call_neo4j(con) # 删除两个节点、一个关系


'MATCH p=()-[r:`君主`]->(b:Country)
  where b.country="卫国"
  delete r; ' %>%
  call_neo4j(con) # 只删除一个关系



# + e. remove 添加或删除属性 --------------------------------------------------------------

'match (n:Country) where id(n)=43 set n.survive ="1046BC-256BC";' %>%
  call_neo4j(con)  #新增或者修改一个属性


'match (n:Person) where id(n)=24 remove n.age;' %>%
  call_neo4j(con)   #删除一个属性












# 2. 数据查询 ------------------------------------------------------------------


# + a. 使用id查询 --------------------------------------------------------------

'match (n:Person) where id(n)=24 return n' %>%
  call_neo4j(con) %>%
  as.data.frame()  # 通过id来筛选



# 写入MySQL -----------------------------------------------------------------

event <- 'match (n:Event) return n' %>%
  call_neo4j(con) %>%
  as.data.frame()%>%
  select(n.name,n.ref,n.year,n.impact)

names(event)[1:4] <- c("NAME", "REF", "YEAR", "IMPACT")

event$NAME <- iconv(event$NAME,from = "gbk", to="UTF8")
event$REF <- iconv(event$REF,from = "gbk", to="utf-8")
event$YEAR <- iconv(event$YEAR,from = "gbk", to="utf-8")
event$IMPACT <- iconv(event$IMPACT,from = "gbk", to="utf-8")


dbWriteTable(conn,"Cypher_Event",event,append=T,row.names=F)




# 关系导入MySQL


rel1 <- 'match (a)-[r:`君主`]->(b) return a.name,b.country,id(r);' %>%  # endnode(r),id(r),type(r)
  call_neo4j(con)%>%
  as.data.frame()%>%
  select(NAME="value",RULER="value.1",ID="value.2")

rel2 <- 'match (a)-[r:`大夫`]->(b) return a.name,b.country,id(r);' %>%  # endnode(r),id(r),type(r)
  call_neo4j(con)%>%
  as.data.frame()%>%
  select(NAME="value",COURTIER="value.1",ID="value.2")
  
rel3 <- 'match (a)-[r:`战胜`]->(b) return a.name,b.name,id(r);' %>%  # endnode(r),id(r),type(r)
  call_neo4j(con)%>%
  as.data.frame()%>%
  select(NAME="value",DEFEAT="value.1",ID="value.2")

rel4 <- 'match (a)-[r:`战败`]->(b) return a.name,b.name,id(r);' %>%  # endnode(r),id(r),type(r)
  call_neo4j(con)%>%
  as.data.frame()%>%
  select(NAME="value",BEATED="value.1",ID="value.2")

rel5 <- 'match (a)-[r:`游说`]->(b) return a.name,b.name,id(r);' %>%  # endnode(r),id(r),type(r)
  call_neo4j(con)%>%
  as.data.frame()%>%
  select(NAME="value",PERSUADE="value.1",ID="value.2")

rel6 <- 'match (a)-[r:`被说`]->(b) return a.name,b.name,id(r);' %>%  # endnode(r),id(r),type(r)
  call_neo4j(con)%>%
  as.data.frame()%>%
  select(NAME="value.1",PERSUADED="value",ID="value.2")


rel7 <- 'match (a)-[r:`参与`]->(b) return a.name,b.name,id(r);' %>%  # endnode(r),id(r),type(r)
  call_neo4j(con)%>%
  as.data.frame()%>%
  select(NAME="value",PARTICI="value.1",ID="value.2")

rel8 <- 'match (a)-[r:`弑杀`]->(b) return a.name,b.name,id(r);' %>%  # endnode(r),id(r),type(r)
  call_neo4j(con)%>%
  as.data.frame()%>%
  select(NAME="value",SLAY="value.1",ID="value.2")

rel9 <- 'match (a)-[r:`生子`]->(b) return a.name,b.name,id(r);' %>%  # endnode(r),id(r),type(r)
  call_neo4j(con)%>%
  as.data.frame()%>%
  select(NAME="value",PARENT="value.1",ID="value.2")

rel <- merge(rel1,rel2,by=c("ID","NAME"),all = T)
rel <- merge(rel,rel3,by=c("ID","NAME"),all = T)
rel <- merge(rel,rel4,by=c("ID","NAME"),all = T)
rel <- merge(rel,rel5,by=c("ID","NAME"),all = T)
rel <- merge(rel,rel6,by=c("ID","NAME"),all = T)
rel <- merge(rel,rel7,by=c("ID","NAME"),all = T)
rel <- merge(rel,rel8,by=c("ID","NAME"),all = T)
rel <- merge(rel,rel9,by=c("ID","NAME"),all = T)



dbWriteTable(conn,"Cypher_Relation",rel,overwrite=T,row.names=F)





# 写入图库 --------------------------------------------------------------------




new_data <- dbGetQuery(conn,"select * from Cypher_Country;") # 获取新的全部数据


old_data <- 'match (n:Country) return n' %>%
  call_neo4j(con) %>%
  as.data.frame()   # 获取图库中已有数据

new_data <- merge(new_data,old_data,
      by.x = "COUNTRY",by.y = "n.country",all = T)%>%
  filter(is.na(n.survive)==T)%>% # 筛选出新数据
  select("COUNTRY","SURVIVE")
names(new_data) <- c("country","survive")


# 将新数据导入图库
for (i in 1:nrow(new_data)) {
  paste("MERGE", vec_to_cypher(new_data[i,], "Country")) %>%
    call_neo4j(con)
}




# + b. IN 查询 --------------------------------------------------------------


'MATCH (e:Person) 
  WHERE e.name IN ["范宣子","卫桓公"]
  RETURN e.survive;' %>%
  call_neo4j(con) %>%
  as.data.frame()





# + c. sorting --------------------------------------------------------------

Event <- 'MATCH (e:Event) 
  RETURN e
  ORDER BY e.year DESC;' %>%
  call_neo4j(con) %>%
  as.data.frame()









# union 多表堆叠 --------------------------------------------------------------

MATCH (cc:CreditCard)
RETURN cc.id as id,cc.number as number,cc.name as name,
cc.valid_from as valid_from,cc.valid_to as valid_to
UNION
MATCH (dc:DebitCard)
RETURN dc.id as id,dc.number as number,dc.name as name,
dc.valid_from as valid_from,dc.valid_to as valid_to


# union:不返回重复 union all:返回重复










# + e. 聚合 ----------------------------------------------------------------

'MATCH (e:Person) 
  RETURN COUNT(*);' %>%
  call_neo4j(con) %>%
  as.data.frame()  # count() max() min() sum() avg()









# + f. 起始结束节点 ------------------------------------------------------------------


'match (a)-[r:`君主`]->(b) return startnode(r);' %>%  # endnode(r),id(r),type(r)
  call_neo4j(con)










# + g. 索引 ----------------------------------------------------------------------

# 在某个特定标签或关系上。针对某个属性创建索引。

# 以此，MATCH或WHERE或IN运算符上使用这些索引,以提高应用程序的性能

'CREATE INDEX ON :Person (name);' %>%
  call_neo4j(con)


'DROP INDEX ON :Person (name);' %>%
  call_neo4j(con)










# + h. unique约束 ----------------------------------------------------------------

# 对NODE或Relationship的属性添加UNIQUE约束


'CREATE CONSTRAINT ON (n:Country) 
  ASSERT n.country IS UNIQUE;' %>%
  call_neo4j(con)


'DROP CONSTRAINT ON (n:Person)
  ASSERT n.name IS UNIQUE' %>%
  call_neo4j(con)










# neo4jR应用 ----------------------------------------------------------------




res <- 'match (person:Person{name:"范宣子"})<-[r:`被说`]->() return r,person;' %>%
  call_neo4j(con,type = "graph")
unnest_nodes(res$nodes)





