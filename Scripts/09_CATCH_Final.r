require(tidyverse); require(this.path); require(data.table);  require(openxlsx)
options(scipen=999)		

root_dir <- this.path::here(..=1)
#dir.create(file.path(root_dir, "Outputs", "Summary"))
A <- readRDS(paste0(root_dir,"/Outputs/CATCH_BBS_A.rds")) # Boat-based catch
B <- readRDS(paste0(root_dir,"/Outputs/CATCH_SBS_A.rds")) # Shore-based catch

S <- read.xlsx(paste0(root_dir,"/Data/METADATA.xlsx"),sheet="BMUS")
S$SPECIES_PK <- paste0("S",S$SPECIES_PK)
S <- select(S,SPECIES_FK=SPECIES_PK,SPECIES,SCIENTIFIC_NAME)

C <- data.table( read.xlsx(file.path(root_dir,"Data","Historical Catch.xlsx"),sheet="Total_Bottomfish")  )
C <- select(C,YEAR,BOTTOMFISH_LBS=CATCH_LBS)

# Load 1967-1979 species proportions
P1 <- data.table( read.xlsx(file.path(root_dir,"Data","Historical Catch.xlsx"),sheet="Species composition 1967_1979")  )
P1 <- P1[1:11,1:2]
P2 <- data.table( read.xlsx(file.path(root_dir,"Data","Historical Catch.xlsx"),sheet="Species composition 1980_1985")  )
P2 <- P2[1:11,]
P2 <- select(P2,SPECIES,PROP_1980_1985=PROP_WEIGHT_MEAN)

# Create empty data table
D1      <- data.table(YEAR=as.numeric(rep(seq(1967,1985), times=11)), SPECIES=unique(P1$SPECIES)) 
D1      <- D1[order(SPECIES,YEAR)]
D1      <- merge(D1,P1,by="SPECIES",allow.cartesian = T)
D1      <- merge(D1,P2,by="SPECIES",allow.cartesian = T)
D1$PROP <- 0
D1[YEAR<=1979]$PROP <- D1[YEAR<=1979]$PROP_1967_1979 
D1[YEAR>1979]$PROP  <- D1[YEAR>1979]$PROP_1980_1985 
D1 <- select(D1,YEAR,SPECIES,PROP)
D1$AREA_C <- "Combined"

D     <- merge(D1,C,by="YEAR",allow.cartesian=T)
D$LBS <- D$PROP*D$BOTTOMFISH_LBS
D     <- merge(D,S,by="SPECIES")

#ggplot(D,aes(x=YEAR,y=LBS))+geom_bar(stat="identity",position="stack")+facet_wrap(~SPECIES)

D$SOURCE     <- "Historic"
D$SD.LBS     <- 0
D            <- select(D,SOURCE,SPECIES_FK,AREA_C,YEAR,LBS,SD.LBS)

# Sum BBS and SBS catch accross areas
#A <- A[,list(LBS=round(sum(LBS),0),SD.LBS=round(sum(SD.LBS),1)),by=list(SOURCE,SPECIES_FK,YEAR)]
#B <- B[,list(LBS=round(sum(LBS),0),SD.LBS=round(sum(SD.LBS),1)),by=list(SOURCE,SPECIES_FK,YEAR)]

# Put all catches together
E <- rbind(A,B,D)
E <- merge(E,S,by="SPECIES_FK")

C1 <- ggplot(data=E,aes(x=YEAR,y=LBS,fill=AREA_C))+geom_bar(stat="identity",position="stack")+facet_wrap(~SPECIES,scales="free_y")
ggsave(plot=C1,filename=paste0(root_dir,"/Outputs/Summary/CATCH_Final.png"),width=8,height=4,units="in")

