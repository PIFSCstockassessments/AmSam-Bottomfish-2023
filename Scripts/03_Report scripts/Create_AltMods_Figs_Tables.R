##Create figures and tables for alternate model runs for American Samoa BMUS assessment 2023

require(pacman)
pacman::p_load(this.path,r4ss,tidyverse,reshape2,scales,RColorBrewer,gridExtra,dplyr,png,grid,gridExtra,ggsci,data.table)
root_dir <- here(..=2)

## Example set up for function (use for testing purposes)
# Summary <-SSsummarize(alt_mods1)
# ModelLabels<-c("Base","M = 0.16","M = 0.2","Linf = 75.5", "Linf = 92.3", "Steep = 0.65", "Steep = 0.79")
# Directory<-file.path(root_dir, "SS3 final models", species, "11_Alternate_Mods_Figs_Tables")
# dir.create(Directory)
# NModels<-Summary$n
# model_group = 1 (or 2) 1 refers to the base and alt models with +/- changes, 2 refers to base and alt LH, no hist catch, rec devs and no hermaphro 

plotsensitivity<-function(Summary, ModelLabels, NModels, PlotDir, model_group ){

  
  ModelLabels<-paste0(letters[seq(from=1,to=length(ModelLabels))],") ",ModelLabels)
  
  
  aTheme <- theme(panel.border = element_rect(color="black",fill=NA,size=1),
                  panel.background = element_blank(), strip.background = element_blank(),
                  legend.title=element_blank(),legend.key=element_blank())
  
  Startyrs <- data.frame("variable" = ModelLabels, "StartYear" = Summary$startyrs) %>% 
    group_by(variable)
  max_yr=unique(Summary$endyrs)
  NatM <- Summary$pars[which(Summary$pars$Label == "NatM_uniform_Fem_GP_1"),1:NModels]
  
  SummaryBio<-Summary$SpawnBio
  names(SummaryBio)<-c(ModelLabels,"Label","Yr")
  SSBMSY<-Summary$quants[which(Summary$quants$Label=="SSB_MSY"),]
  # CHECK: Calculating SSBMSST correctly (SSB_MSY * (1-NatM) [or 0.5 if that is > 1-NatM])
  SSBMSST<- pmax(0.5,1-NatM) * SSBMSY[1,1:NModels]
  SummaryBratio<-as.data.frame(matrix(NA,ncol=NModels, nrow=nrow(SummaryBio)))
  for(i in 1:NModels){
    for (j in 1:nrow(SummaryBio)){
      SummaryBratio[j,i]<-SummaryBio[j,i]/SSBMSST[i]
    }}
  SSBMSST <- tidyr::pivot_longer(SSBMSST, cols = everything(), names_to = "Model", values_to = "value")
  SSBMSST$Model <- ModelLabels
  SummaryBratio[,c(NModels+1,NModels+2)]<-SummaryBio[,c(NModels+1,NModels+2)]
  SummaryBio<-reshape2::melt(SummaryBio,id.vars=c("Label","Yr"))
  SummaryBio <- SummaryBio %>% 
    merge(Startyrs, by = "variable") %>% 
    filter(Yr >= StartYear & Yr <= max_yr) %>% 
    select(-StartYear)
  names(SummaryBratio)<-c(ModelLabels,"Label","Yr")
  SummaryBratio<-reshape2::melt(SummaryBratio,id.vars=c("Label","Yr"))
  SummaryBratio<-SummaryBratio %>% 
    merge(Startyrs, by = "variable") %>% 
    filter(Yr >= StartYear & Yr <= max_yr) %>% 
    select(-StartYear)
  SpawnBioUpper<-Summary$SpawnBioUpper
  #names(SpawnBioUpper)<-c(ModelLabels,"Label","Yr")
  SpawnBioUpper<-reshape2::melt(SpawnBioUpper, id.vars=c("Yr", "Label") )
  names(SpawnBioUpper)[3:4]<-c("Model","Upper")
  SpawnBioLower<-Summary$SpawnBioLower 
  #names(SpawnBioLower)<-c(ModelLabels,"Label","Yr")
  SpawnBioLower<-reshape2::melt(SpawnBioLower, id.vars=c("Yr", "Label") )
  names(SpawnBioLower)[3:4]<-c("Model","Lower")
  SpawnBioUncertainty<-merge(SpawnBioUpper,SpawnBioLower,by=c("Yr","Label","Model"))  
  
  Model.names          <- data.frame(Model= unique(SpawnBioUncertainty$Model) ) 
  Model.names$variable <- ModelLabels
  
  SpawnBioUncertainty <- merge(SpawnBioUncertainty,Model.names,by="Model")
  # CHECK: not sure what lines need to get removed here, previously it was just hardcoded lines 1-6. Maybe all ssb_virgin and initial?
  #SpawnBioUncertainty <- SpawnBioUncertainty[-c(1:14),] 
  # Replacing line above with filterting for years between start and max yr
  SpawnBioUncertainty <- SpawnBioUncertainty %>% 
    merge(Startyrs, by = "variable") %>% 
    filter(Yr >= StartYear & Yr <= max_yr) %>% 
    select(-StartYear) %>% 
    group_by(variable) %>% 
    arrange(Yr, .by_group = T)
  
  SummaryBio          <- data.table(SummaryBio)
  SpawnBioUncertainty <- data.table(SpawnBioUncertainty)
  
  shapes <- c(16,15,17,18,8,10,12)
  
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
        theme_bw(base_size=20)+aTheme+theme(legend.position="none")+
        scale_x_continuous(expand=c(0,0))+scale_y_continuous(expand=expansion(mult=c(0.01,0.05)),limits=c(0,NA))
  #a
  
  FishingMort<-Summary$Fvalue
  names(FishingMort)<-c(ModelLabels,"Label","Yr")
  FishingMort<-reshape2::melt(FishingMort,id.vars=c("Label","Yr"))
  FishingMort<-FishingMort %>% 
    merge(Startyrs, by = "variable") %>% 
    filter(Yr >= StartYear & Yr <= max_yr) %>% 
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
  Funcertainty <- filter(Funcertainty, Yr <= max_yr)
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
       theme_bw(base_size=20)+aTheme +theme(legend.position="none")+
       scale_x_continuous(expand=c(0,0))+scale_y_continuous(expand=expansion(mult=c(0.01,0.05)),limits=c(0,NA))
  #b
  
  
  
  Recruits<-Summary$recruits
  names(Recruits)<-c(ModelLabels,"Label","Yr")
  Recruits<-reshape2::melt(Recruits,id.vars=c("Label","Yr"))
  Recruits<-Recruits %>% 
    merge(Startyrs, by = "variable") %>% 
    filter(Yr >= StartYear & Yr <= max_yr) %>% 
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
       theme_bw(base_size=20)+aTheme+
       scale_x_continuous(expand=c(0,0))+scale_y_continuous(expand=expansion(mult=c(0.01,0.05)),limits=c(0,NA))
  
  # CHECK: added the legend back in to this plot so can see what colors match up with what model, can remove or change which plot has legend just need to add in + theme(legend.position = "none")
  #c
  
  # Kobe plot
  Results <- setNames(data.frame(matrix(ncol = 3, nrow = NModels)), 
                      c("Model", "B_Bmsy_term", "F_Fmsy_term"))
  Results$Model <- ModelLabels
  
  rnames <- Summary$quants$Label
  index_SSB_MSY = which(rnames==paste("SSB_MSY",sep=""))
  index_Fstd_MSY = which(rnames==paste("annF_MSY",sep=""))
  index_SSB_TermYr = which(rnames==paste("SSB_",max_yr,sep=""))
  index_Fstd_TermYr = which(rnames==paste("F_",max_yr,sep=""))
  Fstd_MSY_est = Summary$quants[index_Fstd_MSY,1:NModels]
  SSB_TermYr_est  = Summary$quants[index_SSB_TermYr,1:NModels]
  Fstd_TermYr_est = Summary$quants[index_Fstd_TermYr,1:NModels]
  Results$B_Bmsy_term <- reshape2::melt(SSB_TermYr_est/SSBMSST$value)[,"value"]
  Results$F_Fmsy_term <- reshape2::melt(Fstd_TermYr_est/Fstd_MSY_est)[,"value"]
 
  
  x_max = max(Results$B_Bmsy_term,3)*1.05
  x_min = 0
  y_max = max(max(Results$F_Fmsy_term)+0.1,1.45)
  y_min = 0
  # CHECK: Using just base NatM for MSST for drawing boundaries
  MSST_x = 1-NatM[1,1]
  
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
         labs(x=expression(SSB/SSB[MSY]), y=expression(F/F[MSY]))+
         scale_y_continuous(expand=expansion(mult=c(0.01,0.01)),limits=c(0, y_max))+theme_bw()+
         theme(panel.border = element_blank())  
  
  # CHECK: Include last year uncertainty??
  #d <- d + geom_point(data=Last.Year,aes(x=B_BMSST,y=F_FMSY))+geom_point(size=0.2)
  d <- d +
    geom_point(data=Results,
               aes(x=B_Bmsy_term, y=F_Fmsy_term, group = Model, 
                   shape=Model, fill = Model, color = Model), size=3) +
    scale_shape_manual(values=shapes) +
    scale_color_jco()
  #d
  
  png(paste0(PlotDir,"\\Sensitivity", model_group,".png"),height=10,width=16,units="in",res=200)
  grid.arrange(a,c,b,d, nrow=2)
  dev.off()
  
  
}


