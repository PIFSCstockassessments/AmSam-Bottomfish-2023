require(data.table); require(ggplot2); require(gridExtra); require(directlabels);require(openxlsx); require(ggpmisc);require(directlabels);

# Load diver sizes
US <- readRDS("Outputs\\readyUVS.rds")
US <- US[Area_A!="Rose"&Area_A!="Swains"]

US$Length_TL <- US$Length_TL/10 # Convert to cm

# Load biosampling sizes
BS <- readRDS("Outputs\\readyBiosamp.rds")
BS <- BS[!is.na(Length_FL)]
BS$Length_FL <- BS$Length_FL/10 # Convert to cm

# Load BBS sizes
BB <- readRDS("Outputs\\readyBBS_Size.rds")






# Explore sample size by island, year, species
SPECIES.CODE         <- data.table(  read.xlsx("DATA/METADATA.xlsx",sheet="SPECIES")  )
SPECIES.CODE         <- subset(SPECIES.CODE,select=c("Species"))
N                    <- merge(US,SPECIES.CODE,by="Species")

# Samples by area
A     <- N[,list(N=sum(Count)),by=list(Species,Area_A)]
A     <- A[order(Species,-N)]
Max.y <- max(A[Area_A!="N/A"]$N)*1.3
