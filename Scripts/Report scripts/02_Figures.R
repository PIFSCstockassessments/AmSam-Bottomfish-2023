require(pacman); pacman::p_load(data.table,grid,gtable,openxlsx,r4ss,this.path,tidyverse)
root_dir <- this.path::here(..=2)

Sp <- "APRU"


Model <- "23_F3_Dirich_NewCatch" 


# Derived quantities graphs
SS.results <- r4ss::SS_output(file.path(root_dir,"SS3 models",Sp, Model),verbose = FALSE, printstats = FALSE)
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


P1 <- ggplot(data=TA)+geom_line(aes(x=YEAR,y=TBIO))+geom_point(aes(x=1967,y=B0),col="red",size=3)+
  geom_ribbon(aes(x=YEAR,ymin=SSB95L,ymax=SSB95U),alpha=0.3)+scale_y_continuous(limits=c(0,B0*1.1),expand=c(0,0))+
  scale_x_continuous(breaks=seq(1960,2030,10))+
  geom_line(aes(x=YEAR,y=SSB))+geom_hline(aes(yintercept=SSB_MSST),linetype="dashed",col="blue")+
  theme_bw()+theme(axis.text.x=element_blank(),axis.title.x=element_blank())+ylab("Biomass (MT)")

P2 <- ggplot(data=TA,aes(x=YEAR,y=F))+geom_ribbon(aes(ymin=F95L,ymax=F95U),alpha=0.3)+geom_line()+
  scale_x_continuous(breaks=seq(1960,2030,10))+
  scale_y_continuous(expand=c(0,0))+theme_bw()+xlab("Year")+ylab("Fishing mortality (yr-1)")
  
grid.arrange(P1,P2,col=1)

P1 <- ggplotGrob(P1)
P2 <- ggplotGrob(P2)

g <- rbind(P1, P2, size = "first")
g$widths <- unit.pmax(P1$widths, P2$widths)
grid.newpage()
grid.draw(g)

ggsave(g,file=file.path(root_dir,"Outputs","Report_Inputs",paste0(Sp,"_Quants.png")),width=10,height=10,units="cm")


# Stock-recruitment relationship
SS.results  <- r4ss::SS_output(file.path(root_dir,"SS3 models",Sp, Model),verbose = FALSE, printstats = FALSE)
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
  scale_color_gradientn(colors=rainbow(4))+theme_bw()+xlab("Spawning biomass (SSB; metric tons)")+ylab("Recruitment (1000 recruits)")

ggsave(last_plot(),filename=file.path(root_dir,"Outputs","Report_Inputs",paste0(Sp,"_SR.png")),width=14,height=7,units="cm",dpi=300)




