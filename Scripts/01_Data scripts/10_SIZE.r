# This script loads size data from the BBS, biosampling, and diver datasets and organizes them in a single table   

require(data.table); require(openxlsx); require(tidyverse); require(openxlsx); require(gridExtra);require(grid); options(scipen=999)
root_dir <- this.path::here(.. = 2) # establish directories using this.path
dir.create(paste0(root_dir,"/Outputs/Summary/Size figures"),recursive=T,showWarnings=F)


# Options
Combine_BB_BIO <- T # Combine biosampling and creel survey lengths
Combine_Areas  <- T # Combine Tutuila, Manua, and the Banks
MinN           <- 0 # Minimum sample size to do size frequency
AW             <- data.table(AREA_C=c("Manua","Tutuila","Bank","Atoll"),WEIGHT=c(0.13,0.79,0.08,0)) # Area weight for effective sample size calculations
BIN.LIST       <- data.table(SPECIES=c("APRU","APVI","CALU","ETCA","ETCO","LERU","LUKA","PRFI","PRFL","PRZO","VALO"),
                       BINWIDTH=c(5,5,5,5,5,3.5,2,5,3,2,3)) # in cm

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

LH <- select(S,SPECIES,LMAX)

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
 
 BB                     <- select(BB,INTERVIEW_PK,INTERVIEWER1_FK,SIZE_PK,YEAR,SPECIES_FK,ISLAND_NAME,AREA_FK,METHOD_FK,NUM_KEPT,EST_LBS,LEN_MM,SIZ_LBS)
 
  #Merge metadata tables
 BB <- merge(BB,A[DATASET=="BBS"],by.x="AREA_FK",by.y="AREA_ID",all.x=T)
 BB <- merge(BB,M[DATASET=="BBS"],by.x=c("METHOD_FK","DATASET"),by.y=c("METHOD_ID","DATASET"),all.x=T)
 BB <- merge(BB,S,by.x="SPECIES_FK",by.y="SPECIES_PK")
 
 # Simplify this dataset
 BB <- select(BB,DATASET,INTERVIEW_PK,INTERVIEWER1_FK,SIZE_PK,YEAR,SCIENTIFIC_NAME,SPECIES_FK,SPECIES,ISLAND_NAME,AREA_C,METHOD_C,LW_A,LW_B,LBS_CAUGHT=EST_LBS,NUM_KEPT,LENGTH_FL=LEN_MM,LBS=SIZ_LBS)
 
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

# For LERU <=2009, keep only interviewers 13 and 27
BB <- BB %>% filter(!(SPECIES=="LERU"&YEAR<=2009&!(INTERVIEWER1_FK=="13"|INTERVIEWER1_FK=="27")))


# Final options for BBS data
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

# Create size comparison graph BBS vs Biosampling
EX <- D[DATASET!="UVS"&SPECIES!="ETCA"&SPECIES!="PRFI"]
EX <- merge(EX,LH,by="SPECIES")
EX <- EX[LENGTH_FL< LMAX&LENGTH_FL>15]

table(EX$DATASET,EX$SPECIES)
PLOT <- ggplot(data=EX,aes(x=LENGTH_FL,after_stat(density),col=DATASET))+geom_freqpoly(binwidth=5,linewidth=1)+facet_wrap(~SPECIES,scales="free")
ggsave(PLOT,file=file.path(root_dir,"Outputs","Summary","BBSvBIO size comparison.png"),height=6, width=9,unit="in")


if(Combine_BB_BIO==T){
#  D[(SPECIES!="APVI"&SPECIES!="LUKA")&(DATASET=="Biosampling"|DATASET=="BBS")]$DATASET <- "BIO and BBS"
#  D <- D[!((SPECIES=="APVI"|SPECIES=="LUKA")&DATASET=="Biosampling")] # The biosampling APVI and LUKA size distribution are  anomalous. Exclude this data.
  D[(SPECIES!="APVI")&(DATASET=="Biosampling"|DATASET=="BBS")]$DATASET <- "BIO and BBS"
  D <- D[!((SPECIES=="APVI")&DATASET=="Biosampling")] # The biosampling APVI size distribution are  anomalous. Exclude this data.
}

# Merge all years for Atoll
D[AREA_C=="Atoll"]$YEAR <- 2022

# Add some LH info
D  <- merge(D,LH,by="SPECIES")

# Remove lengths that are unrealistically big (see METADATA.xlsx file for source)
D  <- D[LENGTH_FL< LMAX]

# Remove lengths that realistically can't be caught on bottomfish gear
D <- D[LENGTH_FL > 15]

# Add region weights
D <- merge(D,AW,by="AREA_C")

