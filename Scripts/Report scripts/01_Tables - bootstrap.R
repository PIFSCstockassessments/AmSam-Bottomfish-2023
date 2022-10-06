require(pacman); pacman::p_load(data.table,openxlsx,r4ss,this.path,tidyverse)
root_dir <- this.path::here(..=2)


Model <- "34_TestBootstrap" # Select the model to be summarize

Raw.C  <- fread(file.path(root_dir,"Outputs","SS3_Inputs","CATCH_Final.csv"))
dir.create(file.path(root_dir,"Outputs","Report_Inputs"),recursive=T,showWarnings=F)

Species.List <- c("APRU","APVI","CALU","ETCO","LERU","LUKA","PRFL","PRZO","VALO")
for(s in 1:9){
  
  Sp <- Species.List[s]

  # Catch data to calculate catch 2019-2022
  C <- Raw.C[SPECIES==Sp]  
  
  # Get the base non-bootstrapped results for total biomass (and other results?)
  SS.results    <- r4ss::SS_output(file.path(root_dir,"SS3 models",Sp, Model),verbose = FALSE, printstats = FALSE)
  TBIO          <- data.table(YEAR=SS.results$timeseries$Yr,ERA=SS.results$timeseries$Era,TOT_BIO=SS.results$timeseries$Bio_all)
  TBIO          <- select(TBIO[ERA=="TIME"],-ERA,)
  
  QT  <- data.table( SS.results$derived_quants )
  MSY <- QT[str_detect(QT$Label,"Dead_Catch_MSY")][,2:3]
  MSY <- data.table(MSY.50=MSY$Value,MSY.05=MSY$Value-MSY$StdDev*1.96,MSY.95=MSY$Value+MSY$StdDev*1.96)
  
  SPR.MSY <- QT[str_detect(QT$Label,"SPR.MSY")][,2:3]
  SPR.MSY <- data.table(SPR.MSY.50=SPR.MSY$Value,SPR.MSY.05=SPR.MSY$Value-SPR.MSY$StdDev*1.96,SPR.MSY.95=SPR.MSY$Value+SPR.MSY$StdDev*1.96)
  
  SPR2021 <- as.numeric(QT[str_detect(QT$Label,"SPRratio_2021")][,2:3])
  SPR2021 <- data.table(SPR2021.50=SPR2021[1],SPR2021.05=SPR2021[1]-SPR2021[2]*1.96,SPR2021.95=SPR2021[1]+SPR2021[2]*1.96)
  SPR2021 <- 1-SPR2021
  
  # Get the bootstrapped results
  SS <- readRDS(file.path(root_dir,"SS3 models",Sp, Model,"bootstrap","mvln_draws.rds"))
  setnames(SS,c("year","stock","harvest","F","Recr"),c("YEAR","B_BMSY","F_FMSY","FMORT","REC"))
  colnames(SS) <- toupper(colnames(SS))
  SS <- SS[TYPE=="fit"]
  SS <- SS %>% mutate(BMSST=SSB/B_BMSY*0.9,FMSY=FMORT/F_FMSY) %>% mutate(B_BMSST=SSB/BMSST)
         
  # Calculate some quantities and the CVs
  
  TS <- SS %>% group_by(YEAR) %>%  summarize(SSB.50=median(SSB),SSB.05=quantile(SSB,0.05),SSB.95=quantile(SSB,0.95),SSB.CV=sd(SSB)/mean(SSB),
                                            B_BMSST.50=median(B_BMSST),B_BMSST.05=quantile(B_BMSST,0.05),B_BMSST.95=quantile(B_BMSST,0.95),B_BMSST.CV=sd(B_BMSST)/mean(B_BMSST),
                                            FMORT.50=median(FMORT),FMORT.05=quantile(FMORT,0.05),FMORT.95=quantile(FMORT,0.95),FMORT.CV=sd(FMORT)/mean(FMORT),
                                            F_FMSY.50=median(F_FMSY),F_FMSY.05=quantile(F_FMSY,0.05),F_FMSY.95=quantile(F_FMSY,0.95),F_FMSY.CV=sd(F_FMSY)/mean(F_FMSY),
                                            REC.50=median(REC),REC.05=quantile(REC,0.05),REC.95=quantile(REC,0.95),REC.CV=sd(REC)/mean(REC),
                                            CATCH=median(CATCH))
  
  # Add total bio to previous table
  TS <- merge(TS,TBIO,by="YEAR")
  
  # Split table in two (make it longer and shorter)
  TA  <- TS %>% select(YEAR,SSB.50,SSB.CV,REC.50,REC.CV,FMORT.50,FMORT.CV)
  TA  <- TA %>% mutate(SSB.50=round(SSB.50,1),SSB.CV=round(SSB.CV,2),REC.50=round(REC.50,2),
                       REC.CV=round(REC.CV,2),FMORT.50=round(FMORT.50,3),FMORT.CV=round(FMORT.CV,2))
  
  TA1 <- TA %>% filter(YEAR<=1995)
  TA2 <- TA %>% filter(YEAR>1995) %>% rbind(NA)
  TA.Final <- cbind(TA1,TA2)
  
  
# Reference points
RP <- data.table(REF_POINT=c("Fmsy","F2021","F2021/Fmsy","SSBmsst","SSB2021","SSB2021/SSBmsst",
                             "MSY","Catch2019-2021","SPRmsy","SPR2021"),MEDIAN=0,L95=0,U95=0)

RP[1,2:4] <- SS %>% summarize(FMSY.50=median(FMSY),FMSY.05=quantile(FMSY,0.05),FMSY.95=quantile(FMSY,0.95))
RP[2,2:4] <- TS %>% filter(YEAR==2021) %>% select(FMORT.50,FMORT.05,FMORT.95)
RP[3,2:4] <- data.frame( RP[2]$MEDIAN/RP[1]$MEDIAN,RP[2]$L95/RP[1]$L95,RP[2]$U95/RP[1]$U95 )
RP[4,2:4] <- SS %>% summarize(BMSST.50=median(BMSST),BMSST.05=quantile(BMSST,0.05),BMSST.95=quantile(BMSST,0.95))
RP[5,2:4] <- TS %>% filter(YEAR==2021) %>% select(SSB.50,SSB.05,SSB.95)
RP[6,2:4] <- data.frame( RP[5]$MEDIAN/RP[4]$MEDIAN,RP[5]$L95/RP[4]$L95,RP[5]$U95/RP[4]$U95 )
RP[7,2:4] <- MSY
RP[8,2]   <- SS %>% filter(YEAR>=2019) %>% summarize(CATCH=mean(CATCH))
RP[8,2]   <- sum(C[YEAR>=2019&YEAR<=2021]$MT)/3
RP[8,3]   <- RP[8]$MEDIAN-sum(RP[8]$MEDIAN*C[YEAR>=2019&YEAR<=2021]$LOGSD.MT)/3*1.96
RP[8,4]   <- RP[8]$MEDIAN+sum(RP[8]$MEDIAN*C[YEAR>=2019&YEAR<=2021]$LOGSD.MT)/3*1.96
RP[9,2:4] <- SPR.MSY
RP[10,2:4]<- SPR2021
  
  
# Round values
RP[1:3,2:4]  <- round(RP[1:3,2:4],3)
RP[4:10,2:4] <- round(RP[4:10,2:4],3)

# Sensitivity runs key values
SE <- data.table()

# Put all tables into a single list
Table.List <- list(TA.Final,RP,SE)

# Add tables to excel worksheet
File.Name <- file.path(root_dir,"Outputs","Report_Inputs",paste0(Sp,"_tables.xlsx"))
wb        <- tryCatch({loadWorkbook(File.Name)}, error=function(e){createWorkbook(File.Name)})
Sheets    <- c("01_Quants","02_RefPoints","03_Sensitivies")

for(i in 1:3){
  if(Sheets[i] %in% sheets(wb)) removeWorksheet(wb,Sheets[i]) # Remove sheets if there already
  addWorksheet(wb, sheetName = Sheets[i])
  writeData(wb, sheet = Sheets[i], Table.List[[i]],colNames=T)
  setColWidths(wb,widths="auto",sheet=Sheets[i],cols=1:15)
}

saveWorkbook(wb,File.Name,overwrite = T)

}


