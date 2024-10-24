## R Markdown
library(rmarkdown)
library(haven)
library(plyr)
library(reshape2)
library(ggplot2)
library(stringr)

## 新增企业
essay_data<-read_dta("essay_data.dta")
essay_data2<-essay_data[,c(1:24,33:38)]
rm(essay_data)

#ggplot(essay_data2,aes(x=date,y=newf_forecap))+geom_line()+geom_point()
#ggplot(essay_data2,aes(x=date,y=log(newf_forecap)))+geom_line()+geom_point()

newf_situ<-essay_data2[,c(2,3,4,8,9,20)]
newf_situ_md<-melt(newf_situ,id="date")
newf_situ_md2<-within(newf_situ_md,{
  negative<-NA
  negative[value>0]<-1
  negative[value<0]<--1
  negative[value==0]<-0
})

newf_situ_md3<-ddply(newf_situ_md2,c("date","variable"),summarise,logval=negative*(log(abs(value))))
newf_situ_md3$logval<-ifelse(is.na(newf_situ_md3$logval)==TRUE,0,newf_situ_md3$logval)
newf_garph<-ggplot(newf_situ_md3,aes(x=date,y=logval))+geom_line(aes(colour=variable))+geom_point(aes(colour=variable))+scale_color_discrete(breaks=c("newf_jointcap","newf_coop","newf_forecap","newf_sate","newf_private"),labels=c("合资企业","合作企业","外资企业","国有企业","民营企业"))
newf_garph+labs(x="日期（月）",y="新增企业数（取对数）",colour="企业类型",title="图二：2016-2018年不同类型企业市场进入情况")+theme(plot.title = element_text(hjust = 0.5))

### 进口额变化

I_port<-essay_data2[,c(10:14,20)]
I_port_md<-melt(I_port,id="date")
I_port_md2<-ddply(I_port_md,c("date","variable"),summarise,logval=log(abs(value)))
I_port_garph<-ggplot(I_port_md2,aes(x=date,y=logval))+geom_line(aes(colour=variable))+geom_point(aes(colour=variable))
I_port_garph+labs(x="日期（月）",y="进口额（取对数）",colour="企业类型",title="图三：2016-2018年不同类型企业进口额情况")+theme(plot.title = element_text(hjust = 0.5))


### 出口额变化

E_port<-essay_data2[,c(15:20)]
E_port_md<-melt(E_port,id="date")
E_port_md2<-ddply(E_port_md,c("date","variable"),summarise,logval=log(abs(value)))
E_port_garph<-ggplot(E_port_md2,aes(x=date,y=logval))+geom_line(aes(colour=variable))+geom_point(aes(colour=variable))
E_port_garph+labs(x="日期（月）",y="出口额（取对数）",colour="企业类型",title="图三：2016-2018年不同类型企业出口额情况")+theme(plot.title = element_text(hjust = 0.5))



##不同国家地区实际利用外资


cap_use<-essay_data2[,c(20,25:30)]

cap_use_md<-melt(cap_use,id="date")
cap_use_md2<-ddply(cap_use_md,c("date","variable"),summarise,logval=log(abs(value)))
cap_use_garph<-ggplot(cap_use_md2,aes(x=date,y=logval))+geom_line(aes(colour=variable))+geom_point(aes(colour=variable))+scale_color_discrete(breaks=c("US_newcap","JS_newcap","SG_newcap","GM_newcap","KM_newcap","VK_newcap"),labels=c("美国","日本","新加坡","德国","开曼群岛","英属维京群岛"))
cap_use_garph+labs(x="日期（月）",y="实际利用外资额（取对数）",colour="企业类型",title="图三：2016-2018年实际利用不同国家（地区）外资情况")+theme(plot.title = element_text(hjust = 0.5))



##回归

library(dynlm)
library(stargazer)
timeseries<-1:35
tsessay<-data.frame(essay_data2,timeseries)
tsessay<-ts(tsessay,start=1)
fore_fit1<-dynlm(newf_forecap~import_forecap+export_forecap+PPI+investment+tradewar_tariff,data = tsessay)
fore_fit2<-dynlm(newf_forecap~import_forecap+export_forecap+investment+tradewar_tariff,data = tsessay)
fore_fit3<-dynlm(newf_forecap~import_forecap+export_forecap+tradewar_tariff+L(tradewar_tariff)+L(tradewar_tariff,2),data = tsessay)
fore_fit4<-dynlm(newf_forecap~PPI+investment+tradewar_tariff,data = tsessay)
fore_fit5<-dynlm(newf_forecap~import_forecap+export_forecap+tradewar_tariff,data = tsessay)
fore_fit6<-dynlm(newf_forecap~import_forecap+export_forecap+PPI+investment+tradewar_tariff+L(tradewar_tariff)+L(tradewar_tariff,2),data = tsessay)
stargazer(fore_fit1,fore_fit2,fore_fit3,fore_fit4,fore_fit5,fore_fit6,title = "result",type="html",align = TRUE,omit.stat = c("LL","ser","f"))


## 实际利用外资


us_fit1<-dynlm(US_newcap~PPI+investment+tradewar_tariff,data = tsessay)
jp_fit2<-dynlm(JP_newcap~PPI+investment+tradewar_tariff,data = tsessay)
sg_fit3<-dynlm(SG_newcap~PPI+investment+tradewar_tariff,data = tsessay)
gm_fit4<-dynlm(GM_newcap~PPI+investment+tradewar_tariff,data = tsessay)
km_fit5<-dynlm(KM_newcap~PPI+investment+tradewar_tariff,data = tsessay)
vk_fit6<-dynlm(VK_newcap~PPI+investment+tradewar_tariff,data = tsessay)
stargazer(us_fit1,jp_fit2,sg_fit3,gm_fit4,km_fit5,vk_fit6,title = "result",type="html",align = TRUE,omit.stat = c("LL","ser","f"))






