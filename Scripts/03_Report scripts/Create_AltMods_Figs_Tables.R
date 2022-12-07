##Create figures and tables for alternate model runs for American Samoa BMUS assessment 2023

library(r4ss);library(ggplot2);library(reshape2);library(scales);library(RColorBrewer);library(gridExtra);library(dplyr);library(tidyr);library("png"); library("grid");library("gridExtra")
library(ggsci);library(data.table);library(stringr)

## Change species name here
species_names <- c("APRU", "APVI", "CALU", "ETCO", "LERU", "LUKA", "PRFL", "PRZO", "VALO")
species <- species_names[1]

## Set up directories here
root_dir <- here(..=2)
alt_mods_dir <- list.dirs(file.path(root_dir, "SS3 final models", species), recursive = F)

## Read in all model report files
alt_models <- SSgetoutput(dirvec = alt_mods_dir) 

## Separate models for easier plotting 
## base model, M+/-, Linf +/-, steep +/-
alt_mods1 <- alt_models[1:7]
## base model, alt LH, rec dev on, no historical catch
alt_mods2 <- alt_models[c(1,8:10)]


## Example set up for function (use for testing purposes)
# Summary <-SSsummarize(alt_mods1)
# ModelLabels<-c("Base","M = 0.16","M = 0.2","Linf = 75.5", "Linf = 92.3", "Steep = 0.65", "Steep = 0.79")
# Directory<-file.path(root_dir, "SS3 final models", species, "11_Alternate_Mods_Figs_Tables")
# dir.create(Directory)
# NModels<-Summary$n


