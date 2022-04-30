#devtools::install_github("AdrianHordyk/LBSPR")

require(LBSPR); require(data.table); require(openxlsx); require(grid); require(gridExtra); require(ggplot2); require(ggplotify); require(dplyr); require(this.path)
root_dir <- this.path::here(..=2)


# Format: # Species,Option,Linf,K,CVLinf,M,Amax,L50,L95,Note
LH.List <- list()
l <- 1
#APRU
Sp <- "APRU"
LH.List[[l]] <- list(Sp,"Option1", 84.8,0.125,0.1,0.22,30,46.9,51.9,"StepwiseLH, 86.65 TL cm L99(BBS), M from Then"); l<-l+1
LH.List[[l]] <- list(Sp,"Option2", 84.8,0.125,0.1,0.11,30,46.9,51.9,"StepwiseLH, 86.65 TL cm L99(BBS), M from Nadon"); l<-l+1
LH.List[[l]] <- list(Sp,"Option3",105.7,0.160,0.1,0.20,16,46.9,51.9,"Fry2006, M from Fry2006/N (amax=16)"); l<-l+1
#LH.List[[l]] <- list(Sp,"Option1",122.9,0.163,0.1,0.20,16,46.9,51.9,"Ralston1988, M from Fry2006/Nadon2012,Lmat from StepWise"); l<-l+1

#APVI
Sp <- "APVI"
LH.List[[l]] <- list(Sp,"Option1",72.0,0.15,0.1,0.200,32,44.8,45.5,"StepwiseLH, M from Then"); l<-l+1 
LH.List[[l]] <- list(Sp,"Option2",72.0,0.33,0.1,0.200,32,44.8,45.5,"O'Malley2021, M from Then"); l<-l+1   
LH.List[[l]] <- list(Sp,"Option3",72.0,0.33,0.1,0.101,32,44.8,45.5,"O'Malley2021, M from Nadon, Lmat from Everson1989"); l<-l+1

#CALU
Sp <- "CALU"
LH.List[[l]] <- list(Sp,"Option1",78.2,0.22,0.1,0.57,11,38,43,"StepwiseLH, 75.9 TL cm L99(BBS), M from Then"); l<-l+1 
LH.List[[l]] <- list(Sp,"Option2",82.2,0.12,0.1,0.50,12,38,43,"Menezes1968 (Brazil), M from Fry 2016/Then"); l<-l+1   
LH.List[[l]] <- list(Sp,"Option3",82.2,0.12,0.1,0.27,12,38,43,"Menezes1968 (Brazil), M from Fry 2016/Nadon, Lmat Garcia-Cagide1994 (Cuba)"); l<-l+1

#ETCO
Sp <- "ETCO"
LH.List[[l]] <- list(Sp,"Option1",82.1,0.133,0.1,0.12,55,54.7,59.7,"Uehara2020 (Japan), M from Then"); l<-l+1   
LH.List[[l]] <- list(Sp,"Option2",82.1,0.133,0.1,0.06,55,54.7,59.7,"Uehara2020 (Japan), M from Nadon, Lmat from Reed 2021 (Hawaii)"); l<-l+1
LH.List[[l]] <- list(Sp,"Option3",91.5,0.118,0.1,0.21,32,50.3,53.3,"StepwiseLH from L99 of 93.2 FL cm (BBS), M from Then"); l<-l+1   

#LERU
Sp <- "LERU"
LH.List[[l]] <- list(Sp,"Option1",31.5,0.800,0.1,0.40, 8,22.6,25.5,"Trianni 2011 (Mariana), M from Nadon, Lmat Trianni, avg of two locations"); l<-l+1
LH.List[[l]] <- list(Sp,"Option2",38.3,0.415,0.1,0.47,13,22.6,25.5,"Ebisawa 2009 (Japan), M from Then"); l<-l+1
LH.List[[l]] <- list(Sp,"Option3",38.3,0.415,0.1,0.25,13,22.6,25.5,"Ebisawa 2009 (Japan), M from Nadon"); l<-l+1
LH.List[[l]] <- list(Sp,"Option4",34.2,0.412,0.1,0.40,16,22.6,25.5,"StepwiseLH, M from Then"); l<-l+1

#LUKA
Sp <- "LUKA"
LH.List[[l]] <- list(Sp,"Option1",29.0,0.45,0.1,0.40,15,21.3,24.3,"StepwiseLH from an L99 of 33.2 TL cm from UVS"); l<-l+1 
LH.List[[l]] <- list(Sp,"Option2",33.0,0.29,0.1,0.40, 8,21.3,24.3,"Morales-Nin 1990 (Hawaii), M from Amax=8 (Nadon), Lmat StepwiseLH from L99 33.2 TL cm (Divers) +3 cm for L95"); l<-l+1
LH.List[[l]] <- list(Sp,"Option3",33.0,0.29,0.1,0.73, 8,21.3,24.3,"Morales-Nin 1990 (Hawaii), M from Amax=8 (Then)"); l<-l+1   

