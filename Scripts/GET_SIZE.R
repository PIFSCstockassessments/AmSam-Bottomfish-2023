require(data.table); require(ggplot2); require(gridExtra); require(directlabels);require(openxlsx); require(ggpmisc);require(directlabels);require(dplyr)

# Load diver sizes
US <- readRDS("Outputs\\readyUVS.rds")
US <- US[Area_C=="Tutuila"|Area_C=="Manua"]
US$Length_FL <- US$Length_FL/10 # Convert to cm
US <- select(US,Dataset,Year,Area_B,Species,Method_C=Method,Count,Length_FL)

# Load biosampling sizes
BS <- readRDS("Outputs\\readyBiosamp.rds")
BS <- BS[!is.na(Length_FL)]
BS$Length_FL <- BS$Length_FL/10 # Convert to cm
BS <- select(BS,Dataset,Year,Area_B,Species,Method_C,Count,Length_FL)

# Load BBS sizes
BB <- readRDS("Outputs\\readyBBS_Size.rds")
BB <- select(BB,Dataset,Year,Area_B,Species,Method_C,Count,Length_FL)

# Merge datasets
D <- rbind(US,BS,BB)

# Add some LH info
LH <- data.table(read.xlsx("DATA\\METADATA.xlsx",sheet="SPECIES"))
LH$Lmax <- LH$Lmax/10
LH <- select(LH,Species,Lmax)
D  <- merge(D,LH,by="Species")

# Add region weights
D$RW <- 0.8
D[Area_B=="Manua"]$RW <- 0.2

# Statistics
MinN <- 30 # Minimum sample size to do size frequency
BIN_SIZE <- 5 # in cm
Species.List <- unique(D$Species)
NList <- list()
for(i in 1:length(Species.List)){
 
 Sp <- Species.List[i]
 E  <- D[Species==Sp&Length_FL>0]
 
 # Filter years with low N
 NB         <- data.table( table(E$Dataset,E$Year) )
 NB$V2      <- as.numeric(NB$V2)
 setnames(NB,c("V1","V2"),c("Dataset","Year"))
 NB2        <- NB[N>=MinN]
 G          <- merge(E,NB2,by=c("Dataset","Year"))
 NB$Species <- Sp
 
 Fld <- "Outputs/Graphs/Size/"
 if(nrow(G[Dataset=="Biosampling"])>0){
 ggplot(data=G[Dataset=="Biosampling"])+geom_histogram(aes(x=Length_FL,y=..density..),binwidth=BIN_SIZE)+facet_wrap(~Year,scales="free_y")
 ggsave(paste0(Fld,Sp,"_Freq_","BS",".png"))}
 
 if(nrow(G[Dataset=="UVS"])>0){
 ggplot(data=G[Dataset=="UVS"])+geom_histogram(aes(x=Length_FL,y=..density..),binwidth=BIN_SIZE)+facet_wrap(~Year,scales="free_y")
 ggsave(paste0(Fld,Sp,"_Freq_","US",".png"))}
 
 if(nrow(G[Dataset=="BBS"])>0){
 ggplot(data=G[Dataset=="BBS"])+geom_histogram(aes(x=Length_FL,y=..density..),binwidth=BIN_SIZE)+facet_wrap(~Year,scales="free_y")
 ggsave(paste0(Fld,Sp,"_Freq_","BB",".png"))}

# Prepare dataset for SS3
# Obtain mean weight and mean length per trip
 #BINS      <- seq(from=0,ceiling(max(G$Lmax)),by=BIN_SIZE)
 #BINS      <- cbind(BINS,seq(1,28,by=1))
 G         <- G[Length_FL<=Lmax]

# Add length bin lower ends to dataset
 G$LENGTH_BIN_START <- G$Length_FL-(G$Length_FL%%BIN_SIZE)

# Effective Sample size by year
 SAMPSIZE      <- G[,list(N=.N),by=list(Dataset,Year,Area_B,RW)]
 SAMPSIZE$EFFN <- SAMPSIZE$N*SAMPSIZE$RW
 SAMPSIZE      <- SAMPSIZE[,list(EFFN=sum(EFFN)),by=list(Dataset,Year)]
 #plot(SAMPSIZE$Year,SAMPSIZE$EFFN)

# Calculate abundance-at-length
 G <- G[,list(N=.N),by=list(Dataset,Year,LENGTH_BIN_START)]
 G <- G[order(Dataset,Year,LENGTH_BIN_START)]

 G <- dcast.data.table(G,Dataset+Year~LENGTH_BIN_START,value.var="N",fill=0)

 G <- merge(G,SAMPSIZE,by=c("Dataset","Year"))
 G <- select(G,Dataset,Year,EFFN,3:ncol(G))

 NList[[i]] <- NB 
 write.csv(G,paste0("Outputs/SS3_Inputs/",Sp,"/SIZE_",Sp,".csv"),row.names=F)
 
}

# Output a sample size summary (includes years with < MinN)
Summary <- do.call(rbind.data.frame, NList)
Summary <- dcast.data.table(Summary,Species+Dataset~Year,value.var="N",fill=0)
write.xlsx(Summary,"Outputs//Graphs//SIZE//Size_N_Year.xlsx")
