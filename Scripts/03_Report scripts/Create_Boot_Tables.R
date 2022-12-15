#require(pacman); pacman::p_load(data.table,openxlsx,r4ss,this.path,tidyverse)
#root_dir <- this.path::here(..=2)

Create_Boot_Tables <- function(root_dir,model_dir){

  boot_dir <- file.path(model_dir,"bootstrap")
  
  SS.results <- r4ss::SS_output(model_dir,verbose = FALSE, printstats = FALSE)
  PAR        <- data.table( SS.results$parameters )

  # Get the base non-bootstrapped results for total biomass (and other results?)
  SS.results    <- r4ss::SS_output(model_dir,verbose = FALSE, printstats = FALSE)

  # Catch data to calculate catch 2019-2022
  C <- SS.results$catch %>% select(Yr,Obs,LOGSD.MT=se)
  
  TBIO          <- data.table(YEAR=SS.results$timeseries$Yr,ERA=SS.results$timeseries$Era,TOT_BIO=SS.results$timeseries$Bio_all)
  TBIO          <- select(TBIO[ERA=="TIME"],-ERA,)
  
  QT  <- data.table( SS.results$derived_quants )
  MSY <- QT[str_detect(QT$Label,"Dead_Catch_MSY")][,2:3]
  MSY <- data.table(MSY.50=MSY$Value,MSY.05=MSY$Value-MSY$StdDev*1.96,MSY.95=MSY$Value+MSY$StdDev*1.96)
  
  SPR.MSY <- QT[str_detect(QT$Label,"SPR.MSY")][,2:3]
  SPR.MSY <- data.table(SPR.MSY.50=SPR.MSY$Value,SPR.MSY.05=SPR.MSY$Value-SPR.MSY$StdDev*1.96,SPR.MSY.95=SPR.MSY$Value+SPR.MSY$StdDev*1.96)
  
  SPR2021 <- as.numeric(QT[str_detect(QT$Label,"SPRratio_2021")][,2:3])
  SPR2021 <- data.table(SPR2021.50=SPR2021[1],SPR2021.05=SPR2021[1]+SPR2021[2]*1.96,SPR2021.95=SPR2021[1]-SPR2021[2]*1.96)
  SPR2021 <- 1-SPR2021
  
  # Get the bootstrapped results
  SS <- readRDS(file.path(boot_dir,"mvln_draws.rds"))
  setnames(SS,c("year","stock","harvest","F","Recr"),c("YEAR","B_BMSY","F_FMSY","FMORT","REC"))
  colnames(SS) <- toupper(colnames(SS))
  SS <- SS[TYPE=="fit"]
  
  # Nat M
  
  NatM <- PAR[str_detect(PAR$Label,"NatM")]$Value
  
  SS <- SS %>% mutate(BMSST=SSB/B_BMSY*max(0.5,1-NatM),FMSY=FMORT/F_FMSY) %>% mutate(B_BMSST=SSB/BMSST)
         
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
  TA  <- TS %>% select(YEAR,TOT_BIO,SSB.50,SSB.CV,REC.50,REC.CV,FMORT.50,FMORT.CV)
  
  TA  <- TA %>% mutate(TOT_BIO=round(TOT_BIO,2),SSB.50=round(SSB.50,1),SSB.CV=round(SSB.CV,2),REC.50=round(REC.50,2),
                       REC.CV=round(REC.CV,2),FMORT.50=round(FMORT.50,3),FMORT.CV=round(FMORT.CV,2))
  
  TA  <- TA %>% mutate(TOT_BIO=format(TOT_BIO,nsmall=2),SSB.50=format(SSB.50,nsmall=1),SSB.CV=format(SSB.CV,nsmall=2),REC.50=format(REC.50,nsmall=2),
                       REC.CV=format(REC.CV,nsmall=2),FMORT.50=format(FMORT.50,nsmall=3),FMORT.CV=format(FMORT.CV,nsmall=2))
  
  TA <- TA %>% select(-TOT_BIO)
  
  TA1 <- TA %>% filter(YEAR>=1969&YEAR<=1995)
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
RP[6,2:4] <- TS %>% filter(YEAR==2021) %>% select(B_BMSST.50,B_BMSST.05,B_BMSST.95)
RP[7,2:4] <- MSY
RP[8,2]   <- C %>% filter(Yr>=2019&Yr<=2021) %>% summarize(Catch=sum(Obs)/3) 
RP[8,3]   <- C %>% filter(Yr>=2019&Yr<=2021) %>% summarize(L95=RP[8]$MEDIAN-sum(RP[8]$MEDIAN*LOGSD.MT)/3*1.96)
RP[8,4]   <- C %>% filter(Yr>=2019&Yr<=2021) %>% summarize(L95=RP[8]$MEDIAN+sum(RP[8]$MEDIAN*LOGSD.MT)/3*1.96)
RP[9,2:4] <- SPR.MSY
RP[10,2:4]<- SPR2021
  
  
# Round values
RP[4:10,2:4] <- round(RP[4:10,2:4],2)
RP[1:3,2:4]  <- round(RP[1:3,2:4],3)

RP$ALL <- paste0(RP$MEDIAN," ","(",RP$L95," - ",RP$U95,")")
RP     <- select(RP,REF_POINT,ALL)


# Sensitivity runs key values
SE <- data.table()

# Put all tables into a single list
Table.List <- list(TA.Final,RP,SE)

# Add tables to excel worksheet
File.Name <- file.path(boot_dir,"01_tables.xlsx")
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


