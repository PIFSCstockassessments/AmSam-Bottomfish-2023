require(pacman); pacman::p_load(data.table,grid,gtable,ggpubr,openxlsx,r4ss,this.path,tidyverse)
root_dir <- this.path::here(..=2)

Model <- "40_Base" # Select the model to be summarize

Species.List <- c("APRU","APVI","CALU","ETCO","LERU","LUKA","PRFL","PRZO","VALO")

for(s in 1:9){
  
  Sp <- "APRU"
  #Sp <- Species.List[s]

  # Create output directory
  Out_dir <- file.path(root_dir,"Outputs","Report_Inputs",Sp)
  dir.create(Out_dir,recursive=T,showWarnings=F)
  
  fore_dir  <- file.path(root_dir,"SS3 models",Sp,Model,"forecast")
 
  if(!file.exists(file.path(fore_dir,"mv_projections.rds"))){ print(paste0("No projections file found for ",Sp)); next }
  
  mv_fore   <- readRDS(file=file.path(fore_dir,"mv_projections.rds"))
 
setnames(mv_fore,"harvest","F_Fmsy") 

# Start projection analyses at first year of new catch advice (ex. 2021=last year in model,2024=first year model will be used to generate catch advice) 
mv_fore <- mv_fore %>% filter(year>min(year)+1)


Z  <- mv_fore[Catch==FixedCatch,list(F_Fmsy=median(F_Fmsy),SSB_SSBmsst=median(SSB_SSBmsst)),by=list(year,Catch=FixedCatch)]

P1 <- ggplot(data=Z,aes(x=Catch,y=F_Fmsy,linetype=as.character(year)))+geom_point(size=0.1)+labs(x="Fixed catch (mt)",y="F/Fmsy")+
  guides(linetype=guide_legend(title="Final year"))+theme_bw()+geom_smooth(col="black",se=F,size=0.5)

P2 <- ggplot(data=Z,aes(x=Catch,y=SSB_SSBmsst,linetype=as.character(year)))+geom_point(size=0.1)+labs(x="Fixed catch (mt)",y="SSB/SSBmsst")+
  theme_bw()+theme(legend.position="none")+geom_smooth(col="black",se=F,size=0.5,span=1)


aLegend <- get_legend(P2)
ggarrange(P1,P2,ncol=2,common.legend = T,legend.grob = aLegend,legend="right")
ggsave(last_plot(),file=file.path(Out_dir,paste0(Sp,"_Proj_MedianStatus.png")),height=8, width=16,units="cm")


# Calculate number of iterations by Catch and Year...
A <- mv_fore[,list(N_tot=.N),by=list(year,Catch)]

# ...That is under overfishing
B <- mv_fore[F_Fmsy>1,list(N_overfishing=.N),by=list(year,Catch)]
C <- merge(A,B,by=c("year","Catch"),all.x=T)
C[is.na(C$N_overfishing)]$N_overfishing <- 0
C$ProbOverfishing <- C$N_overfishing/C$N_tot

# ...That is overfished
D <- mv_fore[SSB_SSBmsst<1,list(N_overfished=.N),by=list(year,Catch)]
E <- merge(A,D,by=c("year","Catch"),all.x=T)
E[is.na(E$N_overfished)]$N_overfished <- 0
E$ProbOverfished <- E$N_overfished/E$N_tot

P3 <- ggplot(data=C,aes(x=Catch,y=ProbOverfishing,linetype=as.character(year)))+geom_point(size=0.5)+labs(x="Fixed catch (mt)",y="Prob. F > Fmsy")+
  theme_bw()+theme(legend.position="none")+geom_smooth(col="black",se=F,size=0.5,span=0.3)

P4 <- ggplot(data=E,aes(x=Catch,y=ProbOverfished,linetype=as.character(year)))+geom_point(size=0.5)+labs(x="Fixed catch (mt)",y="Prob. SSB < SSBmsst")+
  guides(linetype=guide_legend(title="Final year"))+theme_bw()+geom_smooth(col="black",se=F,size=0.5,span=0.3)

aLegend <- get_legend(P4)
ggarrange(P3,P4,ncol=2,common.legend = T,legend.grob = aLegend,legend="right")
ggsave(last_plot(),file=file.path(Out_dir,paste0(Sp,"_Proj_ProbStatus.png")),height=8, width=16,units="cm")

# Catch risk table 
G       <- select(C[ProbOverfishing>=0.1&ProbOverfishing<=0.6],-N_tot,-N_overfishing)
Preds.x <- expand.grid(ProbOverfishing=seq(0.1,0.5,by=0.01),year=as.factor(seq(min(G$year),max(G$year))))
G$year  <- factor(G$year)
#model   <- gam(data=G,Catch~year+s(ProbOverfishing,by=year),method="REML")
#Preds   <- predict.gam(model,newdata=Preds.x)
model   <- glm(data=G,Catch~year*poly(ProbOverfishing,2))
Preds   <- predict(model,newdata=Preds.x)
Preds   <- cbind(Preds.x,Preds)

# Check the GLM model fit and range of data
G$year <- as.character(G$year)
ggplot()+geom_line(data=Preds,aes(x=Preds,y=ProbOverfishing,col=as.character(year)))+geom_point(data=G,aes(x=Catch,y=ProbOverfishing,col=as.character(year)),shape=2,size=2)+
  theme_bw()+labs(x="Catch",y="Prob. overfishing")
ggsave(last_plot(),file=file.path(Out_dir,paste0(Sp,"_Proj_CheckModelFit.png")),height=8, width=15,units="cm")

# Create Prob. overfishing bins
G$ProbOverfishing     <- round(G$ProbOverfishing,2)

H <- merge(Preds,G,by.x=c("year","ProbOverfishing"),by.y=c("year","ProbOverfishing"),all.x=T)
H <- select(H,Year=year,ProbOverfishing,Catch,Preds)
H$Year <- as.numeric(as.character(H$Year))

# Fill in the catch advice using the model predictions
H <- H %>% mutate(Catch=Preds) %>% select(-Preds) %>%  filter(Year>=2024) %>% 
  group_by(Year,ProbOverfishing) %>% summarize(Catch=round(mean(Catch),2)) %>% 
  mutate(Catch=format(Catch,nsmall=2),ProbOverfishing=format(ProbOverfishing,nsmall=2)) %>% 
  spread(Year,Catch) %>% arrange(desc(ProbOverfishing))

write.xlsx(H,file=file.path(Out_dir,paste0(Sp,"_Proj_Table.xlsx")),sheets="CatchProj")

}
