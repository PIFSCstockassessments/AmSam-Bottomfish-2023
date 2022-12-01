Create_Boot_Figs <- function(root_dir,model_dir){

  boot_dir <- file.path(model_dir,"bootstrap")
  
SS.results <- r4ss::SS_output(model_dir,verbose = FALSE, printstats = FALSE)
PAR        <- data.table( SS.results$parameters )

# Catch graph
CA <- SS.results$catch %>% select(Yr,Obs,LOGSD.MT=se)

ggplot(data=CA,aes(x=Yr,y=Obs))+geom_bar(stat="identity",fill="blue",col="black")+labs(x="Year",y="Total catch (mt)")+
  geom_vline(aes(xintercept=1985.5),linetype="dashed",col="black",size=0.5)+
  scale_x_continuous(expand=c(0,0))+scale_y_continuous(expand=c(0,0),limits=c(0,max(CA$Obs)*1.1))+theme_bw()

ggsave(last_plot(),file=file.path(boot_dir,"01_Catch.png"),width=15,height=7,units="cm")

# Growth curve graph
GR     <- data.table( SS.results$endgrowth )
Lamin  <- PAR[2]$Value
CV_yg  <- PAR[5]$Value
CV_old <- PAR[6]$Value
  
MG    <- GR[Platoon==2]
MG$SD <- MG$Len_Beg*CV_old 
MG[Len_Beg<=Lamin]$SD <- MG[Len_Beg<=Lamin]$Len_Beg*CV_yg   
ymax  <- 1.2*(GR[Len_Beg==max(Len_Beg)]$Len_Beg+1.96*GR[Len_Beg==max(Len_Beg)]$SD_Beg)

if(max(GR$Sex)!=2){
ggplot()+scale_y_continuous(expand=c(0,0),limits=c(0,ymax))+scale_x_continuous(expand=c(0,0))+
 # geom_line(data=GR[Platoon==1],aes(x=Age_Beg,y=Len_Beg-1.96*SD_Beg),linetype="dotted")+
 #  geom_line(data=GR[Platoon==3],aes(x=Age_Beg,y=Len_Beg+1.96*SD_Beg),linetype="dotted")+
  geom_ribbon(data=MG,aes(x=Age_Beg,ymin=Len_Beg-1.96*SD,ymax=Len_Beg+1.96*SD),alpha=0.15)+
  geom_line(data=GR[Platoon==1],aes(x=Age_Beg,y=Len_Beg),col="black",linetype="dashed")+
  geom_line(data=GR[Platoon==2],aes(x=Age_Beg,y=Len_Beg),col="black")+
  geom_line(data=GR[Platoon==3],aes(x=Age_Beg,y=Len_Beg),col="black",linetype="dashed")+theme_bw()+
  labs(x="Age (year)",y="Length FL (cm)")
  
  ggsave(last_plot(),file=file.path(boot_dir,"02_Growth.png"),width=15,height=7,units="cm")
  
} else{
  ggplot()+scale_y_continuous(expand=c(0,0),limits=c(0,ymax))+scale_x_continuous(expand=c(0,0))+
    # geom_line(data=GR[Platoon==1],aes(x=Age_Beg,y=Len_Beg-1.96*SD_Beg),linetype="dotted")+
    #  geom_line(data=GR[Platoon==3],aes(x=Age_Beg,y=Len_Beg+1.96*SD_Beg),linetype="dotted")+
    geom_ribbon(data=MG,aes(x=Age_Beg,ymin=Len_Beg-1.96*SD,ymax=Len_Beg+1.96*SD),alpha=0.15)+
    geom_line(data=GR[Platoon==1],aes(x=Age_Beg,y=Len_Beg),col="black",linetype="dashed")+
    geom_line(data=GR[Platoon==2],aes(x=Age_Beg,y=Len_Beg),col="black")+
    geom_line(data=GR[Platoon==3],aes(x=Age_Beg,y=Len_Beg),col="black",linetype="dashed")+theme_bw()+
    labs(x="Age (year)",y="Length FL (cm)")+facet_wrap(~Sex,labeller=labeller(Sex=c("1"="Female","2"="Male")))

  ggsave(last_plot(),file=file.path(boot_dir,"02_Growth.png"),width=18,height=7,units="cm")
}


# Mean length graph

#LC <- data.table( SS.results$len_comp_fit_table )
#setnames(LC,c("All_exp_5%","All_exp_95%"),c("All_exp_05","All_exp_95"))
#ggplot(data=LC)+geom_line(aes(x=Yr,y=All_exp_mean))+geom_point(aes(x=Yr,y=All_obs_mean))+geom_errorbar(aes(x=Yr,ymin=All_exp_05,ymax=All_exp_95))

# Derived quantities graphs

# Get the bootstrapped results
BS <- readRDS(file.path(boot_dir,"mvln_draws.rds"))
setnames(BS,c("year","stock","harvest","F","Recr"),c("YEAR","B_BMSY","F_FMSY","FMORT","REC"))
colnames(BS) <- toupper(colnames(BS))
BS <- BS[TYPE=="fit"]

# Nat M
NatM <- PAR[str_detect(PAR$Label,"NatM")]$Value

BS <- BS %>% mutate(BMSST=SSB/B_BMSY*max(0.5,1-NatM),FMSY=FMORT/F_FMSY) %>% mutate(B_BMSST=SSB/BMSST)

# Calculate some quantities and the CVs

TS <- BS %>% group_by(YEAR) %>%  summarize(SSB.50=median(SSB),SSB.05=quantile(SSB,0.05),SSB.95=quantile(SSB,0.95),SSB.CV=sd(SSB)/mean(SSB),
                                           B_BMSST.50=median(B_BMSST),B_BMSST.05=quantile(B_BMSST,0.05),B_BMSST.95=quantile(B_BMSST,0.95),B_BMSST.CV=sd(B_BMSST)/mean(B_BMSST),
                                           FMORT.50=median(FMORT),FMORT.05=quantile(FMORT,0.05),FMORT.95=quantile(FMORT,0.95),FMORT.CV=sd(FMORT)/mean(FMORT),
                                           F_FMSY.50=median(F_FMSY),F_FMSY.05=quantile(F_FMSY,0.05),F_FMSY.95=quantile(F_FMSY,0.95),F_FMSY.CV=sd(F_FMSY)/mean(F_FMSY),
                                           REC.50=median(REC),REC.05=quantile(REC,0.05),REC.95=quantile(REC,0.95),REC.CV=sd(REC)/mean(REC),
                                           CATCH=median(CATCH)) %>% as.data.table()

SSB_MSST <- BS %>% summarize(BMSST.50=median(BMSST)) %>% as.numeric()


# Other quantities taken straight from report.sso
SS         <- data.table( SS.results$timeseries )
SSB0       <- SS %>% filter(Era=="VIRG") %>% select(SpawnBio) %>% as.numeric()
SS         <- SS %>% select(Yr,Era,Bio_all)
B0         <- SS %>% filter(Era=="VIRG") %>% select(Bio_all) %>% as.numeric()
TBIO       <- SS %>% filter(Era=="TIME") %>% select(Yr,Bio_all) %>% rename("TBIO"="Bio_all")

TS <- TS %>% merge(TBIO,by.x="YEAR",by.y="Yr")

P1 <- ggplot(data=TS)+geom_point(aes(x=1967,y=SSB0),col="red",size=1.5)+#geom_line(aes(x=YEAR,y=TBIO),linetype="dashed")
  geom_ribbon(aes(x=YEAR,ymin=SSB.05,ymax=SSB.95),alpha=0.1)+scale_y_continuous(limits=c(0,max(TS$SSB.95)*1.1),expand=c(0,0))+
  scale_x_continuous(breaks=seq(1960,2030,10))+
  geom_line(aes(x=YEAR,y=SSB.50),linetype="solid")+geom_hline(aes(yintercept=SSB_MSST),linetype="dotdash",col="blue")+
  theme_bw()+theme(axis.text.x=element_blank(),axis.title.x=element_blank())+ylab("Biomass (mt)")

P2 <- ggplot(data=TS,aes(x=YEAR,y=FMORT.50))+geom_ribbon(aes(ymin=FMORT.05,ymax=FMORT.95),alpha=0.1)+geom_line()+
  scale_x_continuous(breaks=seq(1960,2030,10))+
  scale_y_continuous(expand=c(0,0))+theme_bw()+xlab("Year")+ylab(expression(Fishing~mortality~(yr^-1)))
  
P1 <- ggplotGrob(P1)
P2 <- ggplotGrob(P2)

g <- rbind(P1, P2, size = "first")
g$widths <- unit.pmax(P1$widths, P2$widths)
grid.newpage()
grid.draw(g)

ggsave(g,file=file.path(boot_dir,"03_Quants.png"),width=14,height=10,units="cm")


# Stock-recruitment relationship
SS      <- data.table( SS.results$derived_quants )
SSB     <- SS[str_detect(SS$Label,"SSB")][3:57,2]
REC     <- SS[str_detect(SS$Label,"Recr")][3:57,2]
YEAR    <- seq(1967,2021)

SSB      <- cbind(SSB,YEAR)
REC      <- cbind(REC,YEAR)
DAT      <- merge(SSB,REC,by="YEAR")
colnames(DAT) <- c("Year","SSB","REC")

SSB_VIRG <- as.numeric( SS[str_detect(SS$Label,"SSB_Virgin")][,2] )
REC_VIRG <- as.numeric( SS[str_detect(SS$Label,"Recr_Virgin")][,2] )
STEEP    <- PAR[str_detect(PAR$Label,"steep")]$Value

SR <- data.table( SS.results$SPAWN_RECR_CURVE )
SR <- SR[`SSB/SSB_virgin`<=1]

SR_plot <- ggplot(data=DAT)+scale_x_continuous(limits=c(0,SSB_VIRG*1.1),expand=c(0,0))+scale_y_continuous(limits=c(0,REC_VIRG*1.1),expand=c(0,0))+
  #stat_function(fun=function(x) 4*STEEP*REC_VIRG*x/(SSB_VIRG*(1-STEEP)+x*(5*STEEP-1)) ,xlim=c(0,SSB_VIRG))+
  geom_line(data=SR,aes(x=SSB,y=Recruitment))+
  geom_point(aes(x=SSB,y=REC,col=Year),size=2)+geom_point(aes(x=SSB_VIRG,y=REC_VIRG),size=4,col="red",shape=18)+
  scale_color_gradientn(colors=rainbow(4))+theme_bw()+xlab("Spawning biomass (SSB; mt)")+ylab("Recruitment (1000 recruits)")

ggsave(last_plot(),filename=file.path(boot_dir,"04_SR.png"),width=14,height=7,units="cm",dpi=300)

# Kobe plot
SS         <- data.table( SS.results$derived_quants )

##mean and SD of MSY values
SSB_MSY <- as.numeric( SS[str_detect(SS$Label,"SSB_MSY")][,2:3])
FMSY    <- as.numeric( SS[str_detect(SS$Label,"annF_MSY")][,2:3])

#mean and SD of terminal year values
SSBratio_TermYr <- TS %>% filter(YEAR==max(YEAR)) %>% select(B_BMSST.50,B_BMSST.05,B_BMSST.95)
Fratio_Term     <- TS %>% filter(YEAR==max(YEAR)) %>% select(F_FMSY.50,F_FMSY.05,F_FMSY.95)

# Kobe plot layout setting, adjust as needed
x_max  <- max(TS$B_BMSST.50,3)*1.05
x_min  <- 0
y_max  <- max(TS$F_FMSY.50,1.5)*1.05
y_min  <- 0
MSST_x <- max(0.5,1-NatM)
max_yr <- max(TS$YEAR)

## Overfished triangles/trapezoids
tri_y  <- c(y_min,1,y_min)  ##currently MSST is set to 0.9Bmsy, but would be different depending on rebuilding projections
tri_x  <- c(x_min,MSST_x,MSST_x)
poly_y <- c(y_min,y_max,y_max,1)
poly_x <- c(x_min,x_min,MSST_x,MSST_x)

# Subsample of last year position
Last.Year <- BS[YEAR==max(YEAR)] 
Last.Year <- Last.Year[sample(1:nrow(Last.Year),1000)]

# Plot
K <- ggplot()+geom_polygon(aes(x=tri_x,y=tri_y),fill="khaki1",col="black")+geom_polygon(aes(x=c(MSST_x,x_max,x_max,MSST_x),y=c(1,1,y_min,y_min)),fill="palegreen",col="black")+
         geom_polygon(aes(x=poly_x,y=poly_y),fill="salmon",col="black")+geom_polygon(aes(x=c(MSST_x,x_max,x_max,MSST_x),y=c(1,1,y_max,y_max)),fill="khaki1",col="black")+
         geom_segment(aes(x=1,xend=1,y=0,yend=1))+
         scale_x_continuous(expand=c(0,0),limits=c(0,x_max))+scale_y_continuous(expand=c(0,0),limits=c(0,y_max))+labs(x=expression(SSB/SSB[MSY]),y=expression(F/F[MSY]))
K <- K + geom_point(data=Last.Year,aes(x=B_BMSST,y=F_FMSY))+geom_point(size=0.2)
K <- K + geom_path(data=TS,aes(x=B_BMSST.50,y=F_FMSY.50),size=0.1)+scale_fill_gradientn(colors=rev(rainbow(4)))+
         geom_point(data=TS,aes(x=B_BMSST.50,y=F_FMSY.50,fill=YEAR),shape = 21,colour="black")
K <- K + geom_point(data=TS[YEAR==max(YEAR)],aes(x=B_BMSST.50,y=F_FMSY.50),shape=21,fill="red",col="black",size=3)

ggsave(last_plot(),file=file.path(boot_dir,"05_Kobe.png"),width=14,height=10,units="cm")

}