# Save final catch file
Z          <- E[,list(LBS=round(sum(LBS),0),SD.LBS=round(sum(SD.LBS),1)),by=list(SPECIES,YEAR)]
Z          <- Z[order(SPECIES,YEAR)]
Z$MT       <- round(Z$LBS*0.453592/1000,5)
Z$SD.MT    <- round(Z$SD.LBS*0.453592/1000,3)
Z$LOGSD.MT <- sqrt( log((Z$SD.MT/Z$MT)^2+1)   )
Z[is.na(LOGSD.MT)]$LOGSD.MT <- 0  

Z <- select(Z,SPECIES,YEAR,MT,LOGSD.MT)  

# Add catch data from 2 life history program cruise (2012 and 2016)
LHC <- read.xlsx(file.path(root_dir,"Data","AmSam_LHP_cruise_summary.xlsx"),sheet="summary")
LHC <- select(LHC,YEAR,SPECIES,LHP_CATCH_MT)

Z   <- merge(Z,LHC,by=c("YEAR","SPECIES"),all.x=T)

Z[!is.na(LHP_CATCH_MT)]$MT     <- Z[!is.na(LHP_CATCH_MT)]$MT+Z[!is.na(LHP_CATCH_MT)]$LHP_CATCH_MT

Z <- select(Z,-LHP_CATCH_MT)

# For PRZO and PRFL, 2021 had "0" catch since the species were not intercepted.
# For these, CPUE per domain from 2020 were used and combined with expanded effort per domain in 2021 to obtain the 2021 catch values + SD

CORR.ZEROES          <- data.table(YEAR=2021,SPECIES=c("PRFL","PRZO"),MT=c(25.1*0.453592/1000,14.06*0.453592/1000),SD.MT=c(sqrt(108.9)*0.453592/1000,sqrt(45.2)*0.453592/1000))
CORR.ZEROES$LOGSD.MT <- sqrt( log((CORR.ZEROES$SD.MT/CORR.ZEROES$MT)^2+1)   )

Z           <- rbind(Z,CORR.ZEROES)


# Variance min/max adjustments
Z[YEAR<=1985]$LOGSD.MT              <- 0.5 # Add some uncertainty to historic catch
#Z[YEAR>=1986&LOGSD.MT>0.5]$LOGSD.MT <- 0.5 # Reduce max CV to 0.5
#Z[YEAR>=1986&LOGSD.MT<0.2]$LOGSD.MT <- 0.2 # Increase min CV to 0.2

if(!exists(paste0(root_dir,"/Outputs/SS3_Inputs"))){
  dir.create(paste0(root_dir,"/Outputs/SS3_Inputs"),recursive=T,showWarnings=F)
}

write.csv(Z,paste0(root_dir,"/Outputs/SS3_Inputs/CATCH_Final.csv"),row.names=F)




# Compare this catch to Erin's original scripts
# F <- E[YEAR>=1986,list(LBS=sum(LBS)),by=list(SPECIES,YEAR)]
# F <- F[order(SPECIES,YEAR)]

# ER <- readRDS(paste0(root_dir,"/Outputs/ErinCatch.rds"))
# ER <- merge(ER,S,by="SCIENTIFIC_NAME")
# ER <- select(ER,SPECIES,YEAR,LBS)
# ER$SOURCE<- "Erin"
# F$SOURCE <- "Marc"
#
# G <- data.table( rbind(ER,F) )
#
# TOT <- G[,list(LBS=round(sum(LBS),0)),by=list(YEAR,SOURCE)]
# TOT <- dcast(TOT,YEAR~SOURCE,value.var="LBS")
#
#
# ggplot(data=G,aes(x=YEAR,y=LBS,col=SOURCE))+geom_line()+facet_wrap(~SPECIES,scales="free_y")
# ggplot(data=TOT,aes(x=YEAR))+geom_line(aes(y=Marc),col="blue")+geom_line(aes(y=Erin),col="red")+geom_text(aes(y=Marc,label=Marc), position=position_dodge(width=0.9), vjust=-0.25)
# ggplot(data=TOT,aes(x=YEAR,y=Marc))+geom_bar(stat="identity",col="black")+ylab("LBS")+geom_text(aes(label=Marc), position=position_dodge(width=0.9), vjust=-0.25)



