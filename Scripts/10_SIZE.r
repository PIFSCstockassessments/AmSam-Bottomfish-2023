# This script loads size data from the BBS, biosampling, and diver datasets and organizes them in a single table   

require(data.table); require(openxlsx); require(tidyverse); require(openxlsx); require(gridExtra);require(grid); options(scipen=999)
root_dir <- this.path::here(.. = 1) # establish directories using this.path
dir.create(paste0(root_dir,"/Outputs/Summary/Size figures"),recursive=T,showWarnings=F)
dir.create(paste0(root_dir,"/Outputs/SS3_Inputs"),recursive=T,showWarnings=F)

# Options
Combine_BB_BIO <- T # Combine biosampling and creel survey lengths
Combine_Areas  <- T # Combine Tutuila, Manua, and the Banks
MinN           <- 40 # Minimum sample size to do size frequency
AW             <- data.table(AREA_C=c("Manua","Tutuila","Atoll"),WEIGHT=c(0.16,0.84,0)) # Area weight for effective sample size calculations
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
 BB <- select(BB,DATASET,INTERVIEW_PK,SIZE_PK,YEAR,SCIENTIFIC_NAME,SPECIES_FK,SPECIES,ISLAND_NAME,AREA_C,METHOD_C,LW_A,LW_B,LBS_CAUGHT=EST_LBS,NUM_KEPT,LENGTH_FL=LEN_MM,LBS=SIZ_LBS)
 
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

# Convert weights to lengths and verify
BB$GRAMS                <- BB$LBS*0.453592*1000
BB$LENGTH_FL_FROMWEIGHT <-(BB$GRAMS/ BB$LW_A)^(1/BB$LW_B)

ggplot(data=BB[!is.na(LENGTH_FL)&!is.na(LENGTH_FL_FROMWEIGHT)])+geom_point(aes(x=LENGTH_FL,y=LENGTH_FL_FROMWEIGHT,col=SPECIES))+
  geom_abline(intercept=0, slope=1)+facet_wrap(~SPECIES,scales="free_y")+theme(legend.position="none")
ggsave(plot=last_plot(),filename=paste0(root_dir,"/Outputs/Summary/Size figures/LENGTHfromW vs Lengths.png"),width=8,height=6,units="in")

ggplot(data=BB)+geom_histogram(aes(x=LENGTH_FL_FROMWEIGHT,fill=SPECIES))+facet_wrap(~SPECIES,scales="free")+theme(legend.position="none")
ggsave(plot=last_plot(),filename=paste0(root_dir,"/Outputs/Summary/Size figures/LENGTHfromW_histogram.png"),width=8,height=6,units="in")

# Calculate mean weight from total pounds caught (alternative)
BC               <- BB[!(is.na(NUM_KEPT)),list(LBS_CAUGHT=max(LBS_CAUGHT),NUM_KEPT=max(NUM_KEPT)),by=list(INTERVIEW_PK,YEAR,SPECIES,LW_A,LW_B)]
BC$MWfromCATCH   <- BC$LBS_CAUGHT/BC$NUM_KEPT
BC$MWfromCATCH   <- BC$MWfromCATCH*0.453592*1000
BC$ML_FROM_CATCH <- (BC$MWfromCATCH/BC$LW_A)^(1/BC$LW_B)
BC2               <- BC[,list(ML_FROM_CATCH=mean(ML_FROM_CATCH)),by=list(YEAR,SPECIES)]

# Quick pattern check on mean length and mean weight stability
BD <- BB[METHOD_C=="Bottomfishing",list(ML_FROM_WEIGHT=mean(LENGTH_FL_FROMWEIGHT,na.rm=T),ML_FROM_LENGTH=mean(LENGTH_FL,na.rm=T)),by=list(SPECIES,YEAR)]
ggplot(data=BD,aes(x=YEAR))+geom_line(aes(y=ML_FROM_WEIGHT,col="red"),size=1)+geom_line(aes(y=ML_FROM_LENGTH,col="blue"),size=1)+
  geom_line(data=BC2,aes(y=ML_FROM_CATCH,col="black"),size=1)+facet_wrap(~SPECIES,scales="free")+
  scale_color_identity(name = "Mean Length Source",
                       breaks = c("red", "blue", "black"),
                       labels = c("From weight measures", "From length measures", "From mean catch per trip"),
                       guide = "legend")+theme_bw()
