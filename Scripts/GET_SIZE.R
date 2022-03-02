require(data.table); require(ggplot2); require(gridExtra); require(directlabels);require(openxlsx); require(ggpmisc);require(directlabels);require(dplyr)

# Options
Combine_BB_BS <- T # Combine biosampling and creel survey lengths
MinN          <- 30 # Minimum sample size to do size frequency
BIN_SIZE      <- 5 # in cm

# Load diver sizes
US <- readRDS("Outputs\\readyUVS.rds")
US <- US[AREA_B=="Tutuila"|AREA_B=="Manua"]
US$LENGTH_FL <- US$LENGTH_FL/10 # Convert to cm
US <- select(US,DATASET,YEAR,AREA_B,SPECIES,METHOD_C,COUNT,LENGTH_FL)

# Load biosampling sizes
BS <- readRDS("Outputs\\readyBiosamp.rds")
BS <- BS[!is.na(LENGTH_FL)]
BS$LENGTH_FL <- BS$LENGTH_FL/10 # Convert to cm
BS <- select(BS,DATASET,YEAR,AREA_B,SPECIES,METHOD_C,COUNT,LENGTH_FL)

# Load BBS sizes
BB <- readRDS("Outputs\\readyBBS_Size.rds")
BB <- select(BB,DATASET,YEAR,AREA_B,SPECIES,METHOD_C,COUNT,LENGTH_FL)
BB <- BB[!is.na(LENGTH_FL)]

# Merge DATASETs
D <- rbind(US,BS,BB)
if(Combine_BB_BS==T) D[DATASET=="Biosampling"|DATASET=="BBS"]$DATASET <- "BS and BBS"


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
for(i in 1:length(Species.List)){
 
 Sp <- Species.List[i]
 E  <- D[SPECIES==Sp&LENGTH_FL>0]
 
 # Filter YEARs with low N
 NB         <- data.table( table(E$DATASET,E$YEAR) )
 NB$V2      <- as.numeric(NB$V2)
 setnames(NB,c("V1","V2"),c("DATASET","YEAR"))
 NB2        <- NB[N>=MinN]
 G          <- merge(E,NB2,by=c("DATASET","YEAR"))
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

# Add length bin lower ends to DATASET
 G$LENGTH_BIN_START <- G$LENGTH_FL-(G$LENGTH_FL%%BIN_SIZE)

# Effective Sample size by YEAR
 SAMPSIZE      <- G[,list(N=.N),by=list(DATASET,YEAR,AREA_B,RW)]
 SAMPSIZE$EFFN <- SAMPSIZE$N*SAMPSIZE$RW
 SAMPSIZE      <- SAMPSIZE[,list(EFFN=sum(EFFN)),by=list(DATASET,YEAR)]
 #plot(SAMPSIZE$YEAR,SAMPSIZE$EFFN)

# Calculate abundance-at-length
 G <- G[,list(N=.N),by=list(DATASET,YEAR,LENGTH_BIN_START)]
 G <- G[order(DATASET,YEAR,LENGTH_BIN_START)]

 G <- dcast.data.table(G,DATASET+YEAR~LENGTH_BIN_START,value.var="N",fill=0)

 G <- merge(G,SAMPSIZE,by=c("DATASET","YEAR"))
 G <- select(G,DATASET,YEAR,EFFN,3:ncol(G))

 NList[[i]] <- NB 
 write.csv(G,paste0("Outputs/SS3_Inputs/",Sp,"/SIZE_",Sp,".csv"),row.names=F)
 
}

# Output a sample size summary (includes YEARs with < MinN)
Summary <- do.call(rbind.data.frame, NList)
Summary <- dcast.data.table(Summary,SPECIES+DATASET~YEAR,value.var="N",fill=0)
write.xlsx(Summary,"Outputs//Graphs//SIZE//Size_N_YEAR.xlsx")
