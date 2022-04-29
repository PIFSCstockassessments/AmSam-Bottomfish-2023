# This script loads size data from the BBS, biosampling, and diver datasets and organizes them in a single table   

require(data.table); require(openxlsx); require(dplyr); require(openxlsx); require(ggplot2);require(gridExtra);require(grid); options(stringsAsFactors=F); options(scipen=999)
root_dir <- this.path::here(.. = 1) # establish directories using this.path

# Load metadata tables (Area, Method, Species)
A            <- data.table(  read.xlsx(paste0(root_dir, "/Data/METADATA.xlsx"),sheet="AREAS")   )
A            <- select(A,DATASET,AREA_ID,AREA_A,AREA_C,AREA_C)
M            <- data.table(read.xlsx("DATA//METADATA.xlsx",sheet="METHODS"))
M            <- select(M,DATASET,METHOD_ID,METHOD_C)
M$METHOD_ID  <- as.character(M$METHOD_ID)
S            <- data.table(  read.xlsx(paste0(root_dir, "/Data/METADATA.xlsx"),sheet="BMUS")   )
S            <- select(S,SPECIES_PK,SPECIES,SCIENTIFIC_NAME,FAMILY,LMAX,TL_TO_FL)
S$LMAX       <- S$LMAX/10
S$SPECIES_PK <- as.character(S$SPECIES_PK)

# ===============Boat-based creel survey sizes======================================================================      
#  STEP 1: read in 4 "flatview" datafiles, followed by some basic data handling
 aint_bbs1 <- fread(paste(root_dir, "/Data/a_bbs_int_flat1.csv", sep=""), header=T, stringsAsFactors=FALSE) 			
 aint_bbs2 <- fread(paste(root_dir, "/Data/a_bbs_int_flat2.csv", sep=""), header=T, stringsAsFactors=FALSE) 			
 aint_bbs3 <- fread(paste(root_dir, "/Data/a_bbs_int_flat3.csv", sep=""), header=T, stringsAsFactors=FALSE) 			
 aint_bbs4 <- fread(paste(root_dir, "/Data/a_bbs_int_flat4.csv", sep=""), header=T, stringsAsFactors=FALSE)
 aint_bbs5 <- fread(paste(root_dir, "/Data/PICDR-113220 BB Creel Data_all_columns.csv", sep=""), header=T, stringsAsFactors=FALSE)
 aint_bbs5 <- aint_bbs5[,-62]       # drop var 62 ('COMMON_NAME') which is duplicated		
 aint_bbs4 <- aint_bbs4[year(SAMPLE_DATE) < 2021] # aint_bbs4 had some 2021 record (duplicated with aint_bbs5)								
 BB        <- rbind.data.frame(aint_bbs1, aint_bbs2, aint_bbs3, aint_bbs4, aint_bbs5) # rbind coerce variable formats in the dfs to match		

 BB$YEAR       <- year(BB$SAMPLE_DATE)
 BB            <- select(BB,YEAR,SPECIES_FK,ISLAND_NAME,AREA_FK,METHOD_FK,NUM_KEPT,LEN_MM,SIZ_LBS)
 BB$AREA_FK    <- as.character((BB$AREA_FK))
 BB$METHOD_FK  <- as.character((BB$METHOD_FK))
 BB$LEN_MM     <- as.numeric(BB$LEN_MM)
 BB$SIZ_LBS    <- as.numeric(BB$SIZ_LBS)

 #Merge metadata tables
 BB <- merge(BB,A[DATASET=="BBS"],by.x="AREA_FK",by.y="AREA_ID")
 BB <- merge(BB,M[DATASET=="BBS"],by.x="METHOD_FK",by.y="METHOD_ID")
 BB <- merge(BB,S,by.x="SPECIES_FK",by.y="SPECIES_PK")
 
 # Simplify this dataset
 BB <- select(BB,YEAR,SCIENTIFIC_NAME,SPECIES_FK,SPECIES,ISLAND_NAME,AREA_C,METHOD_C,COUNT=NUM_KEPT,LENGTH_FL=LEN_MM,LBS=SIZ_LBS)
 
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
BB$DATASET               <- "BBS"

# ===============Biosampling program sizes======================================================================      
BIO              <- data.table(read.xlsx("DATA\\BIOSAMPLING.xlsx",sheet="RAW",colNames=TRUE))
names(BIO)       <- toupper(names(BIO))
BIO$FISHEDDATE   <- as.Date(BIO$FISHEDDATE,origin="1899-12-30")
BIO$YEAR         <- year(BIO$FISHEDDATE)
BIO              <- select(BIO,YEAR,FISHEDAREA,FISHEDMETHOD,SCIENTIFIC_NAME=SCIENTIFICNAME,NUMPIECES,LENGTH_CM,WEIGHT_G)
BIO$DATASET      <- "Biosampling"

