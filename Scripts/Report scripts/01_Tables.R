require(pacman); pacman::p_load(data.table,openxlsx,r4ss,this.path,tidyverse)
root_dir <- this.path::here(..=2)


Model <- "23_F3_Dirich_NewCatch" 

Raw.C  <- fread(file.path(root_dir,"Outputs","SS3_Inputs","CATCH_Final.csv"))
dir.create(file.path(root_dir,"Outputs","Report_Inputs"),recursive=T,showWarnings=F)

Species.List <- c("APRU","APVI","CALU","ETCO","LERU","LUKA","PRFL","PRZO","VALO")
for(s in 1:9){
  
  Sp <- Species.List[s]

# Catch table
C <- Raw.C[SPECIES==Sp]
C <- select(C,-SPECIES)

C$MT       <- round(C$MT,3)
C$LOGSD.MT <- round(C$LOGSD.MT,2)

Ca <- C[YEAR<=1980]
Cb <- C[YEAR>1980&YEAR<=1994]
Cc <- C[YEAR>1994&YEAR<=2008]
Cd <- C[YEAR>2008]

C.Final <- cbind(Ca,Cb,Cc,Cd) 
C.Final[14,10:12] <- NA

# CPUE table
CP <- fread(file.path(root_dir,"Outputs","SS3_Inputs","CPUE", paste0("CPUE_",Sp,"_Tutuila.csv")))

CP$CPUE_TOT       <- round(CP$CPUE_TOT,3)
CP$LOGSD.CPUE_TOT <- round(CP$LOGSD.CPUE_TOT,2)

# Tot. biomass, SSB, Recruits, and F
SS.results  <- r4ss::SS_output(file.path(root_dir,"SS3 models",Sp, Model),verbose = FALSE, printstats = FALSE)
SS          <- data.table( SS.results$derived_quants )
SS$CV       <- round(SS$StdDev/SS$Value,2)
SS$Value    <- round(SS$Value,3)
SS          <- select(SS,Label,Value,CV)

SSB   <- SS[str_detect(SS$Label,"SSB")][3:57,2:3]
REC   <- SS[str_detect(SS$Label,"Recr")][3:57,2:3]
FMORT <- SS[str_detect(SS$Label,"F_")][1:55,2:3]

TBIO  <- data.table(TOT_BIO=SS.results$timeseries$Bio_all)[3:57]

TA <- cbind(YEAR=seq(1967,2021),TBIO,SSB,REC,FMORT)

colnames(TA) <- c("YEAR","TBIO","SSB","SSB_CV","REC","REC_CV","F","F_CV")

# Split table in two (make it longer and shorter)
TA1 <- TA[YEAR<=1994]
TA2 <- TA[YEAR>1994]
  
TA.Final <- cbind(TA1,TA2)
TA.Final[28,9:16] <- NA


# Reference points
RP <- data.table(REF_POINT=c("Fmsy","F2021","F2021/Fmsy","SSBmsy","SSBmsst","SSB2021","SSB2021/SSBmsst",
                             "MSY","Catch2019-2021","SPRmsy","SPR2021"),VALUE=numeric())
RP[1]$VALUE  <- SS[str_detect(SS$Label,"annF_MSY")][,2]
RP[2]$VALUE  <- SS[str_detect(SS$Label,"F_2021")][,2]
RP[3]$VALUE  <- RP[2]$VALUE/RP[1]$VALUE
RP[4]$VALUE  <- SS[str_detect(SS$Label,"SSB_MSY")][,2]
RP[5]$VALUE  <- 0.9*RP[4]$VALUE
RP[6]$VALUE  <- SS[str_detect(SS$Label,"SSB_2021")][,2]
RP[7]$VALUE  <- RP[6]$VALUE/RP[5]$VALUE
RP[8]$VALUE  <- SS[str_detect(SS$Label,"Dead_Catch_MSY")][,2]
RP[9]$VALUE  <- sum(C[YEAR>=2019&YEAR<=2021]$MT)/3
RP[10]$VALUE <- SS[str_detect(SS$Label,"SPR_MSY")][,2]
RP[11]$VALUE <- 1-as.numeric(SS[str_detect(SS$Label,"SPRratio_2021")][,2])

RP$VALUE <- round(RP$VALUE,2)


# Sensitivity runs key values
SE <- data.table()

# Projection tables for Catch
PR <- data.table()

# Put all tables into a single list
Table.List <- list(C.Final,CP,TA.Final,RP,SE,PR)

# Add tables to excel worksheet
File.Name <- file.path(root_dir,"Outputs","Report_Inputs",paste0(Sp,"_tables.xlsx"))
wb        <- tryCatch({loadWorkbook(File.Name)}, error=function(e){createWorkbook(File.Name)})
Sheets    <- c("01_Catch", "02_CPUE","03_Quants","04_RefPoints","05_Sensitivies","06_Projections")

for(i in 1:6){
  if(Sheets[i] %in% sheets(wb)) removeWorksheet(wb,Sheets[i]) # Remove sheets if there already
  addWorksheet(wb, sheetName = Sheets[i])
  writeData(wb, sheet = Sheets[i], Table.List[[i]],colNames=T)
  setColWidths(wb,widths="auto",sheet=Sheets[i],cols=1:15)
}

saveWorkbook(wb,File.Name,overwrite = T)

}
warnings()