### Run plot function for individual species ####
## Change species name here
species_names <- c("APRU", "APVI", "CALU", "ETCO", "LERU", "LUKA", "PRFL", "PRZO", "VALO")
species <- species_names[9]

## List directories here
# delete any previously created folder of figures and tables
unlink(file.path(root_dir, "SS3 final models", species, "00_Alternate_Mods_Figs_Tables"), recursive = T)
alt_mods_dir <- list.dirs(file.path(root_dir, "SS3 final models", species), recursive = F)

## Read in all model report files
alt_models <- SSgetoutput(dirvec = alt_mods_dir) 

## Separate models for easier plotting 
## base model, M+/-, Linf +/-, steep +/-
alt_mods1 <- alt_models[1:7]
## base model, alt LH, rec dev on, no historical catch
alt_mods2 <- alt_models[c(1,8:length(alt_mods_dir))]


## First set of alternate models
Summary <-SSsummarize(alt_mods1)
# Labels for model group 1
ModelLabels<-c("Base","M-10%","M+10%","Linf-10%", "Linf+10%", "Steep-10%", "Steep+10%")
Directory<-file.path(root_dir, "SS3 final models", species, "00_Alternate_Mods_Figs_Tables")
dir.create(Directory)
NModels<-Summary$n
plotsensitivity(Summary, ModelLabels, NModels, Directory, model_group = 1)

