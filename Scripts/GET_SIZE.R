require(data.table); require(ggplot2); require(gridExtra); require(directlabels);require(openxlsx); require(ggpmisc);require(directlabels);

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
Sp <- "VALO"
E  <- D[Species==Sp&Length_FL>0]
table(E$Dataset,E$Year)

ggplot(data=E[Dataset=="Biosampling"])+geom_histogram(aes(x=Length_FL))+facet_wrap(~Year)
ggplot(data=E[Dataset=="UVS"])+geom_histogram(aes(x=Length_FL))+facet_wrap(~Year)
ggplot(data=E[Dataset=="BBS"])+geom_histogram(aes(x=Length_FL))+facet_wrap(~Year)

# Prepare dataset for SS3
E <- E[Dataset=="Biosampling"]
BIN_SIZE  <- 3 # in cm
MAXL      <- ceiling(max(E$Lmax))

# Obtain mean weight and mean length per trip
BINS      <- seq(0,MAXL,by=BIN_SIZE)
BINS      <- cbind(BINS,seq(1,28,by=1))
E         <- E[Length_FL<=MAXL]

# Add length bin lower ends to dataset
E$LENGTH_BIN_START <- E$Length_FL-(E$Length_FL%%BIN_SIZE)

# Effective Sample size by year
SAMPSIZE      <- E[Count==1,list(N=.N),by=list(Year,Area_B,RW)]
SAMPSIZE$EFFN <- SAMPSIZE$N*SAMPSIZE$RW
SAMPSIZE      <- SAMPSIZE[,list(EFFN=sum(EFFN)),by=list(Year)]
plot(SAMPSIZE$Year,SAMPSIZE$EFFN)

# Calculate abundance-at-length
E <- E[Count==1,list(Count=sum(Count)),by=list(Year,LENGTH_BIN_START)]
E <- E[order(Year,LENGTH_BIN_START)]

E <- dcast.data.table(E,Year~LENGTH_BIN_START,value.var="Count",fill=0)

E <- merge(E,SAMPSIZE,by="Year")
E <- select(E,Year,EFFN,2:ncol(E))




