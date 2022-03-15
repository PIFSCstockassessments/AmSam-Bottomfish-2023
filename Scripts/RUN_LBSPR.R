#devtools::install_github("AdrianHordyk/LBSPR")

require(LBSPR); require(data.table); require(openxlsx); require(grid); require(gridExtra)
rm(list=ls())

Species.List  <- c("APRU","APVI","CALU","ETCO","LERU","LUKA","PRFL","PRZO","VALO")
BinWidth.List <- c(5,5,5,5,3,2,5,5,5)
SPR           <- 0.3 # Target SPR

for(i in 1:length(Species.List)){

Sp       <- Species.List[i]
Name     <- Sp
BinWidth <- BinWidth.List[i]
Growth <- NULL;  Mat    <- NULL
# Growth: Linf,K,CVLinf,M
# Mat:    L50,L95
if(Sp=="APRU"){
  #Growth <- c(122.9,0.163,0.1,0.20)       # Ralston 1988, M from Fry 2006 (amax=16)
  Growth <- c((82.7*1.278),0.16,0.1,0.20)  # Fry 2006, M from Fry 2006 (amax=16)
  Mat    <- c(46.9,51.9)                   # StepwiseLH Lmat + 5 cm for L95
}
if(Sp=="APVI"){
  Growth <- c(72.0,0.33,0.1,0.101) # O'Malley 2021, M from Hawaii assessment
  Mat    <- c(44.8,45.5)
}
if(Sp=="CALU"){
  Growth <- c(82.2,0.12,0.1,0.27) # Menezes 1968 (Brazil), M from Fry 20016 (amax=12)
  Mat    <- c(38,43)              # Garcia-Cagide 1994 (Cuba)
}
if(Sp=="ETCO"){
  Growth <- c(82.1,0.133,0.1,0.06) # Uehara 2020 (Japan), M from Amax=55
  Mat    <- c(54.7,59.7)           # Reed 2021 (Hawaii)
}
if(Sp=="LERU"){
  Growth <- c(31.5,0.80,0.1,0.40) # Trianni 2011 (Mariana), M from Amax=8 (note: 15 yr in Japan)
  Mat    <- c(22.6,25.5)          # Trianni 2011 (Mariana), average of two locations
}
if(Sp=="LUKA"){
  Growth <- c(33.0,0.29,0.1,0.40) # Morales-Nin 1990 (Hawaii), M from Amax=8
  Mat    <- c(21.3,24.3)          # StepwiseLH from Lmax = 33.2 (Divers) + 3 cm for L95
}
if(Sp=="PRFL"){
  Growth <- c(41.2,0.47,0.1,0.111) # O'Malley 2019 (Mariana), M from Amax=28
  Mat    <- c(27.0,32.0)           # Brouard 1985 (Vanuatu)
}
if(Sp=="PRZO"){
  Growth <- c(36.9,0.29,0.1,0.11) # Schemmel 2022 (Guam), M from Amax=30
  Mat    <- c(23.6,26.6)          # Schemmel 2022 (Guam)
}
if(Sp=="VALO"){
  Growth <- c(43.5,0.26,0.1,0.23) # Schemmel 2022, M from Amax=14
  Mat    <- c(25.8,28.8)          # Schemmel 2022
}

MyPars          <- new("LB_pars")
MyPars@Species  <- Sp
MyPars@Linf     <- Growth[1]
MyPars@CVLinf   <- Growth[3]
MyPars@MK       <- Growth[4]/Growth[2]
MyPars@L50      <- Mat[1] 
MyPars@L95      <- Mat[2]
MyPars@SPR      <- SPR 
MyPars@BinWidth <- BinWidth
MyPars@L_units  <- "cm"

# Reshape size structure data to go into LBSPR
DAT        <- data.table(  read.csv(paste0("Outputs/SS3_Inputs/",Sp,"/SIZE_",Sp,".csv"))   )
DAT        <- DAT[,!"EFFN"]
colnames(DAT) <- gsub("X","",colnames(DAT))
setnames(DAT,"YEAR","year")

# Add a few larger size bins to help LBSPR run
LASTBIN <- as.numeric( colnames(DAT)[length(DAT)] )
DAT     <- cbind(DAT,0,0)
setnames(DAT,c("V2","V3"),as.character(c(LASTBIN+BinWidth,LASTBIN+2*BinWidth)))
DAT[,5:length(DAT)] <- rapply(DAT[,5:length(DAT)],as.integer,how="replace") 

# Continue
DAT        <- melt(DAT, id.vars=1:3,variable.name="length",value.name="COUNT")
DAT        <- dcast(DAT,DATASET+AREA_B+length~year,value.var="COUNT",fill=0)
DAT$length <- as.numeric(as.character(DAT$length))
DAT$length <- DAT$length+(BinWidth/2) #Convert lengths to mid-points

# Split datasets and regions
BBS_Main <- DAT[DATASET=="BBS"&AREA_B=="Main",!c("DATASET","AREA_B")]
BS_Main  <- DAT[DATASET=="Biosampling"&AREA_B=="Main",!c("DATASET","AREA_B")]
US_Atoll <- DAT[DATASET=="UVS"&AREA_B=="Atoll",!c("DATASET","AREA_B")]
US_NWHI  <- DAT[DATASET=="UVS"&AREA_B=="NWHI",!c("DATASET","AREA_B")]
US_Main  <- DAT[DATASET=="UVS"&AREA_B=="Main",!c("DATASET","AREA_B")]

# Remove empty years
BBS_Main <- BBS_Main[,c(which(colSums(BBS_Main) != 0)),with=F]
BS_Main  <- BS_Main[,c(which(colSums(BS_Main) != 0)),with=F]
US_Atoll <- US_Atoll[,c(which(colSums(US_Atoll) != 0)),with=F]
US_NWHI  <- US_NWHI[,c(which(colSums(US_NWHI) != 0)),with=F]
US_Main  <- US_Main[,c(which(colSums(US_Main) != 0)),with=F]

# Save to csv files (easier integration with LBSPR)
Drive <- paste0("Outputs/LBSPR/Temp size/",Sp)
write.csv(BBS_Main,paste0(Drive,"_BBS_Main.csv"),row.names=F)
write.csv(BS_Main,paste0(Drive,"_BS_Main.csv"),row.names=F)
write.csv(US_Atoll,paste0(Drive,"_UVS_Atoll.csv"),row.names=F)
write.csv(US_NWHI,paste0(Drive,"_UVS_NWHI.csv"),row.names=F)
write.csv(US_Main,paste0(Drive,"_UVS_Main.csv"),row.names=F)

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
OUT <-rbind( cbind("BBS_Main", myFit_BBMain@Years,myFit_BBMain@FM*Growth[4],myFit_BBMain@SPR,myFit_BBMain@SL50),
             cbind("BS_Main",  myFit_BSMain@Years,myFit_BSMain@FM*Growth[4],myFit_BSMain@SPR,myFit_BSMain@SL50),
             cbind("UVS_Main", myFit_UVSMain@Years,myFit_UVSMain@FM*Growth[4],myFit_UVSMain@SPR,myFit_UVSMain@SL50),
             cbind("UVS_Atoll",myFit_UVSNWHI@Years,myFit_UVSNWHI@FM*Growth[4],myFit_UVSNWHI@SPR,myFit_UVSAtoll@SL50),
             cbind("UVS_NWHI", myFit_UVSAtoll@Years,myFit_UVSAtoll@FM*Growth[4],myFit_UVSAtoll@SPR,myFit_UVSNWHI@SL50)
           )
} else {
OUT <-rbind( cbind("BBS_Main", myFit_BBMain@Years,myFit_BBMain@FM*Growth[4],myFit_BBMain@SPR,myFit_BBMain@SL50),
             cbind("BS_Main",  myFit_BSMain@Years,myFit_BSMain@FM*Growth[4],myFit_BSMain@SPR,myFit_BSMain@SL50))
}