## Second set of alternate models
Summary <-SSsummarize(alt_mods2)
# Labels for model group 2
ModelLabels<-c("Base","Alternate LH","RecDev","No Historical Catch")

if(species=="LERU"|species=="VALO")
ModelLabels<-c("Base","Alternate LH","RecDev","No Historical Catch","No hermaphro.")

#ModelLabels<-c("Base","Alternate LH","RecDev","No Historical Catch", "No Hermaphro")
Directory<-file.path(root_dir, "SS3 final models", species, "00_Alternate_Mods_Figs_Tables")
NModels<-Summary$n
plotsensitivity(Summary, ModelLabels, NModels, Directory, model_group = 2)

### Create a summary table with all scenario runs #####
Summary <- SSsummarize(alt_models)
max_yr=unique(Summary$endyrs)

## Ignores the 11_Alternate_Mods_Figs_Table folder
Model.folders <- alt_mods_dir
N <- length(Model.folders)
Results       <- data.table(Model=Model.folders, 
                            Fendyr=numeric(N),
                            Fmsy=numeric(N),
                            Fendyr_Fmsy=numeric(N),
                            SSBmsy=numeric(N),
                            SSBMSST=numeric(N),
                            SSBendyr=numeric(N),
                            SSBendyr_SSBmsy=numeric(N),
                            SSBendyr_SSBMSST=numeric(N),
                            CatchMSY=numeric(N))

