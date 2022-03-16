require(data.table); require(ggplot2); require(gridExtra); require(directlabels);require(openxlsx); require(ggpmisc);require(directlabels);require(dplyr)

# Options
Combine_BB_BS <- F # Combine biosampling and creel survey lengths
Combine_Areas <- T # Combine Tutuila, Manua, and the Banks
MinN          <- 30 # Minimum sample size to do size frequency
BIN.LIST      <- data.table(SPECIES=c("APRU","APVI","CALU","ETCA","ETCO","LERU","LUKA","PRFI","PRFL","PRZO","VALO"),BINWIDTH=c(5,5,5,5,5,3,2,5,5,5,5)) # in cm

# Load diver sizes
US <- readRDS("Outputs\\readyUVS.rds")
#US <- US[METHOD!="SPC"] # Exclude the old SPC method
US$LENGTH_FL              <- US$LENGTH_FL/10 # Convert to cm
US[REGION=="NWHI"]$AREA_B <- "NWHI"
table(US$SPECIES,US$AREA_B)
#US[AREA_B=="Atoll"]$YEAR <- 9999 # Put all the Atoll data into a non-specific year, for further analyses (while separting it from other areas)
if(Combine_Areas==T) US[AREA_B=="Tutuila"|AREA_B=="Manua"|AREA_B=="Bank"]$AREA_B <- "Main"
US <- select(US,DATASET,YEAR,AREA_B,SPECIES,METHOD_C=METHOD,COUNT,LENGTH_FL)

# Load biosampling sizes
BS                       <- readRDS("Outputs\\readyBiosamp.rds")
BS                       <- BS[!is.na(LENGTH_FL)]
BS[AREA_B=="N/A"]$AREA_B <- "Tutuila" # Assign N/A to Tutuila (only a few lengths)
BS$LENGTH_FL             <- BS$LENGTH_FL/10 # Convert to cm
if(Combine_Areas==T) BS[AREA_B=="Tutuila"|AREA_B=="Manua"|AREA_B=="Bank"]$AREA_B <- "Main"
BS                       <- select(BS,DATASET,YEAR,AREA_B,SPECIES,METHOD_C,COUNT,LENGTH_FL)

# Load BBS sizes
BB <- readRDS("Outputs\\readyBBS_Size.rds")
if(Combine_Areas==T) BB[AREA_B=="Tutuila"|AREA_B=="Manua"|AREA_B=="Bank"]$AREA_B <- "Main"
BB <- select(BB,DATASET,YEAR,AREA_B,SPECIES,METHOD_C,COUNT,LENGTH_FL)
BB <- BB[!is.na(LENGTH_FL)]

# Merge DATASETs
D <- rbind(US,BS,BB)
if(Combine_BB_BS==T) D[DATASET=="Biosampling"|DATASET=="BBS"]$DATASET <- "BS and BBS"

# Merge all years for Atoll and NWHI
D[AREA_B=="Atoll"|AREA_B=="NWHI"]$YEAR <- 2022


# Add some LH info
LH <- data.table(read.xlsx("DATA\\METADATA.xlsx",sheet="SPECIES"))
colnames(LH) <- toupper(colnames(LH))
LH$LMAX <- LH$LMAX/10
LH <- select(LH,SPECIES,LMAX)
D  <- merge(D,LH,by="SPECIES")

# Add region weights
D$RW <- 0.8
D[AREA_B=="Manua"]$RW <- 0.2