#PRFL
Sp <- "PRFL"       
LH.List[[l]] <- list(Sp,"Option1",41.2,0.47,0.1,0.230,28,27.0,32.0,"O'Malley 2019 (Mariana), M from Amax=28 (Then)"); l<-l+1   
LH.List[[l]] <- list(Sp,"Option2",41.2,0.47,0.1,0.111,28,27.0,32.0,"O'Malley 2019 (Mariana), M from Amax=28 (Nadon), Lmat from Brouard 1985 (Vanuatu)"); l<-l+1
LH.List[[l]] <- list(Sp,"Option3",48.3,0.24,0.1,0.290,22,27.0,32.0,"StepwiseLH from an L99 of 52.2 FL (biosampling), M from Then"); l<-l+1 

#PRZO
Sp <- "PRZO"
LH.List[[l]] <- list(Sp,"Option1",36.9,0.29,0.1,0.22,30,23.6,26.6,"Schemmel 2022 (Guam), M from Amax=30 (Then)"); l<-l+1
LH.List[[l]] <- list(Sp,"Option2",36.9,0.29,0.1,0.11,30,23.6,26.6,"Schemmel 2022 (Guam), M from Amax=30 (Nadon), Lmat from Schemmel 2022 (Guam)"); l<-l+1
LH.List[[l]] <- list(Sp,"Option3",42.5,0.38,0.1,0.25,26,23.6,26.6,"Andrews 2021 (Hawaii), M from Amax=26 (Then)"); l<-l+1
LH.List[[l]] <- list(Sp,"Option4",40.2,0.29,0.1,0.32,20,23.6,26.6,"Andrews 2021 (Hawaii), M from Amax=20 (Then)"); l<-l+1
LH.List[[l]] <- list(Sp,"Option5",39.9,0.29,0.1,0.32,20,25.6,28.6,"StepwiseLH from L99 of 44.5 FL cm from BBS, M from Amax=20 (Then)"); l<-l+1

#VALO
Sp <- "VALO"
LH.List[[l]] <- list(Sp,"Option1",43.5,0.26,0.1,0.44,14,25.8,28.8,"Schemmel 2022, M from Amax=14 (Then)"); l<-l+1   
LH.List[[l]] <- list(Sp,"Option2",43.5,0.26,0.1,0.23,14,25.8,28.8,"Schemmel 2022, M from Amax=14 (Nadon), Lmat from Schemmel 2022"); l<-l+1
LH.List[[l]] <- list(Sp,"Option3",43.3,0.23,0.1,0.33,19,25.8,28.8,"StepwiseLH with L99 of 45.8 FL cm (biosamp), M from Amax=19 (Then)"); l<-l+1 


LH <- rbindlist(LH.List)
colnames(LH) <- c("SPECIES","OPTION","LINF","K","CVLINF","M","AMAX","L50","L95","NOTE")

N_OPTIONS           <- data.table( table(LH$SPECIES) )
colnames(N_OPTIONS) <- c("SPECIES","N_OPTIONS")
Species.List        <- data.table(SPECIES=c("APRU","APVI","CALU","ETCO","LERU","LUKA","PRFL","PRZO","VALO"))
Species.List        <- merge(Species.List,N_OPTIONS,by="SPECIES")

# Get size structure data
SIZDAT  <- readRDS(paste0(root_dir,"/Outputs/SIZE_Final.rds"))
SIZDAT  <- SIZDAT[,!"EFFN"]

