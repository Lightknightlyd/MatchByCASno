#上证指数

library(quantmod)


#配置参数
setDefaults(getSymbols,auto.assign=FALSE)
setSymbolLookup(HKWS=list(name='002415.sz',src='yahoo',from="2022-03-01"),
                ZDWX=list(name='600797.ss',src='yahoo',from="2022-03-01"),
                HHXF=list(name='600172.ss',src='yahoo',from="2022-03-01"))




#获取数据
HKWS<-getSymbols("HKWS")
ZDWX<-getSymbols("ZDWX")
HHXF<-getSymbols("HHXF")


## charting

chartSeries(HKWS,
            type = c("candlesticks"), 
            show.grid = TRUE, 
            name = "HKWS",
            time.scale = NULL,
            log.scale = FALSE, #should the y-axis be log-scaled?
            TA = c(addVo(),addBBands(),addMACD()),
            TAsep=';',
            line.type = "l",
            bar.type = "ohlc",#type of barchart - ohlc or hlc
            theme = chartTheme("white"),
            layout = NA,
            major.ticks='auto', minor.ticks=TRUE,
            yrange=NULL,
            plot=TRUE,
            up.col= "red",
            dn.col= "green",
            color.vol = TRUE, multi.col = T)

#grey => Op[t] < Cl[t] and Op[t] < Cl[t-1] 低开高收
#white => Op[t] < Cl[t] and Op[t] > Cl[t-1] 高开高收
#red => Op[t] > Cl[t] and Op[t] < Cl[t-1] 低开低收
#black => Op[t] > Cl[t] and Op[t] > Cl[t-1] 高开低收


################################################################# 定制绘图主题
cn.theme <- chartTheme(up.col = "red",
                       dn.col = "green")

################reChart allows for dynamic changes to the chart without having to respecify the full chart parameters.
reChart(name = "PAB",
        subset = "2015",
        theme = cn.theme,
        type = "candlesticks")


######################################################## 常用涨跌幅指标
seriesHi(DLWH) # where and what was the high point
OpCl(DLWH) #daily percent change open to close
OpOp(DLWH) #one period open to open change
HiCl(DLWH) #the percent change from high to close

########################################################## 取滞后数据
Lag(Cl(DLWH)) #One period lag of the close
Lag(Cl(DLWH),c(1,3,5)) #One, three, and five period lags
Next(OpCl(DLWH)) #The next periods open to close - today!
# Open to close one-day, two-day and three-day lags
Delt(Op(DLWH),Cl(DLWH),k=1:3)

############################################################# 截取某段时间的数据
DLWH['2007'] #returns all Goldman's 2007 OHLC
DLWH['2008'] #now just 2008
DLWH['2008-01'] #now just January of 2008
DLWH['2007-06::2008-01-12'] #Jun of 07 through Jan 12 of 08
DLWH['::'] # everything in GS
DLWH['2008::'] # everything in GS, from 2008 onward
non.contiguous <- c('2007-01','2007-02','2007-12')
DLWH[non.contiguous]


############################################################### first and last来截取
last(DLWH) #returns the last obs.
last(DLWH,8) #returns the last 8 obs.
# let's try something a bit cooler.
last(DLWH, '3 weeks')
last(DLWH, '-3 weeks') # all except the last 3 weeks
last(DLWH, '3 months')
last(first(DLWH, '2 weeks'), '3 days')

################################################################  按时间汇总数据
periodicity(GS) # show Is your data weekly, daily, or hourly?
unclass(periodicity(GS))
to.weekly(GS)
to.monthly(GS)
periodicity(to.monthly(GS))
ndays(GS); nweeks(GS); nyears(GS) #nweeks will tell you the number of weeks
 # Let's try some non-OHLC to start
getFX("USD/EUR")

periodicity(USDEUR)
to.weekly(USDEUR)
periodicity(to.weekly(USDEUR))

#################################################################### 某段时间内的特定数据
endpoints(GS,on="months")
# find the maximum closing price each week
apply.weekly(GS,FUN=function(x) { max(Cl(x)) } )
# the same thing - only more general
period.apply(GS,endpoints(GS,on='weeks'),
                 + FUN=function(x) { max(Cl(x)) } )
# same thing - only 50x faster!
as.numeric(period.max(Cl(GS),endpoints(GS,on='weeks')))


################################################################### 计算收益率矩阵
# Quick returns - quantmod style
getSymbols("SBUX")
dailyReturn(SBUX) # returns by day
weeklyReturn(SBUX) # returns by week
monthlyReturn(SBUX) # returns by month, indexed by yearmon
# daily,weekly,monthly,quarterly, and yearly
allReturns(SBUX) # note the plural


######


DLWH_ret<-dailyReturn(DLWH)
HTYY_ret<-dailyReturn(HTYY)
ZGSY_ret<-dailyReturn(ZGSY)

data<-merge(DLWH_ret,HTYY_ret,ZGSY_ret) #合并收益率 和有效前沿

library(timeSeries)
data<-as.timeSeries(data)

library(fPortfolio)
frontier<-portfolioFrontier(data)
frontier

plot(frontier,which=c(1,2,3,4,5,6,7,8))

plot(frontier)

################################################################################build your model


# Create a quantmod object for use in
# in later model fitting. Note there is
# no need to load the data before hand.
setSymbolLookup(SPY='yahoo',VXN=list(name='^VIX',src='yahoo'))
mm <- specifyModel(Next(OpCl(SPY)) ~ OpCl(SPY) + Cl(VIX),na.rm = T)
modelData(mm)


q.model = specifyModel(Next(OpCl(DLWH)) ~ Lag(OpHi(DLWH),0:3))

m.built <- buildModel(q.model,method='lm',training.per=c('2019-06-05','2019-10-20'))

mytrademodel<-tradeModel(m.built,leverage=1,plot.model = T)

mytrademodel
###############################################################################  添加定制指标



library(PerformanceAnalytics)



