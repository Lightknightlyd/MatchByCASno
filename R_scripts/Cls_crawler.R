library(RCurl)
library(stringr)
Cls<-"https://www.in-cosmetics.com/latin-america/en-gb/exhibitor-directory.html?"


  
ClsPage<-getURL(Cls)
pattern<-"</span>"
  
ClsPageSplit<-str_split(ClsPage,'ASHLAND',simplify = T)
ClsPageSplit<-ClsPageSplit[2:16]
ClsPageSplit<-str_replace_all(ClsPageSplit," ","" )

Location<-str_locate(ClsPageSplit,pattern)  #返回位置
ClsOutput<-str_sub(ClsPageSplit,1,Location[,1]-1) #截取
ClsOutput <- str_replace_all(ClsOutput,"</strong>","")
ClsOutput <- str_replace_all(ClsOutput,"<br/>","")
  ClsOutput<-data.frame(Sys.time(),ClsOutput)
  names(ClsOutput)[1:2]<-c("time","info")
  ClsOutput$info<-as.character(ClsOutput$info)
  ClsOutput$time<-as.character(ClsOutput$time)
  
  ClsOutput<-subset(ClsOutput,is.na(info)==FALSE)
  
  
write.table(ClsOutput,file = "CLS_OUT.csv",append = T,row.names = F,col.names = F)

library(RMySQL)


conn <- dbConnect(MySQL(), dbname = "www_yuedong_site", username="www_yuedong_site", password="hGeFT7HpZMRajZ6Z", host="127.0.0.1", port=3306)

dbSendQuery(conn,'SET NAMES utf8')
dbListTables(conn)
# Run query to get results as dataframe  直接提取出结果
api_match<-dbGetQuery(conn, "SELECT * FROM api_match t")


sell <- subset(api_match,BUYSELL=="sell"|BUYSELL=="Sell"|BUYSELL=="SELL")
buy <- subset(api_match,BUYSELL=="buy"|BUYSELL=="Buy"|BUYSELL=="BUY")

match <- merge(sell,buy,by = "CAS")

write.table(sell,file = "sell_output.csv",row.names = T,col.names = T)
write.table(buy,file = "buy_output.csv",row.names = T,col.names = T)
write.table(match,file = "match_output.csv",row.names = T,col.names = T)

#test <- read.table("match_output.csv",stringsAsFactors = F)
dbDisconnect(conn) #关闭连接


#--------------------

library(rvest)

url <- "https://www.in-cosmetics.com/global/en-gb/exhibitor-directory.html?refinementList%5B0%5D%5B0%5D=filters.Country%20of%20Origin.lvl0%3Aid-555907&refinementList%5B0%5D%5B1%5D=filters.Country%20of%20Origin.lvl0%3Aid-555964&refinementList%5B0%5D%5B2%5D=filters.Country%20of%20Origin.lvl0%3Aid-556020&refinementList%5B0%5D%5B3%5D=filters.Country%20of%20Origin.lvl0%3Aid-556066&refinementList%5B0%5D%5B4%5D=filters.Country%20of%20Origin.lvl0%3Aid-556163"  
webpage <- read_html(url)

title_element <- html_nodes(webpage,"div.company-info")
news_title <- html_text(title_element)

print(news_title)
