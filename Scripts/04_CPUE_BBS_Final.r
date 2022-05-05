require(dplyr); require(this.path); require(data.table); require(lunar); require(openxlsx)
options(scipen=999)		              # this option just forces R to never use scientific notation
root_dir <- this.path::here(.. = 1) # establish directories using this.path


C <- readRDS(paste0(root_dir, "/Outputs/CPUE_B.rds"))

length(unique(C$INTERVIEW_PK))

unique(C$METHOD_FK)


nrow(C[METHOD_FK==5])


unique(C$VESSEL_FK)