# Tables for all species to be inserted in the general section of the report

C.List  <- list()
CP.List <- list() 
for(s in 1:9){

Sp <- Species.List[s]
  
C <- Raw.C[SPECIES==Sp]  
C <- select(C,-SPECIES)
  
# Catch table

C$MT       <- round(C$MT,3)
C$LOGSD.MT <- round(C$LOGSD.MT,2)

Ca <- C[YEAR<=1980]
Cb <- C[YEAR>1980&YEAR<=1994]
Cc <- C[YEAR>1994&YEAR<=2008]
Cd <- C[YEAR>2008]

C.all <- cbind(Ca,Cb,Cc,Cd) 
C.all[14,10:12] <- NA
C.all$SP <- Sp
C.all <- C.all[,c(13,1:12)]

C.List[[Sp]] <- C.all

# CPUE table
CP <- fread(file.path(root_dir,"Outputs","SS3_Inputs","CPUE", paste0("CPUE_",Sp,"_Tutuila.csv")))

CP$SPECIES <- Sp
CP$CPUE_TOT       <- round(CP$CPUE_TOT,3)
CP$LOGSD.CPUE_TOT <- round(CP$LOGSD.CPUE_TOT,2)

CP <- CP[,c(4,1:3)]

CP.List[[Sp]] <- CP

}

C.Final  <- rbindlist(C.List)
CP.Final <- rbindlist(CP.List)

colnames(C.Final) <- c("Sp","Yr","MT","CV","Yr","MT","CV","Yr","MT","CV","Yr","MT","CV")

# Add tables to excel worksheet
File.Name <- file.path(root_dir,"Outputs","Report_Inputs","Catch_CPUE_tables.xlsx")
wb        <- tryCatch({loadWorkbook(File.Name)}, error=function(e){createWorkbook(File.Name)})
Sheets    <- c("Catch","CPUE")

for(i in 1:2){
  if(Sheets[i] %in% sheets(wb)) removeWorksheet(wb,Sheets[i]) # Remove sheets if there already
  addWorksheet(wb, sheetName = Sheets[i])
}

  writeData(wb, sheet = Sheets[1], C.Final,colNames=T)
  setColWidths(wb,widths="auto",sheet=Sheets[i],cols=1:15)

  writeData(wb, sheet = Sheets[2], CP.Final,colNames=T)
  setColWidths(wb,widths="auto",sheet=Sheets[i],cols=1:15)

saveWorkbook(wb,File.Name,overwrite = T)





