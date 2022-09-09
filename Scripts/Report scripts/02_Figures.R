require(pacman); pacman::p_load(data.table,grid,gtable,openxlsx,r4ss,this.path,tidyverse)
root_dir <- this.path::here(..=2)

Model <- "23_F3_Dirich_NewCatch" 

dir.create(file.path(root_dir,"Outputs","Report_Inputs"),recursive=T,showWarnings=F)

Species.List <- c("APRU","APVI","CALU","ETCO","LERU","LUKA","PRFL","PRZO","VALO")
for(s in 1:9){

Sp <- Species.List[s]

SS.results <- r4ss::SS_output(file.path(root_dir,"SS3 models",Sp, Model),verbose = FALSE, printstats = FALSE)

# Growth curve graph

GR     <- data.table( SS.results$endgrowth )
Lamin  <- SS.results$parameters[2,3]
CV_yg  <- SS.results$parameters[5,3]
CV_old <- SS.results$parameters[5,3]
  
MG    <- GR[Platoon==2]
MG$SD <- MG$Len_Beg*CV_old 
MG[Len_Beg<=Lamin]$SD <- MG[Len_Beg<=Lamin]$Len_Beg*CV_yg   
ymax <- 1.2*(GR[max(Len_Beg)]$Len_Beg+1.96*GR[max(Len_Beg)]$SD_Beg)

ggplot()+scale_y_continuous(expand=c(0,0),limits=c(0,ymax))+scale_x_continuous(expand=c(0,0))+
 # geom_line(data=GR[Platoon==1],aes(x=Age_Beg,y=Len_Beg-1.96*SD_Beg),linetype="dotted")+
 #  geom_line(data=GR[Platoon==3],aes(x=Age_Beg,y=Len_Beg+1.96*SD_Beg),linetype="dotted")+
  geom_ribbon(data=MG,aes(x=Age_Beg,ymin=Len_Beg-1.96*SD,ymax=Len_Beg+1.96*SD),alpha=0.15)+
  geom_line(data=GR[Platoon==1],aes(x=Age_Beg,y=Len_Beg),col="black",linetype="dashed")+
  geom_line(data=GR[Platoon==2],aes(x=Age_Beg,y=Len_Beg),col="black")+
  geom_line(data=GR[Platoon==3],aes(x=Age_Beg,y=Len_Beg),col="black",linetype="dashed")+theme_bw()+
  labs(x="Age (year)",y="Length FL (cm)")

ggsave(last_plot(),file=file.path(root_dir,"Outputs","Report_Inputs",paste0(Sp,"_Growth.png")),width=15,height=7,units="cm")

# Mean length graph

LC <- data.table( SS.results$len_comp_fit_table )
setnames(LC,c("All_exp_5%","All_exp_95%"),c("All_exp_05","All_exp_95"))

ggplot(data=LC)+geom_line(aes(x=Yr,y=All_exp_mean))+geom_point(aes(x=Yr,y=All_obs_mean))+geom_errorbar(aes(x=Yr,ymin=All_exp_05,ymax=All_exp_95))



# Derived quantities graphs
SS         <- data.table( SS.results$derived_quants )
SS$CV      <- round(SS$StdDev/SS$Value,2)
SS$Value   <- round(SS$Value,3)
SS         <- select(SS,Label,Value,CV)

SSB   <- SS[str_detect(SS$Label,"SSB")][3:57,2:3]
REC   <- SS[str_detect(SS$Label,"Recr")][3:57,2:3]
FMORT <- SS[str_detect(SS$Label,"F_")][1:55,2:3]

TBIO  <- data.table(TOT_BIO=SS.results$timeseries$Bio_all)[3:57]

TA <- cbind(YEAR=seq(1967,2021),TBIO,SSB,REC,FMORT)

colnames(TA) <- c("YEAR","TBIO","SSB","SSB_CV","REC","REC_CV","F","F_CV")

B0       <- as.numeric( SS[str_detect(SS$Label,"Totbio_unfished")][,2] )
SSB_MSST <- as.numeric( 0.9*SS[str_detect(SS$Label,"SSB_MSY")][,2] )

TA$SSB95U <- TA$SSB+1.96*(TA$SSB_CV*TA$SSB)
TA$SSB95L <- TA$SSB-1.96*(TA$SSB_CV*TA$SSB)
TA$F95U   <- TA$F+1.96*(TA$F_CV*TA$F)
TA$F95L   <- TA$F-1.96*(TA$F_CV*TA$F)


P1 <- ggplot(data=TA)+geom_line(aes(x=YEAR,y=TBIO),linetype="dashed")+geom_point(aes(x=1967,y=B0),col="red",size=3)+
  geom_ribbon(aes(x=YEAR,ymin=SSB95L,ymax=SSB95U),alpha=0.3)+scale_y_continuous(limits=c(0,B0*1.1),expand=c(0,0))+
  scale_x_continuous(breaks=seq(1960,2030,10))+
  geom_line(aes(x=YEAR,y=SSB),linetype="solid")+geom_hline(aes(yintercept=SSB_MSST),linetype="dotdash",col="blue")+
  theme_bw()+theme(axis.text.x=element_blank(),axis.title.x=element_blank())+ylab("Biomass (mt)")

P2 <- ggplot(data=TA,aes(x=YEAR,y=F))+geom_ribbon(aes(ymin=F95L,ymax=F95U),alpha=0.3)+geom_line()+
  scale_x_continuous(breaks=seq(1960,2030,10))+
  scale_y_continuous(expand=c(0,0))+theme_bw()+xlab("Year")+ylab(expression(Fishing~mortality~(year^-1)))
  
P1 <- ggplotGrob(P1)
P2 <- ggplotGrob(P2)

g <- rbind(P1, P2, size = "first")
g$widths <- unit.pmax(P1$widths, P2$widths)
grid.newpage()
grid.draw(g)

ggsave(g,file=file.path(root_dir,"Outputs","Report_Inputs",paste0(Sp,"_Quants.png")),width=14,height=10,units="cm")


# Stock-recruitment relationship
SS          <- data.table( SS.results$derived_quants )
SSB         <- SS[str_detect(SS$Label,"SSB")][3:57,2]
REC         <- SS[str_detect(SS$Label,"Recr")][3:57,2]

SSB_VIRG <- as.numeric( SS[str_detect(SS$Label,"SSB_Virgin")][,2] )
REC_VIRG <- as.numeric( SS[str_detect(SS$Label,"Recr_Virgin")][,2] )
STEEP    <- SS.results$parameters$Value[16]
alpha    <- 4*STEEP*REC_VIRG/(5*STEEP-1)
beta     <- SSB_VIRG*(1-STEEP)/(5*STEEP-1)

DAT <- cbind(Year=seq(1967,2021),SSB,REC)
colnames(DAT) <- c("Year","SSB","REC")

SR_plot <- ggplot(data=DAT)+scale_x_continuous(limits=c(0,SSB_VIRG+1),expand=c(0,0))+scale_y_continuous(limits=c(0,REC_VIRG+1),expand=c(0,0))+
  stat_function(fun=function(x) alpha*x/(beta+x),xlim=c(0,SSB_VIRG))+
  geom_point(aes(x=SSB,y=REC,col=Year),size=2)+geom_point(aes(x=SSB_VIRG,y=REC_VIRG),size=4,col="red",shape=18)+
  scale_color_gradientn(colors=rainbow(4))+theme_bw()+xlab("Spawning biomass (SSB; mt)")+ylab("Recruitment (1000 recruits)")

ggsave(last_plot(),filename=file.path(root_dir,"Outputs","Report_Inputs",paste0(Sp,"_SR.png")),width=14,height=7,units="cm",dpi=300)

# Kobe plot
SS         <- data.table( SS.results$derived_quants )

##mean and SD of MSY values
SSB_MSY <- as.numeric( SS[str_detect(SS$Label,"SSB_MSY")][,2:3])
F_MSY   <- as.numeric( SS[str_detect(SS$Label,"annF_MSY")][,2:3])

#mean and SD of terminal year values
SSBratio_TermYr <- as.numeric( SS[str_detect(SS$Label,"Bratio_2021")][,2:3])
Fratio_Term     <- as.numeric( SS[str_detect(SS$Label,"F_2021")][,2:3])/F_MSY[1]

#Time series of ratios
Fstd <- SS[str_detect(SS$Label,"F_")][2:55,2:3]
TS   <- data.table(YEAR=seq(1968,2021),SSBratio=SS[str_detect(SS$Label,"Bratio_")]$Value[1:54],
                 Fratio=Fstd$Value/F_MSY[1])

nyears <- nrow(TS)

##SD of ratios in the terminal year
Fratio_SD   <- as.double(TS$Fratio[nyears]*sqrt((Fstd[nyears,2]/Fstd[nyears,1])^2+(F_MSY[2]/F_MSY[1])^2))
Fratio_95   <- TS$Fratio[nyears]+1.96*Fratio_SD
Fratio_05   <- TS$Fratio[nyears]-1.96*Fratio_SD
SSBratio_95 <- SSBratio_TermYr[1]+1.96*SSBratio_TermYr[2]
SSBratio_05 <- SSBratio_TermYr[1]-1.96*SSBratio_TermYr[2]

# Kobe plot layout setting, adjust as needed
x_max  <- max(TS$SSBratio,SSBratio_95,3)*1.05
x_min  <- 0
y_max  <- max(TS$Fratio,Fratio_95,1.5)
y_min  <- 0
MSST_x <- 0.9
max_yr <- 2021

## Overfished triangles/trapezoids
tri_y  <- c(y_min,1,y_min)  ##currently MSST is set to 0.9Bmsy, but would be different depending on rebuilding projections
tri_x  <- c(x_min,MSST_x,MSST_x)
poly_y <- c(y_min,y_max,y_max,1)
poly_x <- c(x_min,x_min,MSST_x,MSST_x)

# Plot
K <- ggplot()+geom_polygon(aes(x=tri_x,y=tri_y),fill="khaki1",col="black")+geom_polygon(aes(x=c(MSST_x,x_max,x_max,MSST_x),y=c(1,1,y_min,y_min)),fill="palegreen",col="black")+
         geom_polygon(aes(x=poly_x,y=poly_y),fill="salmon",col="black")+geom_polygon(aes(x=c(MSST_x,x_max,x_max,MSST_x),y=c(1,1,y_max,y_max)),fill="khaki1",col="black")+
         geom_segment(aes(x=1,xend=1,y=0,yend=1))+
         scale_x_continuous(expand=c(0,0),limits=c(0,x_max))+scale_y_continuous(expand=c(0,0),limits=c(0,y_max))+labs(x=expression(SSB/SSB[MSY]),y=expression(F/F[MSY]))
K <- K + geom_line(data=TS,aes(x=SSBratio,y=Fratio),size=0.1)+scale_fill_gradientn(colors=rev(rainbow(4)))+geom_point(data=TS,aes(x=SSBratio,y=Fratio,fill=YEAR),shape = 21,colour="black")
K <- K + geom_linerange(data=TS,aes(xmin=SSBratio_05,xmax=SSBratio_95,y=Fratio[nyears]),linetype="dashed")
K <- K + geom_point(data=TS,aes(x=SSBratio[nyears],y=Fratio[nyears]),shape=21,fill="red",col="black",size=3)

K

ggsave(last_plot(),file=file.path(root_dir,"Outputs","Report_Inputs",paste0(Sp,"_Kobe.png")),width=14,height=10,units="cm")


}