BIO     <- merge(BIO,A, by.x=c("FISHEDAREA","DATASET"),by.y=c("AREA_ID","DATASET"))
BIO     <- merge(BIO,S,by="SCIENTIFIC_NAME")
BIO     <- merge(BIO,M, by.x=c("FISHEDMETHOD","DATASET"),by.y=c("METHOD_ID","DATASET"))

setnames(BIO,c("NUMPIECES","LENGTH_CM"),c("COUNT","LENGTH_FL"))

BIO                       <- BS[!is.na(LENGTH_FL)]
BIO[AREA_C=="N/A"]$AREA_C <- "Tutuila" # Assign N/A to Tutuila (only a few lengths)
BIO$COUNT     <- 1

# ===============Diver survey sizes======================================================================      
load("DATA\\ALL_REA_FISH_RAW.rdata")
US <- rapply(df, as.character, classes="factor", how="replace")
US <- data.table(US)
US <- US[REGION=="SAMOA"]
US <- US[METHOD!="nSPC-CCR"&METHOD!="SPC"]
US <- US[EXCLUDE_FLAG!=-1]
US <- subset(US,select=-c(LW_A,LW_B))

US         <- subset(US,select=c("OBS_YEAR","REGION","ISLAND","DEPTH_BIN","SITE","LATITUDE","LONGITUDE","SITEVISITID","REP","METHOD","TAXONNAME","SPECIES","OBS_TYPE","COUNT","SIZE_"))                
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
US <- select(US,DATASET,YEAR=OBS_YEAR,AREA_C,SITE,SITEVISITID,REP,SCIENTIFIC_NAME,SPECIES,METHOD_C=METHOD,OBS_TYPE,LENGTH_FL,COUNT)

#================Put size data together===============================================

# Options
Combine_BB_BIO <- F # Combine biosampling and creel survey lengths
Combine_Areas <- T # Combine Tutuila, Manua, and the Banks
MinN          <- 30 # Minimum sample size to do size frequency
BIN.LIST      <- data.table(SPECIES=c("APRU","APVI","CALU","ETCA","ETCO","LERU","LUKA","PRFI","PRFL","PRZO","VALO"),BINWIDTH=c(5,5,5,5,5,3,2,5,5,5,5)) # in cm

table(US$SPECIES,US$AREA_C)

#US[AREA_C=="Atoll"]$YEAR <- 9999 # Put all the Atoll data into a non-specific year, for further analyses (while separting it from other areas)
if(Combine_Areas==T) US[AREA_C=="Tutuila"|AREA_C=="Manua"|AREA_C=="Bank"]$AREA_C <- "Main"
US <- select(US,DATASET,YEAR,AREA_C,SPECIES,METHOD_C,COUNT,LENGTH_FL)

# Load biosampling sizes
if(Combine_Areas==T) BIO[AREA_C=="Tutuila"|AREA_C=="Manua"|AREA_C=="Bank"]$AREA_C <- "Main"
BIO                       <- select(BIO,DATASET,YEAR,AREA_C,SPECIES,METHOD_C,COUNT,LENGTH_FL)
BIO                       <- BIO[(SPECIES=="VALO"&METHOD_C=="Spear")|(SPECIES!="VALO"&METHOD_C=="Bottomfishing")] # Removes some misIDed PRFI and PRFL caught by spear

# Load BBS sizes
if(Combine_Areas==T) BB[AREA_C=="Tutuila"|AREA_C=="Manua"|AREA_C=="Bank"]$AREA_C <- "Main"
BB <- select(BB,DATASET,YEAR,AREA_C,SPECIES,METHOD_C,COUNT,LENGTH_FL)
BB <- BB[!is.na(LENGTH_FL)]
BB <- BB[METHOD_C=="Bottomfishing"]

# Merge DATASETs
D <- rbind(US,BIO,BB)
if(Combine_BB_BIO==T) D[DATASET=="Biosampling"|DATASET=="BBIO"]$DATASET <- "BIO and BBIO"

# Merge all years for Atoll and NWHI
D[AREA_C=="Atoll"]$YEAR <- 2022

# Add some LH info
S$LMAX <- S$LMAX/10
LH <- select(S,SPECIES,LMAX)
D  <- merge(D,LH,by="SPECIES")

# Add region weights
D$RW <- 0.8
D[AREA_C=="Manua"]$RW <- 0.2