OUT.List <- data.table()
for(i in 1:nrow(Species.List)){
  
  Sp        <- Species.List[i]$SPECIES
  N_Options <- Species.List[i]$N_OPTIONS 
  
  DAT         <- SIZDAT[SPECIES==Sp]
  BinWidth    <- unique(DAT$LENGTH_BIN_START)[2] 
  
  # Add a few larger size bins to help LBSPR run
  
  DAT     <- rbind(DAT, data.table(SPECIES="FAKE",DATASET="FAKE",YEAR=2000,AREA_C="FAKE",LENGTH_BIN_START=seq(0,max(DAT$LENGTH_BIN_START)+2*BinWidth,by=BinWidth),N=0) )
  DAT     <- dcast(DAT,SPECIES+DATASET+AREA_C+YEAR~LENGTH_BIN_START,value.var="N",fill=0)
  DAT     <- melt(DAT,id.vars=1:4,variable.name="LENGTH",value.name="N")
  DAT     <- DAT[SPECIES!="FAKE"]
  
  # Continue
  DAT        <- dcast(DAT,SPECIES+DATASET+AREA_C+LENGTH~YEAR,value.var="N",fill=0)
  DAT$LENGTH <- as.numeric(as.character(DAT$LENGTH))
  DAT$LENGTH <- DAT$LENGTH+(BinWidth/2) #Convert lengths to mid-points
  DAT$SPECIES <- NULL
  
  # Split datasets and regions
  BBS_Main <- DAT[DATASET=="BBS"&AREA_C=="Main",!c("DATASET","AREA_C")]
  BS_Main  <- DAT[DATASET=="Biosampling"&AREA_C=="Main",!c("DATASET","AREA_C")]
  US_Atoll <- DAT[DATASET=="UVS"&AREA_C=="Atoll",!c("DATASET","AREA_C")]
  US_Main  <- DAT[DATASET=="UVS"&AREA_C=="Main",!c("DATASET","AREA_C")]
  
  # Remove empty years
  BBS_Main <- BBS_Main[,c(which(colSums(BBS_Main) != 0)),with=F]
  BS_Main  <- BS_Main[,c(which(colSums(BS_Main) != 0)),with=F]
  US_Atoll <- US_Atoll[,c(which(colSums(US_Atoll) != 0)),with=F]
  US_Main  <- US_Main[,c(which(colSums(US_Main) != 0)),with=F]
  
  # Save to csv files (easier integration with LBSPR)
  Drive <- paste0(root_dir,"/Outputs/LBSPR/Temp size/",Sp)
  write.csv(BBS_Main,paste0(Drive,"_BBS_Main.csv"),row.names=F)
  write.csv(BS_Main,paste0(Drive,"_BS_Main.csv"),row.names=F)
  write.csv(US_Atoll,paste0(Drive,"_UVS_Atoll.csv"),row.names=F)
  write.csv(US_Main,paste0(Drive,"_UVS_Main.csv"),row.names=F)
  
  for(j in 1:N_Options){
    
    Option.Name <- LH[SPECIES==Sp]$OPTION[j]
    
    aLH <- LH[SPECIES==Sp&OPTION==Option.Name]
    
    # Load LH parameters
    MyPars          <- new("LB_pars")
    MyPars@Species  <- paste(Sp,"Option",j)
    MyPars@Linf     <- aLH$LINF
    MyPars@CVLinf   <- aLH$CVLINF
    MyPars@MK       <- aLH$M/aLH$K
    MyPars@L50      <- aLH$L50
    MyPars@L95      <- aLH$L95
    MyPars@BinWidth <- BinWidth
    MyPars@L_units  <- "cm"
    
    # Load data in LBSPR object
    LenBBS_Main <- new("LB_lengths", LB_pars=MyPars, file=paste0(Drive,"_BBS_Main.csv"),dataType="freq", header=TRUE)
    LenBS_Main  <- new("LB_lengths", LB_pars=MyPars, file=paste0(Drive,"_BS_Main.csv"),dataType="freq", header=TRUE)
    
    if(length(US_Atoll>0))
      LenUS_Atoll <- new("LB_lengths", LB_pars=MyPars, file=paste0(Drive,"_UVS_Atoll.csv"),dataType="freq", header=TRUE)
    
    if(length(US_NWHI>0))
      LenUS_NWHI  <- new("LB_lengths", LB_pars=MyPars, file=paste0(Drive,"_UVS_NWHI.csv"),dataType="freq", header=TRUE)
    
    if(length(US_Main>0))
      LenUS_Main  <- new("LB_lengths", LB_pars=MyPars, file=paste0(Drive,"_UVS_Main.csv"),dataType="freq", header=TRUE)
    
    # Fit data to model
    myFit_BBMain   <- LBSPRfit(MyPars, LenBBS_Main)
    myFit_BSMain   <- LBSPRfit(MyPars, LenBS_Main)
    if(length(US_Atoll>0)) myFit_UVSAtoll <- LBSPRfit(MyPars, LenUS_Atoll)
    if(length(US_NWHI>0))  myFit_UVSNWHI  <- LBSPRfit(MyPars, LenUS_NWHI)
    if(length(US_Main>0))  myFit_UVSMain  <- LBSPRfit(MyPars, LenUS_Main)
    
    # Outputs
    if(Sp=="APVI"|Sp=="LUKA"){
      OUT <-rbind( cbind("BBS_Main", myFit_BBMain@Years,myFit_BBMain@FM*aLH$M,myFit_BBMain@SPR,myFit_BBMain@SL50),
                   cbind("BS_Main",  myFit_BSMain@Years,myFit_BSMain@FM*aLH$M,myFit_BSMain@SPR,myFit_BSMain@SL50),
                   cbind("UVS_Main", myFit_UVSMain@Years,myFit_UVSMain@FM*aLH$M,myFit_UVSMain@SPR,myFit_UVSMain@SL50),
                   cbind("UVS_Atoll",myFit_UVSNWHI@Years,myFit_UVSNWHI@FM*aLH$M,myFit_UVSNWHI@SPR,myFit_UVSAtoll@SL50),
                   cbind("UVS_NWHI", myFit_UVSAtoll@Years,myFit_UVSAtoll@FM*aLH$M,myFit_UVSAtoll@SPR,myFit_UVSNWHI@SL50)
      )
    } else {
      OUT <-rbind( cbind("BBS_Main", myFit_BBMain@Years,myFit_BBMain@FM*aLH$M,myFit_BBMain@SPR,myFit_BBMain@SL50),
                   cbind("BS_Main",  myFit_BSMain@Years,myFit_BSMain@FM*aLH$M,myFit_BSMain@SPR,myFit_BSMain@SL50))
    }
    
    OUT         <- data.table(OUT)
    setnames(OUT,c("DATASET","YEAR","F","SPR","SL50"))
    OUT[,2:5]   <- rapply(OUT[,2:5],as.numeric,how="replace")
    OUT[,3:4]   <- round(OUT[,3:4],2)
    OUT[,5]     <- round(OUT[,5],0)
    OUT$SPECIES <- Sp
    OUT$OPTION  <- Option.Name
    OUT         <- select(OUT,SPECIES,OPTION,DATASET,YEAR,F,SPR,SL50)
    
   
    
    OUT.List <- rbind(OUT.List, OUT)
    
   
    # Create some graphs
    Drive2 <- paste0(root_dir,"/Outputs/LBSPR/Graphs/",Sp,"_",Option.Name)
    
    aFit1  <- as.ggplot(plotSize(myFit_BBMain))
    aFit2  <- as.ggplot(plotSize(myFit_BSMain))
    Fit    <- arrangeGrob(aFit1,aFit2,ncol=1)
    ggsave(Fit,filename=paste0(Drive2,"_Fit.png"),height=20,width=15,units="cm")
    
    aGraph1 <- ggplot(data=OUT,aes(x=YEAR,y=F,col=DATASET))+geom_line(size=1)+geom_point(size=3)+ggtitle(Sp)+theme_bw()
    aGraph2 <- ggplot(data=OUT,aes(x=YEAR,y=SPR,col=DATASET))+geom_line(size=1)+geom_point(size=3)+theme_bw()
    aGraph3 <- ggplot(data=OUT,aes(x=YEAR,y=SL50,col=DATASET))+geom_line(size=1)+geom_point(size=3)+theme_bw()
    Graph   <- arrangeGrob(aGraph1,aGraph2,aGraph3,ncol=1)
    ggsave(Graph,filename=paste0(Drive2,"_Results.png"),height=20,width=15,units="cm")
    
    
    } # End Option loop
} # End Species loop


# Merge LH and results
Final <- merge(LH,OUT.List,by=c("SPECIES","OPTION"))
Final <- select(Final,SPECIES,OPTION,DATASET,YEAR,SL50,F,SPR,NOTE)

Summary1 <- Final[OPTION=="Option1"&YEAR>=2010&DATASET!="UVS_NWHI",list(SPR=mean(SPR)),by=list(SPECIES,DATASET)]
Summary2 <- dcast(Summary1,SPECIES~DATASET,value.var="SPR")

write.xlsx(Summary2,paste0(root_dir,"/Outputs/LBSPR/Graphs/LBSPR_Summary.xlsx"))
write.xlsx(Final,paste0(root_dir,"/Outputs/LBSPR/Graphs/LBSPR_Results.xlsx"))

aPlot <- ggplot(data=Summary1)+
           geom_hline(aes(yintercept=0.3),col="red",size=1)+
           geom_hline(aes(yintercept=0.4),col="orange",size=1)+
           geom_point(aes(x=SPECIES,y=SPR,fill=DATASET),shape=21,size=5)+
           theme_bw()

ggsave(aPlot,file=paste0(root_dir,"/Outputs/LBSPR/Graphs/LBSPR_Results.png"),width=20,height=8,unit="cm")



