ggsave(plot=last_plot(),filename=paste0(root_dir,"/Outputs/Summary/Size figures/LENGTHfrom3Methods.png"),width=8,height=4,units="in")

# Check why ML from catch is bad in older data
BE <- BB[!(is.na(NUM_KEPT)),list(NUM_KEPT=mean(NUM_KEPT)),by=list(INTERVIEW_PK,YEAR)]
ggplot(data=BE)+geom_histogram(aes(x=NUM_KEPT))+facet_wrap(~YEAR,scales="free_y")+xlim(c(-1,20))
ggsave(plot=last_plot(),filename=paste0(root_dir,"/Outputs/Summary/Size figures/Dist_NumKept.png"),width=8,height=4,units="in")

# Check if we can fix this issue by removing interviews where SIZ_PK count != NUM_KEPT
BF <- BB[!(is.na(NUM_KEPT)),list(ONES=1),by=list(INTERVIEW_PK,SIZE_PK)]
BF <- BF[,list(N_SIZEPK=sum(ONES)),by=list(INTERVIEW_PK)]
BF <- merge(BC,BF,by="INTERVIEW_PK")
BF <- BF[N_SIZEPK==NUM_KEPT] # This filters almost all available data
BF <- BF[,list(ML_FROM_CATCH=mean(ML_FROM_CATCH)),by=list(SPECIES,YEAR)]

ggplot(data=BD,aes(x=YEAR))+geom_line(aes(y=ML_FROM_WEIGHT,col="red"),size=1)+geom_line(aes(y=ML_FROM_LENGTH,col="blue"),size=1)+
  geom_line(data=BC2,aes(y=ML_FROM_CATCH,col="black"),size=1)+geom_line(data=BF,aes(y=ML_FROM_CATCH,col="orange"),size=1.2)+
  facet_wrap(~SPECIES,scales="free")+scale_color_identity(name = "Mean Length Source",
                                        breaks = c("red", "blue", "black","orange"),
                                        labels = c("From weight measures", "From length measures", "From mean catch per trip","From mean catch per trip v2"),
                                        guide = "legend")+theme_bw() 
ggsave(plot=last_plot(),filename=paste0(root_dir,"/Outputs/Summary/Size figures/LENGTHfrom4methods.png"),width=10,height=4,units="in")


# Final options for BBS data
table(BB$METHOD_C,BB$SCIENTIFIC_NAME)
BB <- BB[METHOD_C=="Bottomfishing"]  # This filters a few spearfishing records for some species. Main impact is for VALO with 51 records removed.

BB <- BB[!is.na(LENGTH_FL)]

BB <- select(BB,DATASET,SPECIES,YEAR,AREA_C,LENGTH_FL)

# ===============Biosampling program sizes======================================================================      
BIO              <- data.table(   read.xlsx(paste0(root_dir,"/Data/BIOSAMPLING.xlsx"),sheet="RAW",colNames=TRUE)   )
names(BIO)       <- toupper(names(BIO))
BIO$FISHEDDATE   <- as.Date(BIO$FISHEDDATE,origin="1899-12-30")
BIO$YEAR         <- year(BIO$FISHEDDATE)
BIO              <- select(BIO,YEAR,FISHEDAREA,FISHEDMETHOD,SCIENTIFIC_NAME=SCIENTIFICNAME,NUMPIECES,LENGTH_CM,WEIGHT_G)
BIO$DATASET      <- "Biosampling"

BIO     <- merge(BIO,A, by.x=c("FISHEDAREA","DATASET"),by.y=c("AREA_ID","DATASET"),all.x=T)
BIO     <- merge(BIO,M, by.x=c("FISHEDMETHOD","DATASET"),by.y=c("METHOD_ID","DATASET"),all.x=T)
BIO     <- merge(BIO,S,by="SCIENTIFIC_NAME")

setnames(BIO,c("NUMPIECES","LENGTH_CM"),c("COUNT","LENGTH_FL"))

BIO                       <- BIO[!is.na(LENGTH_FL)]
BIO[AREA_C=="N/A"]$AREA_C <- "Tutuila" # Assign N/A to Tutuila (only a few lengths)

BIO <- select(BIO,DATASET,SPECIES,YEAR,AREA_C,LENGTH_FL)