# Statistics
Species.List <- unique(D$SPECIES)
NList <- list()
L99List <- list()
for(i in 1:length(Species.List)){
 
 Sp        <- Species.List[i]
 BIN_SIZE  <- BIN.LIST[SPECIES==Sp]$BINWIDTH
 E  <- D[SPECIES==Sp&LENGTH_FL>0]
 
 # Filter YEARs with low N
 NB         <- data.table( table(E$DATASET,E$YEAR,E$AREA_B) )
 NB$V2      <- as.numeric(NB$V2)
 setnames(NB,c("V1","V2","V3"),c("DATASET","YEAR","AREA_B"))
 NB2        <- NB[N>=MinN]
 G          <- merge(E,NB2,by=c("DATASET","YEAR","AREA_B"))
 NB$SPECIES <- Sp
 
 Fld <- "Outputs/Graphs/Size/"
 if(nrow(G[DATASET=="Biosampling"])>0){
 ggplot(data=G[DATASET=="Biosampling"])+geom_histogram(aes(x=LENGTH_FL,y=..density..),binwidth=BIN_SIZE)+facet_wrap(~YEAR,scales="free_y",ncol=5)
 ggsave(paste0(Fld,Sp,"_Freq_","BS",".png"),width=20,height=10,unit="cm")}
 
 if(nrow(G[DATASET=="UVS"])>0){
 ggplot(data=G[DATASET=="UVS"])+geom_histogram(aes(x=LENGTH_FL,y=..density..),binwidth=BIN_SIZE)+facet_wrap(~YEAR,scales="free_y",ncol=5)
 ggsave(paste0(Fld,Sp,"_Freq_","US",".png"),width=20,height=10,unit="cm")}
 
 if(nrow(G[DATASET=="BBS"])>0){
 ggplot(data=G[DATASET=="BBS"])+geom_histogram(aes(x=LENGTH_FL,y=..density..),binwidth=BIN_SIZE)+facet_wrap(~YEAR,scales="free_y",ncol=5)
 ggsave(paste0(Fld,Sp,"_Freq_","BB",".png"),width=20,height=10,unit="cm")}

 if(nrow(G[DATASET=="BS and BBS"])>0){
 ggplot(data=G[DATASET=="BS and BBS"])+geom_histogram(aes(x=LENGTH_FL,y=..density..),binwidth=BIN_SIZE)+facet_wrap(~YEAR,scales="free_y",ncol=5)
 ggsave(paste0(Fld,Sp,"_Freq_","BS and BBS",".png"),width=20,height=10,unit="cm")}
 
# Prepare DATASET for SS3
# Obtain mean weight and mean length per trip
 #BINS      <- seq(from=0,ceiling(max(G$LMAX)),by=BIN_SIZE)
 #BINS      <- cbind(BINS,seq(1,28,by=1))
 G         <- G[LENGTH_FL<=LMAX]

 L99List[[i]] <- G[,list(L99=round(quantile(LENGTH_FL,0.99),1)),by=list(SPECIES,DATASET)]
 
# Add length bin lower ends to DATASET
 G$LENGTH_BIN_START <- G$LENGTH_FL-(G$LENGTH_FL%%BIN_SIZE)
 
# Effective Sample size by YEAR
 SAMPSIZE      <- G[,list(N=.N),by=list(DATASET,YEAR,AREA_B,RW)]
 SAMPSIZE$EFFN <- SAMPSIZE$N*SAMPSIZE$RW
 SAMPSIZE      <- SAMPSIZE[,list(EFFN=sum(EFFN)),by=list(DATASET,YEAR)]
 #plot(SAMPSIZE$YEAR,SAMPSIZE$EFFN)

# Calculate abundance-at-length
 G <- G[,list(N=.N),by=list(AREA_B,DATASET,YEAR,LENGTH_BIN_START)]
 G <- G[order(AREA_B,DATASET,YEAR,LENGTH_BIN_START)]

 # Add full range of size bins, if any are missing, by temporarily inserting fake data with full range
 BINS       <- seq(min(G$LENGTH_BIN_START),max(G$LENGTH_BIN_START),by=BIN_SIZE)
 TEMP       <- data.table(cbind(DATASET="FAKE",AREA_B="FAKE",YEAR=2222,LENGTH_BIN_START=BINS,N=0))
 TEMP[,3:5] <- rapply(TEMP[,3:5], as.numeric, how="replace") 
 G          <- rbind(G,TEMP)
 
 # Continue
 G <- dcast.data.table(G,DATASET+AREA_B+YEAR~LENGTH_BIN_START,value.var="N",fill=0)

 G <- merge(G,SAMPSIZE,by=c("DATASET","YEAR"),all.x=T)
 G <- select(G[DATASET!="FAKE"],DATASET,AREA_B,YEAR,EFFN,4:ncol(G))

 NList[[i]] <- NB 
 write.csv(G,paste0("Outputs/SS3_Inputs/",Sp,"/SIZE_",Sp,".csv"),row.names=F)
 
}

# Output a sample size summary (includes YEARs with < MinN)
Summary <- do.call(rbind.data.frame, NList)
Summary <- dcast.data.table(Summary,SPECIES+AREA_B+DATASET~YEAR,value.var="N",fill=0)
write.xlsx(Summary,"Outputs//Graphs//SIZE//Size_N_YEAR.xlsx")

L99Summary <- do.call(rbind.data.frame, L99List)
L99Summary <- dcast.data.table(L99Summary,SPECIES~DATASET,value.var="L99",fill=NA)
write.xlsx(L99Summary,"Outputs//Graphs//SIZE//L99.xlsx")
