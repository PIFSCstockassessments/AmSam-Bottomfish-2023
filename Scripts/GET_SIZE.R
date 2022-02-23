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



# Explore sample size by island, year, species
SPECIES.CODE         <- data.table(  read.xlsx("DATA/METADATA.xlsx",sheet="SPECIES")  )
SPECIES.CODE         <- subset(SPECIES.CODE,select=c("Species"))
N                    <- merge(US,SPECIES.CODE,by="Species")

# Samples by area
A     <- N[,list(N=sum(Count)),by=list(Species,Area_A)]
A     <- A[order(Species,-N)]
Max.y <- max(A[Area_A!="N/A"]$N)*1.3