# ===============Diver survey sizes======================================================================      
load(paste0(root_dir,"/Data/ALL_REA_FISH_RAW.rdata"))
US <- rapply(df, as.character, classes="factor", how="replace")
US <- data.table(US)
US <- US[REGION=="SAMOA"]
US <- US[METHOD!="nSPC-CCR"&METHOD!="SPC"]
US <- US[EXCLUDE_FLAG!=-1]
US <- subset(US,select=-c(LW_A,LW_B))
US <- US[COUNT==1]

US         <- subset(US,select=c("OBS_YEAR","REGION","ISLAND","DEPTH_BIN","SITE","LATITUDE","LONGITUDE","SITEVISITID","REP","METHOD","TAXONNAME","SPECIES","OBS_TYPE","SIZE_"))                
US[DEPTH_BIN=="Shallow"]$DEPTH_BIN <- "SHALLOW"
setnames(US,c("TAXONNAME","SIZE_"),c("SCIENTIFIC_NAME","LENGTH_TL"))
US$DATASET <- "UVS"
US         <- merge(US,A[DATASET=="UVS"], by.x=c("SITE","DATASET"),by.y=c("AREA_ID","DATASET"),all.x=T) # Add area information
US         <- merge(US,S,by=c("SCIENTIFIC_NAME","SPECIES"))

# Assign area and weight
US[DEPTH_BIN=="Mid"]$DEPTH_BIN  <- "DEEP"
US[DEPTH_BIN=="Deep"]$DEPTH_BIN <- "DEEP"

US$AREA        <- paste(US$AREA_C,"_",US$DEPTH_BIN,sep="")
US$AREA_WEIGHT <- US$AREA_WEIGHT/2  # Divide by 2 to distribute weights equally between deep and shallow. Temporary fix. This should be improved with more accurate accounting.

# Select BMUS
US <- US[SPECIES=="VALO"|SPECIES=="LERU"|SPECIES=="APVI"|SPECIES=="LUKA"]

# Convert TL to FL using metadata file
US$LENGTH_FL <- US$LENGTH_TL*US$TL_TO_FL

# Save data
table(US$SPECIES,US$AREA_C)
US <- select(US,DATASET,SPECIES,YEAR=OBS_YEAR,AREA_C,LENGTH_FL)

#================Put size data together===============================================
D <- rbind(US,BIO,BB)

if(Combine_BB_BIO==T) D[DATASET=="Biosampling"|DATASET=="BBS"]$DATASET <- "BIO and BBS"

# Merge all years for Atoll
D[AREA_C=="Atoll"]$YEAR <- 2022

# Add some LH info
LH <- select(S,SPECIES,LMAX)
D  <- merge(D,LH,by="SPECIES")
D  <- D[LENGTH_FL<=LMAX]

# Add region weights
D <- merge(D,AW,by="AREA_C")