Results$Model <- str_remove(Results$Model, paste0(root_dir,"/SS3 final models/", species, "/"))
for(i in 1:length(Model.folders)){
  
  aModel                    <- SS_output(Model.folders[i],covar=FALSE, 
                                         verbose=FALSE, printstats = FALSE)
  rnames                    <- aModel$derived_quants$Label
  index_SSB_MSY             <- which(rnames==paste("SSB_MSY",sep=""))
  index_Fstd_MSY            <- which(rnames==paste("annF_MSY",sep=""))
  index_SSB_TermYr          <- which(rnames==paste("SSB_",max_yr,sep=""))
  index_Fstd_TermYr         <- which(rnames==paste("F_",max_yr,sep=""))
  index_MSY                 <- which(rnames==paste("Dead_Catch_MSY",sep=""))
  NatM                      <- aModel$parameters %>% 
    filter(str_detect(Label, "NatM")) %>% 
    pull(Value)
  
  Results[i]$SSBmsy         <- round(aModel$derived_quants[index_SSB_MSY,2],1)
  Results[i]$SSBMSST        <- round(aModel$derived_quants[index_SSB_MSY,2]*max(0.5,1-NatM),1)
  Results[i]$Fmsy           <- round(aModel$derived_quants[index_Fstd_MSY,2],2)
  Results[i]$SSBendyr        <- round(aModel$derived_quants[index_SSB_TermYr,2],1)
  Results[i]$Fendyr          <- round(aModel$derived_quants[index_Fstd_TermYr,2],3)
  Results[i]$Fendyr_Fmsy     <- round(Results[i]$Fendyr/Results[i]$Fmsy,2)  
  Results[i]$SSBendyr_SSBmsy <- round(Results[i]$SSBendyr/Results[i]$SSBmsy,1)
  Results[i]$SSBendyr_SSBMSST <- round(Results[i]$SSBendyr/Results[i]$SSBMSST,1)
  Results[i]$CatchMSY       <- round(aModel$derived_quants[index_MSY,2],1)
}

names(Results) <- c("Model", 
                    paste0("F", max_yr),
                    "Fmsy",
                    paste0("F", max_yr, "_Fmsy"),
                    "SSBmsy",
                    "SSBMSST",
                    paste0("SSB", max_yr),
                    paste0("SSB", max_yr, "_SSBmsy"),
                    paste0("SSB", max_yr, "_SSBMSST"),
                    "CatchMSY")

write.csv(Results,file= paste0(root_dir,"/SS3 final models/", species, "/00_Alternate_Mods_Figs_Tables/Results.csv"))



### Loop for doing all species at one time ####
species_names <- c("APRU", "APVI", "CALU", "ETCO", "LERU", "LUKA", "PRFL", "PRZO", "VALO")

