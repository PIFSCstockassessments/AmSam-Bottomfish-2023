# This script loads size data from the BBS, biosampling, and diver datasets and organizes them in a single table   

require(data.table); require(openxlsx); require(tidyverse); require(openxlsx); require(gridExtra);require(grid); options(scipen=999)
root_dir <- this.path::here(.. = 2) # establish directories using this.path
dir.create(paste0(root_dir,"/Outputs/Summary/Size figures"),recursive=T,showWarnings=F)
dir.create(paste0(root_dir,"/Outputs/SS3_Inputs"),recursive=T,showWarnings=F)

# Options
Combine_BB_BIO <- T # Combine biosampling and creel survey lengths
Combine_Areas  <- T # Combine Tutuila, Manua, and the Banks
BIN.LIST       <- data.table(SPECIES=c("APRU","APVI","CALU","ETCA","ETCO","LERU","LUKA","PRFI","PRFL","PRZO","VALO"),
                             BINWIDTH=c(5,5,5,5,5,3,2,5,5,3,3)) # in cm

# Load metadata tables (Area, Method, Species)
A            <- data.table(  read.xlsx(paste0(root_dir,"/Data/METADATA.xlsx"),sheet="AREAS")   )
A            <- select(A,DATASET,AREA_ID,AREA_A,AREA_C,AREA_C)
M            <- data.table(  read.xlsx(paste0(root_dir,"/Data/METADATA.xlsx"),sheet="METHODS") )
M            <- select(M,DATASET,METHOD_ID,METHOD_C)
M$METHOD_ID  <- as.character(M$METHOD_ID)
S            <- data.table(  read.xlsx(paste0(root_dir, "/Data/METADATA.xlsx"),sheet="BMUS")   )
S            <- select(S,SPECIES_PK,SPECIES,SCIENTIFIC_NAME,FAMILY,LMAX,TL_TO_FL,LW_A,LW_B)
S$SPECIES_PK <- as.character(S$SPECIES_PK)
S$LMAX       <- S$LMAX/10

# ===============Boat-based creel survey sizes======================================================================      
#  STEP 1: read in 4 "flatview" datafiles, followed by some basic data handling
aint_bbs1 <- fread(paste0(root_dir, "/Data/a_bbs_int_flat1.csv"), header=T, stringsAsFactors=FALSE) 			
aint_bbs2 <- fread(paste0(root_dir, "/Data/a_bbs_int_flat2.csv"), header=T, stringsAsFactors=FALSE) 			
aint_bbs3 <- fread(paste0(root_dir, "/Data/a_bbs_int_flat3.csv"), header=T, stringsAsFactors=FALSE) 			
aint_bbs4 <- fread(paste0(root_dir, "/Data/a_bbs_int_flat4.csv"), header=T, stringsAsFactors=FALSE)
aint_bbs5 <- fread(paste0(root_dir, "/Data/PICDR-113220 BB Creel Data_all_columns.csv"), header=T, stringsAsFactors=FALSE)
aint_bbs5 <- aint_bbs5[,-62]       # drop var 62 ('COMMON_NAME') which is duplicated		
aint_bbs4 <- aint_bbs4[year(SAMPLE_DATE) < 2021] # aint_bbs4 had some 2021 record (duplicated with aint_bbs5)								
BB        <- rbind.data.frame(aint_bbs1, aint_bbs2, aint_bbs3, aint_bbs4, aint_bbs5) # rbind coerce variable formats in the dfs to match		

BB            <- BB[!is.na(LEN_MM)&!(is.na(SIZ_LBS)|SIZ_LBS=="NULL")]
BB$YEAR       <- year(BB$SAMPLE_DATE)
BB$LEN_MM     <- as.numeric(BB$LEN_MM)
BB$SIZ_LBS    <- as.numeric(BB$SIZ_LBS)
BB$NUM_KEPT   <- as.numeric(BB$NUM_KEPT)
BB$EST_LBS    <- as.numeric(BB$EST_LBS)
BB$AREA_FK    <- as.character((BB$AREA_FK))
BB$METHOD_FK  <- as.character((BB$METHOD_FK))

BB[LEN_MM==0]$LEN_MM   <- NA
BB[SIZ_LBS==0]$SIZ_LBS <- NA
BB[SIZ_LBS==as.numeric(EST_LBS)]$SIZ_LBS <- NA # remove weights where interviewers confused the SIZ_LBS field (individual weights) with EST_LBS (total pounds caught)

