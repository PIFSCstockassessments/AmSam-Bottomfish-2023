require(tidyverse); require(this.path); require(data.table);require(openxlsx)
options(scipen=999)		              # this option just forces R to never use scientific notation
root_dir <- this.path::here(.. = 2) # establish directories using this.path

# Base processed data
C <- readRDS(paste0(root_dir, "/Outputs/CPUE_B.rds")); length(unique(C$INTERVIEW_PK))

# Only select Bottomfishing (Method_FK==4) trips. Given that BTM includes hours spent trolling.
C <- C[METHOD_FK==4]; length(unique(C$INTERVIEW_PK))

# Remove years 1986-1987, most data collected in groups.
C <- C[YEAR>=1988]; length(unique(C$INTERVIEW_PK))

# Make sure HOURS_FISHED is available and exclude some extreme NUM_GEAR values
C <- C[HOURS_FISHED>0&(NUM_GEAR>0&NUM_GEAR<20)]; length(unique(C$INTERVIEW_PK))

# Add windspeed information
W <- readRDS(paste0(root_dir,"/Outputs/CPUE_WIND.rds"))
C <- merge(C,W,by="INTERVIEW_PK",all.x=T)

length(unique(C$INTERVIEW_PK))
length(unique(C[is.na(WINDSPEED)]$INTERVIEW_PK)) # no interview is missing Windspeed

# Add PCs targeting information
PC <- readRDS(paste0(root_dir,"/Outputs/CPUE_PCA.rds"))
C  <- merge(C,PC,by="INTERVIEW_PK",all.x=T)

length(unique(C$INTERVIEW_PK))
length(unique(C[is.na(PC1)]$INTERVIEW_PK)) # No interviews are missing PCs

# Fill all interviews with zero catches for all species
S <- C[,list(N=.N),by=list(BMUS,SPECIES_FK)]
S <- select(S,-N)

C <- C[,list(EST_LBS=sum(EST_LBS)),by=list(INTERVIEW_PK,YEAR,SEASON,MONTH,TYPE_OF_DAY,AREA_C,WINDSPEED,VESSEL_REGIST_NO,PROP_UNID,PC1,PC2,PC3,PC4,SPECIES_FK,HOURS_FISHED,NUM_GEAR)]
C <- dcast(C,INTERVIEW_PK+YEAR+SEASON+MONTH+TYPE_OF_DAY+AREA_C+WINDSPEED+VESSEL_REGIST_NO+PROP_UNID+PC1+PC2+PC3+PC4+HOURS_FISHED+NUM_GEAR~SPECIES_FK,value.var="EST_LBS",fill=0)
C <- melt(C,id.vars=1:15,value.name="EST_LBS",variable.name="SPECIES_FK")
C <- data.table(C); length(unique(C$INTERVIEW_PK))

# Only keep the bmus species (we don't need the rest after the PCA analysis is done)
C <- merge(C,S,by="SPECIES_FK")
C <- C[BMUS=="BMUS_Species"]

C <- C[,list(EST_LBS=sum(EST_LBS)),by=list(INTERVIEW_PK,YEAR,SEASON,MONTH,TYPE_OF_DAY,AREA_C,WINDSPEED,VESSEL_REGIST_NO,PROP_UNID,PC1,PC2,PC3,PC4,SPECIES_FK,HOURS_FISHED,NUM_GEAR)]
C <- C[order(YEAR,MONTH,TYPE_OF_DAY,AREA_C,INTERVIEW_PK,SPECIES_FK)]

setnames(C,"EST_LBS","CPUE")

C$YEAR         <- as.character(C$YEAR)
C$MONTH        <- as.character(C$MONTH)
C$PRES         <- ifelse(C$CPUE>0,1,0)
C$SPECIES_FK   <- as.character(C$SPECIES_FK)

length(unique(C$INTERVIEW_PK))

# Remove an extreme outlier for PRZO
C <- C[!(INTERVIEW_PK==890819113004&SPECIES_FK==245)]

saveRDS(C,paste0(root_dir,"/Outputs/CPUE_C.rds"))

# Create some nominal CPUE graphs

C$PERIOD <- as.numeric(C$YEAR) - (as.numeric(C$YEAR) %% 5)

X <- C[AREA_C=="Tutuila",list(CPUE=mean(CPUE)),by=list(SPECIES_FK,PERIOD)]
X <- X[order(SPECIES_FK,PERIOD)]

Sp <- read.xlsx(paste0(root_dir, "/Data/METADATA.xlsx"),sheet="BMUS")
Sp <- select(Sp,SPECIES_PK,SPECIES)
Sp$SPECIES_PK <- as.character(Sp$SPECIES_PK)

X <- merge(X,Sp,by.x="SPECIES_FK",by.y="SPECIES_PK")

ggplot(data=X,aes(x=PERIOD,y=CPUE))+geom_bar(stat="identity")+facet_wrap(~SPECIES,scales="free_y")
ggsave(last_plot(),file=paste0(root_dir, "/Outputs/Summary/CPUE_Nominal.png"),widt=8,height=8)