# Statistics
Species.List <- unique(D$SPECIES)
NList <- list()
L99List <- list()
for(i in 1:length(Species.List)){
   
   Sp        <- Species.List[i]
   BIN_SIZE  <- BIN.LIST[SPECIES==Sp]$BINWIDTH
   E  <- D[SPECIES==Sp&LENGTH_FL>0]
   
   # Filter YEARs with low N
   NB         <- data.table( table(E$DATASET,E$YEAR,E$AREA_C) )
   NB$V2      <- as.numeric(NB$V2)
   setnames(NB,c("V1","V2","V3"),c("DATASET","YEAR","AREA_C"))
   NB2        <- NB[N>=MinN]
   G          <- merge(E,NB2,by=c("DATASET","YEAR","AREA_C"))
   NB$SPECIES <- Sp
   
   Fld <- "Outputs/Graphs/Size/"
   if(nrow(G[DATASET=="Biosampling"])>0){
      ggplot(data=G[DATASET=="Biosampling"])+geom_histogram(aes(x=LENGTH_FL,y=..density..),binwidth=BIN_SIZE)+facet_wrap(~YEAR,scales="free_y",ncol=5)
      ggsave(paste0(Fld,Sp,"_Freq_","BIO",".png"),width=20,height=10,unit="cm")}
   
   if(nrow(G[DATASET=="UVS"])>0){
      ggplot(data=G[DATASET=="UVS"])+geom_histogram(aes(x=LENGTH_FL,y=..density..),binwidth=BIN_SIZE)+facet_wrap(~YEAR,scales="free_y",ncol=5)
      ggsave(paste0(Fld,Sp,"_Freq_","US",".png"),width=20,height=10,unit="cm")}
   
   if(nrow(G[DATASET=="BBIO"])>0){
      ggplot(data=G[DATASET=="BBIO"])+geom_histogram(aes(x=LENGTH_FL,y=..density..),binwidth=BIN_SIZE)+facet_wrap(~YEAR,scales="free_y",ncol=5)
      ggsave(paste0(Fld,Sp,"_Freq_","BB",".png"),width=20,height=10,unit="cm")}
   
   if(nrow(G[DATASET=="BIO and BBIO"])>0){
      ggplot(data=G[DATASET=="BIO and BBIO"])+geom_histogram(aes(x=LENGTH_FL,y=..density..),binwidth=BIN_SIZE)+facet_wrap(~YEAR,scales="free_y",ncol=5)
      ggsave(paste0(Fld,Sp,"_Freq_","BIO and BBIO",".png"),width=20,height=10,unit="cm")}
   
   # Prepare DATASET for SS3
   # Obtain mean weight and mean length per trip
   #BINS      <- seq(from=0,ceiling(max(G$LMAX)),by=BIN_SIZE)
   #BINS      <- cbind(BINS,seq(1,28,by=1))
   G         <- G[LENGTH_FL<=LMAX]
   
   L99List[[i]] <- G[,list(L99=round(quantile(LENGTH_FL,0.99),1)),by=list(SPECIES,DATASET)]
   
   # Add length bin lower ends to DATASET
   G$LENGTH_BIN_START <- G$LENGTH_FL-(G$LENGTH_FL%%BIN_SIZE)
   
   # Effective Sample size by YEAR
   SAMPSIZE      <- G[,list(N=.N),by=list(DATASET,YEAR,AREA_C,RW)]
   SAMPSIZE$EFFN <- SAMPSIZE$N*SAMPSIZE$RW
   SAMPSIZE      <- SAMPSIZE[,list(EFFN=sum(EFFN)),by=list(DATASET,YEAR)]
   #plot(SAMPSIZE$YEAR,SAMPSIZE$EFFN)
   
   # Calculate abundance-at-length
   G <- G[,list(N=.N),by=list(AREA_C,DATASET,YEAR,LENGTH_BIN_START)]
   G <- G[order(AREA_C,DATASET,YEAR,LENGTH_BIN_START)]
   
   # Add full range of size bins, if any are missing, by temporarily inserting fake data with full range
   BINS       <- seq(min(G$LENGTH_BIN_START),max(G$LENGTH_BIN_START),by=BIN_SIZE)
   TEMP       <- data.table(cbind(DATASET="FAKE",AREA_C="FAKE",YEAR=2222,LENGTH_BIN_START=BINS,N=0))
   TEMP[,3:5] <- rapply(TEMP[,3:5], as.numeric, how="replace") 
   G          <- rbind(G,TEMP)
   
   # Continue
   G <- dcast.data.table(G,DATASET+AREA_C+YEAR~LENGTH_BIN_START,value.var="N",fill=0)
   
   G <- merge(G,SAMPSIZE,by=c("DATASET","YEAR"),all.x=T)
   G <- select(G[DATASET!="FAKE"],DATASET,AREA_C,YEAR,EFFN,4:ncol(G))
   
   NList[[i]] <- NB 
   write.csv(G,paste0("Outputs/SS3_Inputs/",Sp,"/SIZE_",Sp,".csv"),row.names=F)
   
}

# Output a sample size summary (includes YEARs with < MinN)
Summary <- do.call(rbind.data.frame, NList)
Summary <- dcast.data.table(Summary,SPECIES+AREA_C+DATASET~YEAR,value.var="N",fill=0)
write.xlsx(Summary,"Outputs//Graphs//SIZE//Size_N_YEAR.xlsx")

L99Summary <- do.call(rbind.data.frame, L99List)
L99Summary <- dcast.data.table(L99Summary,SPECIES~DATASET,value.var="L99",fill=NA)
write.xlsx(L99Summary,"Outputs//Graphs//SIZE//L99.xlsx")