BB                     <- select(BB,INTERVIEW_PK,SIZE_PK,YEAR,SPECIES_FK,ISLAND_NAME,AREA_FK,METHOD_FK,NUM_KEPT,EST_LBS,LEN_MM,SIZ_LBS)

#Merge metadata tables
BB <- merge(BB,A[DATASET=="BBS"],by.x="AREA_FK",by.y="AREA_ID",all.x=T)
BB <- merge(BB,M[DATASET=="BBS"],by.x=c("METHOD_FK","DATASET"),by.y=c("METHOD_ID","DATASET"),all.x=T)
BB <- merge(BB,S,by.x="SPECIES_FK",by.y="SPECIES_PK")

# Simplify this dataset
BB <- select(BB,DATASET,INTERVIEW_PK,SIZE_PK,YEAR,SCIENTIFIC_NAME,SPECIES_FK,SPECIES,ISLAND_NAME,AREA_C,METHOD_C,LW_A,LW_B,LMAX,LBS_CAUGHT=EST_LBS,NUM_KEPT,LENGTH_FL=LEN_MM,SIZ_LBS)

# Fix known species ID issues
# Assign Pristipomoides rutilans (code 243) to P. flavipinnis (code 241) (A. rutilans shares the common name "Palu-sina" with P. flavipinnis)
BB[SPECIES_FK=="243"]$SPECIES_FK <- "241"
# Change P. filamentosus (242) to P. flavipinnis (241) between 2010-2014, they both can be called "palu sina" and there is a clear absence/presence pattern for these species in these years.
BB[YEAR>=2010&YEAR<=2014&SPECIES_FK=="242"]$SPECIES_FK <- "241"
# Pre-2015, all Variola sp. identified as VAAL or VALO (code 229) in different period. Need to delete all pre-2015 size data.
BB <- BB[!(SPECIES_FK=="229"&YEAR<2015)] 

# Assign AREA_B N/As to islands
BB[AREA_C=="Unk"]$AREA_C <- BB[AREA_C=="Unk"]$ISLAND_NAME
BB[is.na(AREA_C)]$AREA_C <- BB[is.na(AREA_C)]$ISLAND_NAME

# Select only bottomfishing methods
table(BB$METHOD_C,BB$SPECIES)
BB <- BB[METHOD_C=="Bottomfishing"]  # This filters a few spearfishing records for some species. Main impact is for VALO with 51 records removed.

# Check the distribution of the NUM_KEPT field use to calculate mean length from catch
BN <- BB[,list(NUM_KEPT=mean(NUM_KEPT,na.rm=T)),by=list(INTERVIEW_PK,YEAR)]
ggplot(data=BN)+geom_histogram(aes(x=NUM_KEPT))+facet_wrap(~YEAR,scales="free_y")+xlim(c(-1,20))
ggsave(plot=last_plot(),filename=paste0(root_dir,"/Outputs/Summary/Size figures/Dist_NumKept.png"),width=8,height=4,units="in")

# Calculate the number of SIZE_PK values per interview, to check against NUM_KEPT
BP <- BB[,list(ONES=1),by=list(INTERVIEW_PK,SIZE_PK)]
BP <- BP[,list(N_SIZEPK=sum(ONES)),by=list(INTERVIEW_PK)]
BB <- merge(BB,BP,by="INTERVIEW_PK")

# Convert weights to lengths and verify
BB$GRAMS  <- BB$SIZ_LBS*0.453592*1000
BB$LFW    <-(BB$GRAMS/ BB$LW_A)^(1/BB$LW_B) # Length-from-Weight
BB$LFL    <- BB$LENGTH_FL                   # Length-from-Length

BB$LFC    <- (BB$LBS_CAUGHT/BB$NUM_KEPT)  # Mean Weight-From-Catch
BB$LFC    <- BB$LFC*0.453592*1000         # Convert to grams
BB$LFC    <- (BB$LFC/BB$LW_A)^(1/BB$LW_B) # Mean Length-from-Catch
BB[N_SIZEPK!=NUM_KEPT]$LFC  <- NA         # Remove interviews where N of SIZE_PK is different from NUM_KEPT (likely unreliable size data)