# Statistics
Species.List <- unique(D$SPECIES)
NList   <- list()
GList   <- list()
L99List <- list()
for(i in 1:length(Species.List)){
   
   Sp        <- Species.List[i]
   BIN_SIZE  <- BIN.LIST[SPECIES==Sp]$BINWIDTH
   E         <- D[SPECIES==Sp&LENGTH_FL>0]
   
   # Filter YEARs with low N
   NB         <- data.table( table(E$DATASET,E$YEAR,E$AREA_C) )
   NB$V2      <- as.numeric(NB$V2)
   setnames(NB,c("V1","V2","V3"),c("DATASET","YEAR","AREA_C"))
   NB2        <- NB[N>=MinN]
   G          <- merge(E,NB2,by=c("DATASET","YEAR","AREA_C"))
   NB$SPECIES <- Sp
   
   # Effective Sample size by YEAR
   SAMPSIZE      <- G[,list(N=.N),by=list(DATASET,YEAR,AREA_C,WEIGHT)]
   SAMPSIZE$EFFN <- SAMPSIZE$N*SAMPSIZE$WEIGHT
   SAMPSIZE      <- SAMPSIZE[,list(EFFN=sum(EFFN)),by=list(DATASET,YEAR)]
   G             <- merge(G,SAMPSIZE,by=c("DATASET","YEAR"),all.x=T)
   
   if(Combine_Areas==T)  G[AREA_C=="Tutuila"|AREA_C=="Manua"|AREA_C=="Bank"]$AREA_C <- "Main"
   
   Fld <- paste0(root_dir,"/Outputs/Summary/Size figures/")
   if(nrow(G[DATASET=="Biosampling"])>0){
      ggplot(data=G[DATASET=="Biosampling"])+geom_histogram(aes(x=LENGTH_FL,y=..density..),binwidth=BIN_SIZE)+facet_wrap(~YEAR,scales="free_y",ncol=5)
      ggsave(paste0(Fld,Sp,"_Freq_","BIO",".png"),width=20,height=10,unit="cm")}
   
   if(nrow(G[DATASET=="UVS"])>0){
      ggplot(data=G[DATASET=="UVS"])+geom_histogram(aes(x=LENGTH_FL,y=..density..),binwidth=BIN_SIZE)+facet_wrap(~YEAR,scales="free_y",ncol=5)
      ggsave(paste0(Fld,Sp,"_Freq_","US",".png"),width=20,height=10,unit="cm")}
   
   if(nrow(G[DATASET=="BIO"])>0){
      ggplot(data=G[DATASET=="BIO"])+geom_histogram(aes(x=LENGTH_FL,y=..density..),binwidth=BIN_SIZE)+facet_wrap(~YEAR,scales="free_y",ncol=5)
      ggsave(paste0(Fld,Sp,"_Freq_","BB",".png"),width=20,height=10,unit="cm")}
   
   if(nrow(G[DATASET=="BIO and BBS"])>0){
      ggplot(data=G[DATASET=="BIO and BBS"])+geom_histogram(aes(x=LENGTH_FL,y=..density..),binwidth=BIN_SIZE)+facet_wrap(~YEAR,scales="free_y",ncol=5)
      ggsave(paste0(Fld,Sp,"_Freq_","BIO and BBS",".png"),width=20,height=10,unit="cm")}
   
   # L99 to use for StepwiseLH tool, if needed
   L99List[[i]] <- G[,list(L99=round(quantile(LENGTH_FL,0.99),1)),by=list(SPECIES,DATASET)]
   
   # Prepare DATASET for SS3
   # Add length bin lower ends to DATASET
   G$LENGTH_BIN_START <- G$LENGTH_FL-(G$LENGTH_FL%%BIN_SIZE)
  
   # Calculate abundance-at-length
   G <- G[,list(N=.N),by=list(SPECIES,AREA_C,EFFN,DATASET,YEAR,LENGTH_BIN_START)]
   G <- G[order(SPECIES,AREA_C,DATASET,YEAR,LENGTH_BIN_START)]
   
   # Add full range of size bins, if any are missing, by temporarily inserting fake data with full range
   BINS       <- seq(min(G$LENGTH_BIN_START),max(G$LENGTH_BIN_START),by=BIN_SIZE)
   TEMP       <- data.table(cbind(SPECIES="FAKE",DATASET="FAKE",AREA_C="FAKE",EFFN=0,YEAR=2222,LENGTH_BIN_START=BINS,N=0))
   TEMP[,3:5] <- rapply(TEMP[,4:6], as.numeric, how="replace") 
   G          <- rbind(G,TEMP)
   
   # Continue
   G <- dcast.data.table(G,SPECIES+DATASET+AREA_C+EFFN+YEAR~LENGTH_BIN_START,value.var="N",fill=0)
   G <- melt(G,id.vars=1:5,value.name="N",variable.name="LENGTH_BIN_START")
   G <- G[DATASET!="FAKE"]
   
   NList[[i]] <- NB 
   GList[[i]] <- G
}

# Export size structure to single RDS file
 SizeData   <- rbindlist(GList)
 SizeData$N <- as.numeric(SizeData$N)
 SizeData$LENGTH_BIN_START <- as.numeric(as.character(SizeData$LENGTH_BIN_START))

 SizeData <- SizeData[AREA_C!="Atoll"]
 SizeData <- select(SizeData,SPECIES,DATASET,YEAR,EFFN,LENGTH_BIN_START,N)
 saveRDS(SizeData,paste0(root_dir,"/Outputs/SS3_Inputs/SIZE_Final.rds"))


# Output a sample size summary (includes YEARs with < MinN)
Summary <- do.call(rbind.data.frame, NList)
Summary <- dcast.data.table(Summary,SPECIES+AREA_C+DATASET~YEAR,value.var="N",fill=0)
write.xlsx(Summary,paste0(root_dir,"/Outputs//Summary//Size_N_YEAR.xlsx"))

L99Summary <- do.call(rbind.data.frame, L99List)
L99Summary <- dcast.data.table(L99Summary,SPECIES~DATASET,value.var="L99",fill=NA)
write.xlsx(L99Summary,paste0(root_dir,"/Outputs//Summary//L99.xlsx"))




