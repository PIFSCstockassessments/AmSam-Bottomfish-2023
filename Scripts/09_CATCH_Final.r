require(tidyverse); require(this.path); require(data.table);  require(openxlsx)
options(scipen=999)		

root_dir <- this.path::here(..=1)

A <- readRDS(paste0(root_dir,"\\Outputs\\CATCH_BBS_A.rds")) # Boat-based catch
B <- readRDS(paste0(root_dir,"\\Outputs\\CATCH_SBS_A.rds")) # Shore-based catch

S <- read.xlsx(paste0(root_dir,"/Data/METADATA.xlsx"),sheet="BMUS")
S$SPECIES_PK <- paste0("S",S$SPECIES_PK)
S <- select(S,SPECIES_FK=SPECIES_PK,SPECIES,SCIENTIFIC_NAME)

# Load historic data from Excel document
Hist.Catch.Option <- "PropTableOnly"

# Option1: Use only proptable calculated between 1986-2005
if(Hist.Catch.Option=="PropTableOnly"){
PT <- readRDS(file.path(root_dir,"Outputs","BBS_Prop_Table.rds"))
PT <- PT[GROUP_FK==200&(PERIOD==1995|PERIOD==2005),list(Prop=mean(Prop)),by=list(SPECIES_FK,AREA_C)]
C  <- data.table( read.xlsx(file.path(root_dir,"Data","Landings_Historic_1967_1985.xlsx"),sheet="Total Bottomfishes 67_85")  )
setnames(C,1:3,c("YEAR","AREA_C","BOTTOMFISH_LBS"))
C <- C[1:57,1:3]
C[AREA_C=="Banks"]$AREA_C <- "Tutuila"
C <- C[,list(BOTTOMFISH_LBS=sum(BOTTOMFISH_LBS)),by=list(YEAR,AREA_C)]

D     <- merge(C,PT,by="AREA_C",allow.cartesian = T)
D$LBS <- D$Prop*D$BOTTOMFISH_LBS
D$SPECIES_FK <- paste0("S",D$SPECIES_FK)
D     <- merge(D,S,by="SPECIES_FK")

ggplot(D,aes(x=YEAR,y=BOTTOMFISH_LBS,fill=AREA_C))+geom_bar(stat="identity",position="stack")+facet_wrap(~SPECIES)
D$SOURCE     <- "Historic"
D$SD.LBS     <- 0
D            <- select(D,SOURCE,SPECIES_FK,YEAR,AREA_C,LBS,SD.LBS)
D$SPECIES_FK <- paste0("S",D$SPECIES_FK)
}

# Option 2: use a mix of proportions, including from the old reports
if(Hist.Catch.Option=="Original"){
D <- data.table()
Species.list <- c("APRU","APVI","CALU","ETCA","ETCO","LERU","LUKA","PRFI","PRFL","PRZO","VALO")
for(i in 1:length(Species.list)){
 
   aSp <- Species.list[i]
   C <- data.table(   read.xlsx(paste0(root_dir,"/Data/Landings_Historic_1967_1985.xlsx"),sheet=aSp)  ); C <- select(C,1:4)
   C$SPECIES <- aSp
   D <- rbind(C,D)   
}

D$SOURCE     <- "Historic"
D$SD.LBS     <- 0
D            <- merge(D,S,by="SPECIES")
D            <- select(D,SOURCE,SPECIES_FK,YEAR=Year,AREA_C=Area,LBS=lbs,SD.LBS)
}

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
saveRDS(Z,paste0(root_dir,"/Outputs/CATCH_Final.rds"))



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