# Filter 2011 data for VALO, very odd size frequency
#D <- D[!(SPECIES=="VALO"&YEAR==2011)]

# Statistics
Species.List <- unique(D$SPECIES)
Species.List <- Species.List[order(Species.List)]
NList   <- list()
GList   <- list()
L99List <- list()
for(i in 1:length(Species.List)){
   
   Sp        <- Species.List[i]
   BIN_SIZE  <- BIN.LIST[SPECIES==Sp]$BINWIDTH
   E         <- D[SPECIES==Sp&LENGTH_FL>0]
   
  
   # Effective Sample size by year
   N.AREA <- E %>% group_by(DATASET,YEAR,AREA_C,WEIGHT) %>% summarize(N=n()) # Sample size totals by Area
   N.TOT  <- E %>% group_by(DATASET,YEAR) %>% summarize(N.TOT=n()) %>%         # Sample size totals by dataset
                merge(N.AREA,by=c("DATASET","YEAR")) %>% mutate(ExpN=ceiling(N.TOT*WEIGHT), EFFN=0) 
   N.TOT  <- N.TOT %>% mutate(EFFN=ifelse(N>ExpN,ExpN,N)) %>% 
              group_by(DATASET,YEAR) %>% summarize(EFFN=sum(EFFN),N=sum(N))
   G       <- merge(E,N.TOT,by=c("DATASET","YEAR"))
  
   
   if(Combine_Areas==T)  E[AREA_C=="Tutuila"|AREA_C=="Manua"|AREA_C=="Bank"]$AREA_C <- "Main" 
 
   Fld <- paste0(root_dir,"/Outputs/Summary/Size figures/")
   if(nrow(G[DATASET=="Biosampling"])>0){
      ggplot(data=G[DATASET=="Biosampling"])+geom_histogram(aes(x=LENGTH_FL,y=..density..),binwidth=BIN_SIZE)+facet_wrap(~YEAR,scales="free_y",ncol=5)
      ggsave(paste0(Fld,Sp,"_Freq_","BIO",".png"),width=20,height=10,unit="cm")}
   
   if(nrow(G[DATASET=="UVS"])>0){
      ggplot(data=G[DATASET=="UVS"])+geom_histogram(aes(x=LENGTH_FL,y=..density..),binwidth=BIN_SIZE)+facet_wrap(~YEAR,scales="free_y",ncol=5)
      ggsave(paste0(Fld,Sp,"_Freq_","US",".png"),width=20,height=10,unit="cm")}
   
   if(nrow(G[DATASET=="BBS"])>0){
     ggplot(data=G[DATASET=="BBS"])+geom_histogram(aes(x=LENGTH_FL,y=..density..),binwidth=BIN_SIZE)+facet_wrap(~YEAR,scales="free_y",ncol=5)
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
   
   G <- G[order(DATASET,AREA_C,YEAR)]
   
   N.TOT$SPECIES <- Sp
   N.TOT$AREA_C  <- "Main"
   
   NList[[i]] <- N.TOT 
   GList[[i]] <- G
}

# Export size structure to single RDS file
 SizeData   <- rbindlist(GList)
 SizeData$N <- as.numeric(SizeData$N)
 SizeData$LENGTH_BIN_START <- as.numeric(as.character(SizeData$LENGTH_BIN_START))

 SizeData2 <- SizeData
 saveRDS(SizeData2,paste0(root_dir,"/Outputs/SS3_Inputs/SIZE_Final_LBSPR.rds"))
 
 # Remove UVS and Atoll data
 SizeData <- SizeData[AREA_C!="Atoll"&DATASET!="UVS"]
 SizeData <- SizeData %>% group_by(SPECIES,DATASET,YEAR,EFFN,LENGTH_BIN_START) %>% summarize(N=sum(N))
 
 write.csv(SizeData,paste0(root_dir,"/Outputs/SS3_Inputs/SIZE_Final.csv"),row.names=F)
 
# Output a sample size summary (includes YEARs with < MinN)
Summary <- rbindlist(NList)#do.call(rbind.data.frame, NList)
Summary <- dcast.data.table(Summary,SPECIES+AREA_C+DATASET~YEAR,value.var="N",fill=0)
write.xlsx(Summary,paste0(root_dir,"/Outputs//Summary//Size_N_YEAR.xlsx"))

L99Summary <- do.call(rbind.data.frame, L99List)
L99Summary <- dcast.data.table(L99Summary,SPECIES~DATASET,value.var="L99",fill=NA)
write.xlsx(L99Summary,paste0(root_dir,"/Outputs//Summary//L99.xlsx"))