OUT <- data.table(OUT)
setnames(OUT,c("DATASET","YEAR","F","SPR","SL50"))
OUT[,2:5] <- rapply(OUT[,2:5],as.numeric,how="replace")
OUT[,3:4] <- round(OUT[,3:4],2)
OUT[,5]   <- round(OUT[,5],0)

write.xlsx(OUT,paste0("Outputs/LBSPR/Graphs/LBSPR_",Sp,".xlsx"))


Drive <- paste0("Outputs/LBSPR/Graphs/",Sp)
png(file=paste0(Drive,"_BB_Results.png"),
    width=600, height=350)
plotEsts(myFit_BBMain)
dev.off()

Drive <- paste0("Outputs/LBSPR/Graphs/",Sp)
png(file=paste0(Drive,"_BB_Fit.png"),
    width=600, height=350)
plotSize(myFit_BBMain)
dev.off()

Drive <- paste0("Outputs/LBSPR/Graphs/",Sp)
png(file=paste0(Drive,"_BS_Results.png"),
    width=600, height=350)
plotEsts(myFit_BSMain)
dev.off()

Drive <- paste0("Outputs/LBSPR/Graphs/",Sp)
png(file=paste0(Drive,"_BS_Fit.png"),
    width=600, height=350)
plotSize(myFit_BSMain)
dev.off()


} # End of for-loop