# Add time period
TIMEPERIOD <- 10 #years
BB$TP      <- BB$YEAR - (BB$YEAR %% TIMEPERIOD) + TIMEPERIOD/2

BB <- select(BB,INTERVIEW_PK,YEAR,TP,SPECIES,LMAX,NUM_KEPT,LFW,LFL,LFC)
BC <- melt(BB,id.vars = 1:6,variable.name = "LSOURCE",value.name="LENGTH")
BD <- BC[,list(LENGTH=mean(LENGTH,na.rm=T),N=.N),by=list(SPECIES,LMAX,LSOURCE,TP,YEAR)]
BD <- BD[order(SPECIES,YEAR,LSOURCE)]
BE <- BC[NUM_KEPT>1,list(LENGTH=mean(LENGTH,na.rm=T),N=.N),by=list(SPECIES,LMAX,LSOURCE,TP,YEAR)]

ggplot(data=BB[!(is.na(LFL)|is.na(LFW))],aes(x=LFL,y=LFW))+geom_point(aes(col=SPECIES))+geom_abline(intercept=0, slope=1)+facet_wrap(~SPECIES,scales="free_y")+theme(legend.position="none")
ggsave(plot=last_plot(),filename=paste0(root_dir,"/Outputs/Summary/Size figures/LENGTHfromW vs Lengths.png"),width=8,height=6,units="in")

ggplot(data=BB)+geom_histogram(aes(x=LFW,fill=SPECIES))+facet_wrap(~SPECIES,scales="free")+theme(legend.position="none")
ggsave(plot=last_plot(),filename=paste0(root_dir,"/Outputs/Summary/Size figures/LENGTHfromW_histogram.png"),width=8,height=6,units="in")

ggplot(data=BD,aes(x=YEAR,y=LENGTH))+geom_line(aes(col=LSOURCE),size=1)+facet_wrap(~SPECIES,scales="free_y")+theme_bw()
ggsave(plot=last_plot(),filename=paste0(root_dir,"/Outputs/Summary/Size figures/LENGTHfrom3Methods_N0.png"),width=8,height=4,units="in")

ggplot(data=BD[N>=15],aes(x=YEAR,y=LENGTH))+geom_line(aes(col=LSOURCE),size=1)+facet_wrap(~SPECIES,scales="free_y")+theme_bw()
ggsave(plot=last_plot(),filename=paste0(root_dir,"/Outputs/Summary/Size figures/LENGTHfrom3Methods_N15.png"),width=8,height=4,units="in")

ggplot(data=BE[N>=15&LSOURCE!="LFW"],aes(x=YEAR,y=LENGTH))+geom_line(aes(col=LSOURCE),size=1)+facet_wrap(~SPECIES,scales="free_y")+theme_bw()
ggsave(plot=last_plot(),filename=paste0(root_dir,"/Outputs/Summary/Size figures/LENGTHfrom3Methods_N0.png"),width=8,height=4,units="in")


# Check ML by time period, to see if we can use superyears in SS

BF     <- BD[,list(LENGTH=mean(LENGTH,na.rm=T),N=sum(N)),by=list(SPECIES,LMAX,LSOURCE,TP)]
BG     <- BE[,list(LENGTH=mean(LENGTH,na.rm=T),N=sum(N)),by=list(SPECIES,LMAX,LSOURCE,TP)]

ggplot(data=BF[N>=15],aes(x=TP,y=LENGTH,col=LSOURCE))+geom_point(shape=95,size=5)+geom_line()+facet_wrap(~SPECIES,scales="free_y")+theme_bw()
ggsave(plot=last_plot(),filename=paste0(root_dir,"/Outputs/Summary/Size figures/LENGTHbyPERIOD.png"),width=8,height=4,units="in")

ggplot(data=BG[!(LSOURCE=="LFL"&TP==1995)&N>=10&LSOURCE!="LFW"],aes(x=TP,y=LENGTH,col=LSOURCE))+geom_point(shape=95,size=5)+geom_line()+facet_wrap(~SPECIES,scales="free_y")+theme_bw()
ggsave(plot=last_plot(),filename=paste0(root_dir,"/Outputs/Summary/Size figures/LENGTHbyPERIOD_NUM_KEPTnot1.png"),width=8,height=4,units="in")











