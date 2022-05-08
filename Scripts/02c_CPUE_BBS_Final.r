require(dplyr); require(this.path); require(data.table);require(openxlsx)
options(scipen=999)		              # this option just forces R to never use scientific notation
root_dir <- this.path::here(.. = 1) # establish directories using this.path

# Base processed data
C <- readRDS(paste0(root_dir, "/Outputs/CPUE_A.rds")); length(unique(C$INTERVIEW_PK))

# Only select Bottomfishing (Method_FK==4) trips. Given that BTM includes hours spent trolling.
C <- C[METHOD_FK==4]; length(unique(C$INTERVIEW_PK))

# Remove years 1986-1987, most data collected in groups.
C <- C[YEAR>=1988]

# Add windspeed information
W <- readRDS(paste0(root_dir,"/Outputs/CPUE_WIND.rds"))
C <- merge(C,W,by="INTERVIEW_PK",all.x=T)

length(unique(C$INTERVIEW_PK))
length(unique(C[is.na(WINDSPEED)]$INTERVIEW_PK)) # 386 interviews are missing Windspeed
table((C[is.na(WINDSPEED)]$AREA_C))
table((C[is.na(WINDSPEED)]$YEAR))

# Add PCs targeting information
PC <- readRDS(paste0(root_dir,"/Outputs/CPUE_PCA.rds"))
C  <- merge(C,PC,by="INTERVIEW_PK",all.x=T)

length(unique(C$INTERVIEW_PK))
length(unique(C[is.na(PC1)]$INTERVIEW_PK)) # No interviews are missing PCs

# Select final covariates for CPUE standardization
length(unique(C$INTERVIEW_PK))

# Fill all interviews with zero catches for all species
S <- C[,list(N=.N),by=list(BMUS,SPECIES_FK)]
S <- select(S,-N)

C <- C[,list(EST_LBS=sum(EST_LBS)),by=list(INTERVIEW_PK,YEAR,MONTH,TYPE_OF_DAY,AREA_C,WINDSPEED,PROP_UNID,PC1,PC2,PC3,PC4,BMUS,SPECIES_FK,HOURS_FISHED,NUM_GEAR)]
C <- dcast(C,INTERVIEW_PK+YEAR+MONTH+TYPE_OF_DAY+AREA_C+WINDSPEED+PROP_UNID+PC1+PC2+PC3+PC4+HOURS_FISHED+NUM_GEAR~SPECIES_FK,value.var="EST_LBS",fill=0)
C <- melt(C,id.vars=1:13,value.name="EST_LBS",variable.name="SPECIES_FK")
C <- data.table(C)

# Only keep the bmus species (we don't need the rest after the PCA analysis is done)
C <- merge(C,S,by="SPECIES_FK")
C <- C[BMUS=="BMUS_Species"]

C <- C[,list(EST_LBS=sum(EST_LBS)),by=list(INTERVIEW_PK,YEAR,MONTH,TYPE_OF_DAY,AREA_C,WINDSPEED,PROP_UNID,PC1,PC2,PC3,PC4,SPECIES_FK,HOURS_FISHED,NUM_GEAR)]
C <- C[order(YEAR,MONTH,TYPE_OF_DAY,AREA_C,SPECIES_FK)]

setnames(C,"EST_LBS","CPUE")

# Set up factors correctly
C$YEAR         <- as.factor(C$YEAR)
C$YEAR         <- fct_reorder(C$YEAR,as.numeric(C$YEAR),min)
C$TYPE_OF_DAY  <- as.factor(C$TYPE_OF_DAY)
C$AREA_C       <- as.factor(C$AREA_C)
C$PRES         <- ifelse(C$CPUE>0,1,0)
C$MONTH        <- as.factor(C$MONTH)
C$SPECIES_FK   <- as.character(C$SPECIES_FK)

length(unique(C$INTERVIEW_PK))
saveRDS(C,paste0(root_dir,"/Outputs/CPUE_B.rds"))