for(species in species_names){
  
  #species <- i
  # delete previous figures and tables directory
  unlink(file.path(root_dir, "SS3 final models", species, "00_Alternate_Mods_Figs_Tables"), recursive = T)
  ## Set up directories here
  alt_mods_dir <- list.dirs(file.path(root_dir, "SS3 final models", species), recursive = F)
  
  ## Read in all model report files
  alt_models <- SSgetoutput(dirvec = alt_mods_dir) 
  
  ## Separate models for easier plotting 
  ## base model, M+/-, Linf +/-, steep +/-
  alt_mods1 <- alt_models[1:7]
  ## base model, alt LH, rec dev on, no historical catch
  alt_mods2 <- alt_models[c(1,8:length(alt_models))]
  
  Directory<-file.path(root_dir, "SS3 final models", species, "00_Alternate_Mods_Figs_Tables")
  dir.create(Directory)
  for(model_group in 1:2){
    
    if(model_group == 1){
      Summary <-SSsummarize(alt_mods1)
      ModelLabels<-c("Base","M-10%","M+10%","Linf-10%", "Linf+10%", "Steep-10%", "Steep+10%")
    }
    if(model_group == 2){
      Summary <-SSsummarize(alt_mods2)
      if(species == "LERU"| species == "VALO"){
        ModelLabels<-c("Base","Alternate LH","RecDev","No Historical Catch", "No Hermaphro")
      }else{
        ModelLabels<-c("Base","Alternate LH","RecDev","No Historical Catch")
      }
    }

    NModels<-Summary$n
    plotsensitivity(Summary, ModelLabels, NModels, Directory, model_group)
  }
  
  Summary <- SSsummarize(alt_models)
  ## Create results table csv file
  max_yr=unique(Summary$endyrs)
  
  ## Ignores the 11_Alternate_Mods_Figs_Table folder
  Model.folders <- alt_mods_dir
  N <- length(Model.folders)
  Results       <- data.table(Model=Model.folders, 
                              Fendyr=numeric(N),
                              Fmsy=numeric(N),
                              Fendyr_Fmsy=numeric(N),
                              SSBmsy=numeric(N),
                              SSBMSST=numeric(N),
                              SSBendyr=numeric(N),
                              SSBendyr_SSBmsy=numeric(N),
                              SSBendyr_SSBMSST=numeric(N),
                              CatchMSY=numeric(N))
  
  Results$Model <- str_remove(Results$Model, paste0(root_dir,"/SS3 final models/", species, "/"))
  for(i in 1:length(Model.folders)){
    
    aModel                    <- SS_output(Model.folders[i],covar=FALSE, 
                                           verbose=FALSE, printstats = FALSE)
    rnames                    <- aModel$derived_quants$Label
    index_SSB_MSY             <- which(rnames==paste("SSB_MSY",sep=""))
    index_Fstd_MSY            <- which(rnames==paste("annF_MSY",sep=""))
    index_SSB_TermYr          <- which(rnames==paste("SSB_",max_yr,sep=""))
    index_Fstd_TermYr         <- which(rnames==paste("F_",max_yr,sep=""))
    index_MSY                 <- which(rnames==paste("Dead_Catch_MSY",sep=""))
    NatM                      <- aModel$parameters %>% 
      filter(str_detect(Label, "NatM")) %>% 
      pull(Value)
    
    Results[i]$SSBmsy         <- round(aModel$derived_quants[index_SSB_MSY,2],1)
    Results[i]$SSBMSST        <- round(aModel$derived_quants[index_SSB_MSY,2]*max(0.5,1-NatM),1)
    Results[i]$Fmsy           <- round(aModel$derived_quants[index_Fstd_MSY,2],2)
    Results[i]$SSBendyr        <- round(aModel$derived_quants[index_SSB_TermYr,2],1)
    Results[i]$Fendyr          <- round(aModel$derived_quants[index_Fstd_TermYr,2],3)
    Results[i]$Fendyr_Fmsy     <- round(Results[i]$Fendyr/Results[i]$Fmsy,2)  
    Results[i]$SSBendyr_SSBmsy <- round(Results[i]$SSBendyr/Results[i]$SSBmsy,1)
    Results[i]$SSBendyr_SSBMSST <- round(Results[i]$SSBendyr/Results[i]$SSBMSST,1)
    Results[i]$CatchMSY       <- round(aModel$derived_quants[index_MSY,2],1)
  }
  
  names(Results) <- c("Model", 
                      paste0("F", max_yr),
                      "Fmsy",
                      paste0("F", max_yr, "_Fmsy"),
                      "SSBmsy",
                      "SSBMSST",
                      paste0("SSB", max_yr),
                      paste0("SSB", max_yr, "_SSBmsy"),
                      paste0("SSB", max_yr, "_SSBMSST"),
                      "CatchMSY")
  
  write.csv(Results,file= paste0(root_dir,"/SS3 final models/", species, "/00_Alternate_Mods_Figs_Tables/Results.csv"))
  
  
}
