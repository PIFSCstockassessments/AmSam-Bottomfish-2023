require(dplyr); require(this.path); require(data.table);require(openxlsx)
options(scipen=999)		              # this option just forces R to never use scientific notation
root_dir <- this.path::here(.. = 1) # establish directories using this.path

# Base processed data
C <- readRDS(paste0(root_dir, "/Outputs/CPUE_B.rds")); length(unique(C$INTERVIEW_PK))

# Only select Bottomfishing (Method_FK==4) trips. Given that BTM includes hours spent trolling.
C <- C[METHOD_FK==4]; length(unique(C$INTERVIEW_PK))

# Make sure HOURS_FISHED is available and exclude some extreme NUM_GEAR values
C <- C[HOURS_FISHED>0&(NUM_GEAR>0&NUM_GEAR<20)]; length(unique(C$INTERVIEW_PK))

# Check that covariates don't have NAs or other weird values
table(C$TYPE_OF_DAY,exclude=NULL)
table(C$MONTH,exclude=NULL)
table(C$PROP_UNID,exclude=NULL) # Note: the NAs are interviews with no BMUS or potential group BMUS catch
table(C$AREA_C)

# Check the range of catch values
range(C$EST_LBS)
C[EST_LBS==687.348] # 10 hours fishing, unidentified snappers (Code 230)

# Windspeed missing here...
length(unique(C[is.na(WINDSPEED)]$INTERVIEW_PK)) # 385 interviews are missing Windspeed
table((C[is.na(WINDSPEED)]$AREA_C))
table((C[is.na(WINDSPEED)]$YEAR))

# Select final covariates for CPUE standardization
length(unique(C$INTERVIEW_PK))
C <- select(C,INTERVIEW_PK,YEAR,MONTH,TYPE_OF_DAY,AREA_C,WINDSPEED,PROP_UNID,BMUS,SPECIES_FK,HOURS_FISHED,NUM_GEAR,EST_LBS)






