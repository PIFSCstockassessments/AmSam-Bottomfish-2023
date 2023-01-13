Create_Forecast_Figs_Tables <- function(root_dir,model_dir){


  # COMMENT OUT THIS LINE
#  model_dir <- file.path(root_dir,"SS3 models","VALO","65_Base")
  
  
  
  fore_dir <- file.path(model_dir,"forecast")
  
  if(!file.exists(file.path(fore_dir,"mv_projections.rds"))){ print(paste0("No projections file found for ",Sp)); next }
  
  mv_fore   <- data.table( readRDS(file=file.path(fore_dir,"mv_projections.rds")) )
  mv_fore   <- mv_fore %>% mutate(BootRun=substring(run,1,3),CatchRun=substring(run,4,7))
  
# Start projection analyses at first year of new catch advice (ex. 2021=last year in model,2024=first year model will be used to generate catch advice) 
  mv_fore <- mv_fore %>% filter(year>min(year)+1) 
  
  mv_fore <- mv_fore %>% mutate(FixedCatch=round(FixedCatch,2)) %>%
               mutate(BootCatchYr=paste0(BootRun,CatchRun,"_",year))
               
  
  # Code below is for troubleshooting
  #BootSummary <- mv_fore %>% group_by(BootRun,CatchRun,year,BootCatchYr,FixedCatch) %>% summarize(F_Fmsy=round(median(F_Fmsy),4),SSB_SSBmsst=round(median(SSB_SSBmsst),3)) %>%
   #                 arrange(BootRun,year,CatchRun) %>%  as.data.table()
  
  #ggplot(BootSummary[year==2028],aes(x=FixedCatch,y=F_Fmsy,linetype=as.character(year)))+geom_point()+facet_wrap(~BootRun)
  #ggplot(mv_fore,aes(x=Catch))+geom_histogram()+facet_wrap(~run)
  #ggplot(mv_fore[FixedCatch==1.05&year==2028],aes(x=F_Fmsy))+geom_histogram()+scale_x_continuous(limits=c(0,5))+facet_wrap(~BootRun)
  #ggplot(mv_fore[FixedCatch==1.2&year==2028],aes(x=F_Fmsy))+geom_histogram()+scale_x_continuous(limits=c(0,5))
  
  #ggplot(mv_fore[BootRun=="B07"&FixedCatch==1.05],aes(x=F_Fmsy))+geom_histogram()+scale_x_continuous(limits=c(0,5))+facet_wrap(~year)

  #summary(mv_fore[BootRun=="B07"&FixedCatch==1.05&year==2027])
  #summary(mv_fore[BootRun=="B07"&FixedCatch==1.05&year==2028]) # Why does the F jump so much from year to the next?
  
# Set project x limits (sometimes necessary for high variance, low selectivity, low biomass species)
  xmax <- 9999

# EXPERIMENTAL FILTERS TO REMOVE WEIRD PROJECTIONS ISSUE  

  # 1) remove FixedCatch values when F_Fmsy starts going doing down after increasing FixedCatch
  
  #BootSummary        <- BootSummary %>% mutate(Diff=F_Fmsy-lag(F_Fmsy)) %>% 
  #                        mutate(Diff=ifelse(CatchRun=="C01",0,Diff),BootYear=paste0(BootRun,"_",year))
  
#  BootYear.list <- unique(BootSummary$BootYear)
#  Keep.BootCatchYr <- list()
#  for(i in 1:length(BootYear.list)){
#    
 #   aBCY         <- BootSummary[BootYear==BootYear.list[i]]
  #  FirstNegDiff <- aBCY[Diff<0][1]$FixedCatch
   # 
  #  if(!is.na(FirstNegDiff))
  #  aBCY <- aBCY %>% filter(FixedCatch<FirstNegDiff)  
  #  
  #  aBCY <- aBCY %>% select(BootCatchYr) 
  #  
  #  Keep.BootCatchYr <- rbind(Keep.BootCatchYr,aBCY) 
  #}
  
#  mv_fore <- merge(mv_fore,Keep.BootCatchYr,by="BootCatchYr")
  
#  NewBootSummary <- mv_fore %>% group_by(BootRun,CatchRun,year,BootCatchYr,FixedCatch) %>% summarize(F_Fmsy=round(median(F_Fmsy),4),SSB_SSBmsst=round(median(SSB_SSBmsst),3)) %>%
#    arrange(BootRun,year,CatchRun) %>%  as.data.table()
  
#  ggplot(NewBootSummary[year==2028],aes(x=FixedCatch,y=F_Fmsy,linetype=as.character(year)))+geom_point()+facet_wrap(~BootRun)
  

Z <- mv_fore %>%  group_by(year,FixedCatch) %>% 
        summarize(F_Fmsy=median(F_Fmsy),SSB_SSBmsst=median(SSB_SSBmsst)) %>% 
          filter(FixedCatch<=xmax)
      

P1 <- ggplot(data=Z,aes(x=FixedCatch,y=F_Fmsy,linetype=as.character(year)))+geom_point(size=0.1)+labs(x="Fixed catch (mt)",y="F/Fmsy")+
  guides(linetype=guide_legend(title="Final year"))+theme_bw()+stat_smooth(col="black",se=F,size=0.5,method="lm",formula=y~poly(x,2,raw=T))+
  scale_x_continuous(expand=c(0,0))+scale_y_continuous(expand=c(0,0))

P2 <- ggplot(data=Z,aes(x=FixedCatch,y=SSB_SSBmsst,linetype=as.character(year)))+geom_point(size=0.1)+labs(x="Fixed catch (mt)",y="SSB/SSBmsst")+
  theme_bw()+theme(legend.position="none")+stat_smooth(col="black",se=F,size=0.5,method="lm",formula=y~poly(x,2,raw=T))


aLegend <- get_legend(P2)
ggarrange(P1,P2,ncol=2,common.legend = T,legend.grob = aLegend,legend="right")
ggsave(last_plot(),file=file.path(fore_dir,"01_Proj_MedianStatus.png"),height=8, width=16,units="cm")


# Calculate number of iterations by Catch and Year...
Y <- mv_fore %>% filter(FixedCatch<=xmax)

A <- Y %>% group_by(year,FixedCatch) %>% summarize(N_tot=n())

# ...That is under overfishing
B <- Y %>% filter(F_Fmsy>1) %>% group_by(year,FixedCatch) %>% summarize(N_overfishing=n())

C <- merge(A,B,by=c("year","FixedCatch"),all.x=T)

C <- C %>% mutate(N_overfishing=replace_na(N_overfishing,0)) %>% 
            mutate(ProbOverfishing=N_overfishing/N_tot)

# ...That is overfished
D <- Y %>% filter(SSB_SSBmsst<1) %>% group_by(year,FixedCatch) %>% summarize(N_overfished=n())
E <- merge(A,D,by=c("year","FixedCatch"),all.x=T)
E <- E %>% mutate(N_overfished=replace(N_overfished,is.na(N_overfished),0)) %>% 
  mutate(ProbOverfished=N_overfished/N_tot)

P3 <- ggplot(data=C,aes(x=FixedCatch,y=ProbOverfishing,linetype=as.character(year)))+geom_point(size=0.5)+labs(x="Fixed catch (mt)",y="Prob. F > Fmsy")+
  theme_bw()+theme(legend.position="none")+geom_smooth(col="black",se=F,size=0.5)+scale_y_continuous(expand=c(0,0),limits=c(0,1))+coord_cartesian(ylim=c(0,0.6))+
  scale_x_continuous(limits=c(min(C$FixedCatch),max(C$FixedCatch)),expand=c(0,0))#+geom_point(aes(fill=as.character(year)),size=1,shape=21)

P4 <- ggplot(data=E,aes(x=FixedCatch,y=ProbOverfished,linetype=as.character(year)))+geom_point(size=0.5)+labs(x="Fixed catch (mt)",y="Prob. SSB < SSBmsst")+
  guides(linetype=guide_legend(title="Final year"))+theme_bw()+geom_smooth(col="black",se=F,size=0.5)+scale_y_continuous(expand=c(0,0),limits=c(0,1))+coord_cartesian(ylim=c(0,0.6))+
  scale_x_continuous(limits=c(min(C$FixedCatch),max(C$FixedCatch)),expand=c(0,0))

aLegend <- get_legend(P4)
ggarrange(P3,P4,ncol=2,common.legend = T,legend.grob = aLegend,legend="right")
ggsave(last_plot(),file=file.path(fore_dir,"02_Proj_ProbStatus.png"),height=8, width=16,units="cm")

# Catch risk table 
G <- C %>% filter(ProbOverfishing>=0.1&ProbOverfishing<=0.6&FixedCatch<=xmax) %>% select(-N_tot,-N_overfishing)

Preds.x <- expand.grid(ProbOverfishing=seq(0.1,0.5,by=0.01),year=as.factor(seq(min(G$year),max(G$year))))
G$year  <- factor(G$year)
#model   <- gam(data=G,Catch~year+s(ProbOverfishing,by=year),method="REML")
#Preds   <- predict.gam(model,newdata=Preds.x)
model   <- glm(data=G,FixedCatch~year*poly(ProbOverfishing,2))
Preds   <- predict(model,newdata=Preds.x)
Preds   <- cbind(Preds.x,Preds)

# Check the GLM model fit and range of data
G$year <- as.character(G$year)
ggplot()+geom_line(data=Preds,aes(x=Preds,y=ProbOverfishing,col=as.character(year)))+geom_point(data=G,aes(x=FixedCatch,y=ProbOverfishing,col=as.character(year)),shape=2,size=2)+
  theme_bw()+labs(x="Catch",y="Prob. overfishing") + guides(col=guide_legend(title="Year"))
ggsave(last_plot(),file=file.path(fore_dir,"03_Proj_CheckModelFit.png"),height=8, width=15,units="cm")

# Create Prob. overfishing bins
G$ProbOverfishing     <- round(G$ProbOverfishing,2)

H <- merge(Preds,G,by.x=c("year","ProbOverfishing"),by.y=c("year","ProbOverfishing"),all.x=T)
H <- select(H,Year=year,ProbOverfishing,FixedCatch,Preds)
H$Year <- as.numeric(as.character(H$Year))

# Fill in the catch advice using the model predictions
H <- H %>% mutate(Catch=Preds) %>% select(-Preds) %>%  filter(Year>=2024) %>% 
  group_by(Year,ProbOverfishing) %>% summarize(Catch=round(mean(Catch),2)) %>% 
  mutate(Catch=format(Catch,nsmall=2),ProbOverfishing=format(ProbOverfishing,nsmall=2)) %>% 
  spread(Year,Catch) %>% arrange(desc(ProbOverfishing))

write.xlsx(H,file=file.path(fore_dir,"04_Proj_Table.xlsx"),sheets="CatchProj")

}
