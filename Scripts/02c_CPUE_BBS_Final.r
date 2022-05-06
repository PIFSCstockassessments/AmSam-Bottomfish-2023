require(dplyr); require(this.path); require(data.table);require(openxlsx)
options(scipen=999)		              # this option just forces R to never use scientific notation
root_dir <- this.path::here(.. = 1) # establish directories using this.path

# Base processed data
C <- readRDS(paste0(root_dir, "/Outputs/CPUE_A.rds")); length(unique(C$INTERVIEW_PK))

# Only select Bottomfishing (Method_FK==4) trips. Given that BTM includes hours spent trolling.
C <- C[METHOD_FK==4]; length(unique(C$INTERVIEW_PK))

# Add windspeed information
W <- readRDS(paste0(root_dir,"/Outputs/CPUE_WIND.rds"))
C <- merge(C,W,by="INTERVIEW_PK",all.x=T)

length(unique(C$INTERVIEW_PK))
length(unique(C[is.na(WINDSPEED)]$INTERVIEW_PK)) # 385 interviews are missing Windspeed
table((C[is.na(WINDSPEED)]$AREA_C))
table((C[is.na(WINDSPEED)]$YEAR))

# Add PCs targeting information
PC <- readRDS(paste0(root_dir,"/Outputs/CPUE_PCA.rds"))
C  <- merge(C,PC,by="INTERVIEW_PK",all.x=T)

length(unique(C$INTERVIEW_PK))
length(unique(C[is.na(PC1)]$INTERVIEW_PK)) # No interviews are missing PCs

# Select final covariates for CPUE standardization
length(unique(C$INTERVIEW_PK))

C <- select(C,INTERVIEW_PK,YEAR,MONTH,TYPE_OF_DAY,AREA_C,WINDSPEED,PROP_UNID,BMUS,SPECIES_FK,HOURS_FISHED,NUM_GEAR,EST_LBS)
C <- C[order(YEAR,MONTH,TYPE_OF_DAY,AREA_C,SPECIES_FK)]

saveRDS(C,paste0(root_dir,"/Outputs/CPUE_B.rds"))



