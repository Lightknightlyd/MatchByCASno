
if(require("neo4r")){
  
  if(require("RMySQL")){
    
    if(require("dplyr")){
      
      
      con <- neo4j_api$new(
        url = "http://www.yuedong.site:7474",
        user = "neo4j",
        password = "yuedong"
      )
      
      conn <- dbConnect(MySQL(),dbname = "www_yuedong_site",username = "www_yuedong_site",
                        password = "hGeFT7HpZMRajZ6Z",host = "47.100.123.40",port = 3306)
      dbSendQuery(conn,'SET NAMES gbk')
      
      ###### Country
      new_country <- dbGetQuery(conn,"select * from Cypher_Country;") # 获取新的全部数据
      old_country <- 'match (n:Country) return n' %>%
        call_neo4j(con) %>%
        as.data.frame()   # 获取图库中已有数据
      
      new_country <- merge(new_country,old_country,
                           by.x = "COUNTRY",by.y = "n.country",all = T)%>%
        filter(is.na(n.survive)==T)%>% # 筛选出新数据
        select("COUNTRY","SURVIVE")
      names(new_country) <- c("country","survive")
      
      if(nrow(new_country)!=0){
        
        # 将新数据导入图库
        for (i in 1:nrow(new_country)) {
          paste("MERGE", vec_to_cypher(new_country[i,], "Country")) %>%
            call_neo4j(con)
        }
      }else{
        print("no new country!")
      }
  
      ###### Person
        new_Person <- dbGetQuery(conn,"select * from Cypher_Person;") # 获取新的全部数据
        old_Person <- 'match (n:Person) return n' %>%
          call_neo4j(con) %>%
          as.data.frame()   # 获取图库中已有数据
        
        new_Person <- merge(new_Person,old_Person,
                            by.x = "NAME",by.y = "n.name",all = T)%>%
          filter(is.na(n.survive)==T)%>% # 筛选出新数据
          select("NAME","SURVIVE")
        names(new_Person) <- c("name","survive")
        
        if(nrow(new_Person)!=0){
          # 将新数据导入图库
          for (i in 1:nrow(new_Person)) {
            paste("MERGE", vec_to_cypher(new_Person[i,], "Person")) %>%
              call_neo4j(con)
          }
        }else{print("no new person!")}
          
          
          ####### Event
          new_Event <- dbGetQuery(conn,"select * from Cypher_Event;") # 获取新的全部数据
          old_Event <- 'match (n:Event) return n' %>%
            call_neo4j(con) %>%
            as.data.frame()   # 获取图库中已有数据
          
          new_Event <- merge(new_Event,old_Event,
                             by.x = "NAME",by.y = "n.name",all = T)%>%
            filter(is.na(n.ref)==T)%>% # 筛选出新数据
            select("NAME","REF","YEAR","IMPACT")
          names(new_Event) <- c("name","ref","year","impact")
          
          if(nrow(new_Event)!=0){
            
            # 将新数据导入图库
            for (i in 1:nrow(new_Event)) {
              paste("MERGE", vec_to_cypher(new_Event[i,], "Event")) %>%
                call_neo4j(con)
              }
          }else {
              print("no new event!")
            }
          

      
      
      ###### 导入关系数据
      new_rel <- dbGetQuery(conn,"select * from Cypher_Relation;")%>%
        filter(is.na(ID)==T)
      
      if(nrow(new_rel)!=0){
        for (i in 1:nrow(new_rel)) {
          
          switch(
            colnames(t(na.omit(t(new_rel[i,]))))[2],
            RULER=paste("match (a:Person),(b:Country) where a.name=\'",t(na.omit(t(new_rel[i,])))[1],"\' and b.country=\'",t(na.omit(t(new_rel[i,])))[2],"\' create (a)-[:`君主`]->(b);",sep = "")%>%
              call_neo4j(con),
            COURTIER=paste("match (a:Person),(b:Country) where a.name=\'",t(na.omit(t(new_rel[i,])))[1],"\' and b.country=\'",t(na.omit(t(new_rel[i,])))[2],"\' create (a)-[:`大夫`]->(b);",sep = "")%>%
              call_neo4j(con),
            DEFEAT=paste("match (a:Person),(b:Event) where a.name=\'",t(na.omit(t(new_rel[i,])))[1],"\' and b.name=\'",t(na.omit(t(new_rel[i,])))[2],"\' create (a)-[:`战胜`]->(b);",sep = "")%>%
              call_neo4j(con),
            BEATED=paste("match (a:Person),(b:Event) where a.name=\'",t(na.omit(t(new_rel[i,])))[1],"\' and b.name=\'",t(na.omit(t(new_rel[i,])))[2],"\' create (a)-[:`战败`]->(b);",sep = "")%>%
              call_neo4j(con),
            PERSUADE=paste("match (a:Person),(b:Event) where a.name=\'",t(na.omit(t(new_rel[i,])))[1],"\' and b.name=\'",t(na.omit(t(new_rel[i,])))[2],"\' create (a)-[:`游说`]->(b);",sep = "")%>%
              call_neo4j(con),
            PERSUADED=paste("match (a:Person),(b:Event) where a.name=\'",t(na.omit(t(new_rel[i,])))[1],"\' and b.name=\'",t(na.omit(t(new_rel[i,])))[2],"\' create (a)-[:`被说`]->(b);",sep = "")%>%
              call_neo4j(con),
            PARTICI=paste("match (a:Person),(b:Event) where a.name=\'",t(na.omit(t(new_rel[i,])))[1],"\' and b.name=\'",t(na.omit(t(new_rel[i,])))[2],"\' create (a)-[:`参与`]->(b);",sep = "")%>%
              call_neo4j(con),
            SLAY=paste("match (a:Person),(b:Person) where a.name=\'",t(na.omit(t(new_rel[i,])))[1],"\' and b.name=\'",t(na.omit(t(new_rel[i,])))[2],"\' create (a)-[:`弑杀`]->(b);",sep = "")%>%
              call_neo4j(con),
            PARENT=paste("match (a:Person),(b:Person) where a.name=\'",t(na.omit(t(new_rel[i,])))[1],"\' and b.name=\'",t(na.omit(t(new_rel[i,])))[2],"\' create (a)-[:`生子`]->(b);",sep = "")%>%
              call_neo4j(con),
            
          )
        }
        
      }else{print("no new relation!")}
      
      # 将源端关系数据再同步回MySQL
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
      
     # dbWriteTable(conn,"Cypher_Relation",rel,overwrite=T,row.names=F)
      
      
    }else {
      stop("could not found package dplyr")
    }
  }else {
    stop("could not found package RMySQL")
  }
} else {
  stop("could not found package neo4r")
}



