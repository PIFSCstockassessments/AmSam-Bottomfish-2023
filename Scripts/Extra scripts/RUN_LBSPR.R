#devtools::install_github("AdrianHordyk/LBSPR")

require(LBSPR); require(data.table); require(openxlsx); require(grid); require(gridExtra); require(ggplot2); require(ggplotify); require(dplyr); require(this.path)
root_dir <- this.path::here(..=2)
dir.create(paste0(root_dir,"/Outputs/LBSPR/Temp size"),recursive=T,showWarnings=F)
dir.create(paste0(root_dir,"/Outputs/LBSPR/Graphs"),recursive=T,showWarnings=F)

# Get size structure data
SIZDAT  <- readRDS(paste0(root_dir,"/Outputs/SS3_Inputs/SIZE_Final.rds"))
SIZDAT  <- SIZDAT[,!"EFFN"]
SIZDAT$LENGTH_BIN_START <- as.numeric(SIZDAT$LENGTH_BIN_START)
LH      <- data.table(  read.xlsx(paste0(root_dir,"/Data/LH parameters.xlsx")) )

colnames(LH) <- c("SPECIES","OPTION","LINF","K","CVLINF","M","AMAX","L50","L95","NOTE")

N_OPTIONS           <- data.table( table(LH$SPECIES) )
colnames(N_OPTIONS) <- c("SPECIES","N_OPTIONS")
Species.List        <- data.table(SPECIES=c("APRU","APVI","CALU","ETCO","LERU","LUKA","PRFL","PRZO","VALO"))
Species.List        <- merge(Species.List,N_OPTIONS,by="SPECIES")


OUT.List <- data.table()
for(i in 1:nrow(Species.List)){
  
  Sp        <- Species.List[i]$SPECIES
  N_Options <- Species.List[i]$N_OPTIONS 
  
  DAT         <- SIZDAT[SPECIES==Sp]
  
  BinWidth <- diff(unique(DAT$LENGTH_BIN_START))
  BinWidth <- as.integer(names(which.max(table(BinWidth))))
  
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
    
    if(length(US_Main>0))
      LenUS_Main  <- new("LB_lengths", LB_pars=MyPars, file=paste0(Drive,"_UVS_Main.csv"),dataType="freq", header=TRUE)
    
    # Fit data to model
    myFit_BBMain   <- LBSPRfit(MyPars, LenBBS_Main)
    myFit_BSMain   <- LBSPRfit(MyPars, LenBS_Main)
    if(length(US_Atoll>0)) myFit_UVSAtoll <- LBSPRfit(MyPars, LenUS_Atoll)
    if(length(US_Main>0))  myFit_UVSMain  <- LBSPRfit(MyPars, LenUS_Main)
    
    # Outputs
    if(Sp=="APVI"|Sp=="LUKA"){
      OUT <-rbind( cbind("BBS_Main", myFit_BBMain@Years,myFit_BBMain@FM*aLH$M,myFit_BBMain@SPR,myFit_BBMain@SL50),
                   cbind("BS_Main",  myFit_BSMain@Years,myFit_BSMain@FM*aLH$M,myFit_BSMain@SPR,myFit_BSMain@SL50),
                   cbind("UVS_Main", myFit_UVSMain@Years,myFit_UVSMain@FM*aLH$M,myFit_UVSMain@SPR,myFit_UVSMain@SL50)
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

write.xlsx(Summary2,paste0(root_dir,"/Outputs/LBSPR/LBSPR_Summary.xlsx"))
write.xlsx(Final,paste0(root_dir,"/Outputs/LBSPR/LBSPR_Results.xlsx"))

aPlot <- ggplot(data=Summary1)+
           geom_hline(aes(yintercept=0.3),col="red",size=1)+
           geom_hline(aes(yintercept=0.4),col="orange",size=1)+
           geom_point(aes(x=SPECIES,y=SPR,fill=DATASET),shape=21,size=5)+
           theme_bw()

ggsave(aPlot,file=paste0(root_dir,"/Outputs/LBSPR/Graphs/LBSPR_Results.png"),width=20,height=8,unit="cm")



