plotsensitivity<-function(Summary, ModelLabels, NModels, PlotDir ){

  
  ModelLabels<-paste0(letters[seq(from=1,to=length(ModelLabels))],") ",ModelLabels)
  
  
  aTheme <- theme(panel.border = element_rect(color="black",fill=NA,size=1),
                  panel.background = element_blank(), strip.background = element_blank(),
                  legend.title=element_blank(),legend.key=element_blank())
  
  Startyrs <- data.frame("variable" = ModelLabels, "StartYear" = Summary$startyrs) %>% 
    group_by(variable)
  SummaryBio<-Summary$SpawnBio
  names(SummaryBio)<-c(ModelLabels,"Label","Yr")
  SSBMSY<-Summary$quants[which(Summary$quants$Label=="SSB_MSY"),]
  NatM <- Summary$pars[which(Summary$pars$Label == "NatM_uniform_Fem_GP_1"),1:NModels]
  SSBMSST<- pmax(0.5,1-NatM)
  SummaryBratio<-as.data.frame(matrix(NA,ncol=NModels, nrow=nrow(SummaryBio)))
  for(i in 1:NModels){
    for (j in 1:nrow(SummaryBio)){
      SummaryBratio[j,i]<-SummaryBio[j,i]/SSBMSST[i]
    }}
  SSBMSST<-data.frame("Model" = ModelLabels, "value" = SSBMSST)
  SummaryBratio[,c(NModels+1,NModels+2)]<-SummaryBio[,c(NModels+1,NModels+2)]
  SummaryBio<-reshape2::melt(SummaryBio,id.vars=c("Label","Yr"))
  SummaryBio <- SummaryBio %>% 
    merge(Startyrs, by = "variable") %>% 
    filter(Yr >= StartYear) %>% 
    select(-StartYear)
  names(SummaryBratio)<-c(ModelLabels,"Label","Yr")
  SummaryBratio<-reshape2::melt(SummaryBratio,id.vars=c("Label","Yr"))
  SummaryBratio<-SummaryBratio %>% 
    merge(Startyrs, by = "variable") %>% 
    filter(Yr >= StartYear) %>% 
    select(-StartYear)
  SpawnBioUpper<-Summary$SpawnBioUpper
  SpawnBioUpper<-reshape2::melt(SpawnBioUpper, id.vars=c("Yr", "Label") )
  names(SpawnBioUpper)[3:4]<-c("Model","Upper")
  SpawnBioLower<-Summary$SpawnBioLower 
  SpawnBioLower<-reshape2::melt(SpawnBioLower, id.vars=c("Yr", "Label") )
  names(SpawnBioLower)[3:4]<-c("Model","Lower")
  SpawnBioUncertainty<-merge(SpawnBioUpper,SpawnBioLower,by=c("Yr","Label","Model"))  
  
  Model.names          <- data.frame(Model= unique(SpawnBioUncertainty$Model) ) 
  Model.names$variable <- ModelLabels
  
  # CHECK: not sure what lines need to get removed here, previously it was just hardcoded lines 1-6. Maybe all ssb_virgin and initial?
  SpawnBioUncertainty <- SpawnBioUncertainty[-c(1:14),] 
  SpawnBioUncertainty <- merge(SpawnBioUncertainty,Model.names,by="Model")
  SummaryBio          <- data.table(SummaryBio)
  SpawnBioUncertainty <- data.table(SpawnBioUncertainty)
  
  shapes <- c(16,15,17,18,8,4,3)
  
  # CHECK: I think this section is to deal with extra years when you test no historical catch run but wasn't sure. I adjusted the model label name but that means will need to keep it as run 10 or else fix the label here. Might want to adjust this to be a string detect function to make it more robust. 
  if(ModelLabels[4]=="d) No Historical Catch"){
    SummaryBio          <- SummaryBio[!(variable=="d) No Historical Catch"&Yr<1986)]
    SpawnBioUncertainty <- SpawnBioUncertainty[!(variable=="d) No Historical Catch"&Yr<1986)]
  }
  
  thinned <- c(seq(from=1,to=nrow(SummaryBio),by=10))
  a<-ggplot(data=SummaryBio,aes(x=Yr,color=variable,shape=variable))+
    geom_ribbon(aes(ymin=Lower,ymax=Upper),color=NA,data=SpawnBioUncertainty,fill="gray",alpha=0.2)+
    geom_line(aes(y=value),size=1.5) +
    geom_point(aes(y=value),data=SummaryBio[thinned,], size=4)+
    xlab("Year") + ylab("Spawning biomass (mt)") +
    geom_hline(aes(yintercept=value,color=Model),data=SSBMSST,size=1.5)+
    scale_shape_manual(values=shapes)+
    scale_color_jco()+
    theme_bw(base_size=20)+aTheme+theme(legend.position="none")
  a
  
  FishingMort<-Summary$Fvalue
  names(FishingMort)<-c(ModelLabels,"Label","Yr")
  FishingMort<-reshape2::melt(FishingMort,id.vars=c("Label","Yr"))
  FishingMort<-FishingMort %>% 
    merge(Startyrs, by = "variable") %>% 
    filter(Yr >= StartYear) %>% 
    select(-StartYear)
  FMSY<-Summary$quants[which(Summary$quants$Label=="annF_MSY"),1:NModels]
  FMSY<-reshape2::melt(FMSY)
  FUpper<-Summary$FvalueUpper
  FUpper<-reshape2::melt(FUpper, id.vars=c("Yr", "Label") )
  names(FUpper)[3:4]<-c("Model","FUpper")
  FLower<-Summary$FvalueLower 
  FLower<-reshape2::melt(FLower, id.vars=c("Yr", "Label") )
  names(FLower)[3:4]<-c("Model","FLower")
  Funcertainty<-merge(FUpper,FLower,by=c("Yr","Label","Model"))  
  
  Model.names          <- data.frame(Model=as.character( unique(Funcertainty$Model) ) )
  Model.names$variable <- ModelLabels
  
  Funcertainty <- merge(Funcertainty,Model.names,by="Model")
  colnames(FMSY)   <- c("Model","value")
  FMSY             <- merge(FMSY,Model.names,by="Model")
  
  FishingMort  <- data.table(FishingMort)
  Funcertainty <- data.table(Funcertainty)
  
  if(ModelLabels[4]=="d) No Historical Catch"){  
    FishingMort  <- FishingMort[!(variable=="d) No Historical Catch"&Yr<1986)]  
    Funcertainty <- Funcertainty[!(variable=="d) No Historical Catch"&Yr<1986)]
  }
  
  
  thinned <- c(seq(from=1,to=nrow(FishingMort),by=10))
  b<-ggplot(data=FishingMort,aes(x=Yr,color=variable,shape=variable))+
    geom_ribbon(aes(ymin=FLower,ymax=FUpper),color=NA,data=Funcertainty,fill="gray",alpha=0.2)+
    geom_line(aes(y=value),size=1.5) +
    geom_point(aes(y=value),data=FishingMort[thinned,], size=4)+
    xlab("Year") + ylab("Fishing mortality") +
    geom_hline(aes(yintercept=value,color=variable),data=FMSY,size=1.5)+
    scale_color_jco()+
    scale_shape_manual(values=shapes)+
    theme_bw(base_size=20)+aTheme +theme(legend.position="none")
  b
  
  
  
  Recruits<-Summary$recruits
  names(Recruits)<-c(ModelLabels,"Label","Yr")
  Recruits<-reshape2::melt(Recruits,id.vars=c("Label","Yr"))
  Recruits<-Recruits %>% 
    merge(Startyrs, by = "variable") %>% 
    filter(Yr >= StartYear) %>% 
    select(-StartYear)
  
  Recruits <- data.table(Recruits)
  Recruits <- Recruits[!(variable=="d) No Historical Catch"&Yr<1986)]
  
  thinned <- c(seq(from=1,to=nrow(Recruits),by=10))
  c<-ggplot(data=Recruits,aes(x=Yr,y=value,color=variable,shape=variable)) +
    geom_line(size=1.5) +
    geom_point(data=Recruits[thinned,],size=4)+
    xlab("Year") + ylab("Age-0 recruits (1000s of fish)") +
    scale_linetype_manual(values=c(1:NModels),labels=c(ModelLabels))+
    scale_color_jco()+
    scale_shape_manual(values=shapes)+
    theme_bw(base_size=20)+aTheme 
  # CHECK: added the legend back in to this plot so can see what colors match up with what model, can remove or change which plot has legend just need to add in + theme(legend.position = "none")
  c
  
  # Kobe plot
  max_yr=unique(Summary$endyrs)
  
  Results <- setNames(data.frame(matrix(ncol = 5, nrow = NModels)), 
                      c("Model", "B_Bmsy_term", "F_Fmsy_term", "SSB_MSY", "F_MSY"))
  Results$Model <- ModelLabels
  
  rnames <- Summary$quants$Label
  index_SSB_MSY = which(rnames==paste("SSB_MSY",sep=""))
  index_Fstd_MSY = which(rnames==paste("annF_MSY",sep=""))
  index_SSB_TermYr = which(rnames==paste("SSB_",max_yr,sep=""))
  index_Fstd_TermYr = which(rnames==paste("F_",max_yr,sep=""))
  SSB_MSY_est  = Summary$quants[index_SSB_MSY,1:NModels]
  Fstd_MSY_est = Summary$quants[index_Fstd_MSY,1:NModels]
  SSB_TermYr_est  = Summary$quants[index_SSB_TermYr,1:NModels]
  Fstd_TermYr_est = Summary$quants[index_Fstd_TermYr,1:NModels]
  Results$B_Bmsy_term <- reshape2::melt(SSB_TermYr_est/SSB_MSY_est)[,"value"]
  Results$F_Fmsy_term <- reshape2::melt(Fstd_TermYr_est/Fstd_MSY_est)[,"value"]
  Results$SSB_MSY <- reshape2::melt(SSB_MSY_est)[,"value"]
  Results$F_MSY <- reshape2::melt(Fstd_MSY_est)[,"value"]
  
  TS <- Summary$quants %>% 
    filter(str_detect(Label, "SSB_|F_")) %>% 
    filter(!is.na(Yr)) 
  names(TS) <- c(ModelLabels, "Label", "Yr")
  TS <- TS %>%  
    separate(col = Label, into = c("Label", "Year"), sep = "_", remove = T) %>% 
    pivot_longer(cols = c(1:NModels), names_to = "Model", values_to = "value") %>% 
    pivot_wider(names_from = Label, values_from = value) %>% 
    merge(Results, by= "Model") %>% 
    # CHECK: BMSST is calculated correctly here. Using model-specific NatM to get BMSST for trajectory
    mutate(BMSST=SSB_MSY*pmax(0.5,1-NatM),
           B_BMSST=SSB/BMSST,
           F_FMSY = F/F_MSY) %>% 
    group_by(Model) %>% 
    arrange(Yr) %>% 
    ungroup()
    
  
  x_max = max(max(TS$B_BMSST) + 0.1, 3)
  x_min = 0
  y_max = max(max(TS$F_FMSY)+0.1,1.45)
  y_min = 0
  # CHECK: Using just base NatM for MSST for drawing boundaries
  MSST_x = SSBMSST[SSBMSST$Model == "a) Base", 2]
  
  ## Overfished triangles/trapezoids
  tri_y  <- c(y_min,1,y_min)  
  tri_x  <- c(x_min,MSST_x,MSST_x)
  poly_y <- c(y_min,y_max,y_max,1)
  poly_x <- c(x_min,x_min,MSST_x,MSST_x)
  
  # CHECK: Include this? Subsample of last year position. If so, uncomment line 244
 # Last.Year <- BS[YEAR==max(YEAR)] 
  #Last.Year <- Last.Year[sample(1:nrow(Last.Year),1000)]
  
  # Plot
  d <- ggplot() +
    geom_polygon(aes(x=tri_x, y=tri_y), fill="khaki1", col="black") +
    geom_polygon(aes(x=c(MSST_x, x_max, x_max, MSST_x), y=c(1, 1, y_min, y_min)),
                 fill="palegreen", col="black") +
    geom_polygon(aes(x=poly_x, y=poly_y), fill="salmon", col="black") +
    geom_polygon(aes(x=c(MSST_x, x_max, x_max, MSST_x), y=c(1, 1, y_max, y_max)),
                 fill="khaki1", col="black") + 
    geom_segment(aes(x=1, xend=1, y=0, yend=1)) +
    scale_x_continuous(expand=c(0, 0), limits=c(0, x_max)) +
    scale_y_continuous(expand=c(0, 0), limits=c(0, y_max)) +
    labs(x=expression(SSB/SSB[MSY]), y=expression(F/F[MSY]))
  
  # CHECK: Include last year uncertainty??
  #d <- d + geom_point(data=Last.Year,aes(x=B_BMSST,y=F_FMSY))+geom_point(size=0.2)
  d <- d +
    # CHECK: Right now plotting time series for all models but maybe just need terminal year? It gets hard to see each trajectory
    geom_path(data=TS, aes(x=B_BMSST, y=F_FMSY, group = Model), size=0.1) +
    geom_point(data = TS, aes(x=B_BMSST, y=F_FMSY, shape = Model, group = Model, color = Yr)) +
    scale_shape_manual(values=shapes) +
    scale_fill_gradientn(colors=rev(rainbow(4))) +
    geom_point(data=TS %>% filter(Yr == max(Yr)),
                      aes(x=B_BMSST, y=F_FMSY, group = Model), 
                      shape=21, fill="red", col="black", size=3)
  
  
  d
  
  png(paste0(PlotDir,"\\Sensitivity.png"),height=10,width=16,units="in",res=200)
  grid.arrange(a,c,b,d, nrow=2)
  dev.off()
  
  
}

Summary <-SSsummarize(alt_mods1)
ModelLabels<-c("Base","M = 0.16","M = 0.2","Linf = 75.5", "Linf = 92.3", "Steep = 0.65", "Steep = 0.79")
Directory<-file.path(root_dir, "SS3 final models", species, "11_Alternate_Mods_Figs_Tables")
dir.create(Directory)
NModels<-Summary$n
plotsensitivity(Summary, ModelLabels, NModels, Directory)
