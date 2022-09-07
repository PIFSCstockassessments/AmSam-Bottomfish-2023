require(pacman); pacman::p_load(data.table,r4ss,this.path,tidyverse)
root_dir <- this.path::here(..=2)

Sp    <- "APRU"
Model <- "23_F3_Dirich_NewCatch" 

dir.create(file.path(root_dir,"Outputs","Report_Inputs",Sp),recursive=T,showWarnings=F)

# Catch table
C <- fread(file.path(root_dir,"Outputs","SS3_Inputs","CATCH_Final.csv"))
C <- C[SPECIES==Sp]

C$MT       <- round(C$MT,3)
C$LOGSD.MT <- round(C$LOGSD.MT,2)

Cb <- data.table(YEAR1=C[YEAR<=1980]$YEAR,MT1=C[YEAR<=1980]$MT,CV1=C[YEAR<=1980]$LOGSD.MT,
                 YEAR2=C[YEAR>1980&YEAR<=1994]$YEAR,MT2=C[YEAR>1980&YEAR<=1994]$MT,CV2=C[YEAR>1980&YEAR<=1994]$LOGSD.MT,
                 YEAR3=C[YEAR>1994&YEAR<=2008]$YEAR,MT3=C[YEAR>1994&YEAR<=2008]$MT,CV3=C[YEAR>1994&YEAR<=2008]$LOGSD.MT,
                 YEAR4=C[YEAR>2008]$YEAR,MT4=C[YEAR>2008]$MT,CV4=C[YEAR>2008]$LOGSD.MT)

Cb[14,10:12] <- NA

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

colnames(TA) <- c("YEAR","TBIO","SSB","CV","REC","CV","F","CV")

# Reference points
RP <- data.table(REF_POINT=c("Fmsy","F2021","F2021/Fmsy","SSBmsy","SSBmsst","SSB2021","SSB2021/SSBmsst",
                             "MSY","Catch2019-2021","SPRmsy","SPR2021"),VALUE=numeric())
RP[1]$VALUE <- SS[str_detect(SS$Label,"annF_MSY")][,2]
RP[2]$VALUE <- SS[str_detect(SS$Label,"F_2021")][,2]
RP[3]$VALUE <- RP[2]$VALUE/RP[1]$VALUE
RP[4]$VALUE <- SS[str_detect(SS$Label,"SSB_MSY")][,2]
RP[5]$VALUE <- NA#SS[str_detect(SS$Label,"annF_MSY")][,2]
RP[6]$VALUE <- SS[str_detect(SS$Label,"SSB_2021")][,2]
RP[7]$VALUE <- NA#SS[str_detect(SS$Label,"annF_MSY")][,2]
RP[8]$VALUE <- SS[str_detect(SS$Label,"Dead_Catch_MSY")][,2]
RP[9]$VALUE <- sum(C[YEAR>=2019&YEAR<=2021]$MT)/3
RP[10]$VALUE <- SS[str_detect(SS$Label,"SPR_MSY")][,2]
RP[11]$VALUE <- SS[str_detect(SS$Label,"SPRratio_2021")][,2]

RP$VALUE <- round(RP$VALUE,2)

# Sensitivity runs key values



# Projection tables for Catch





