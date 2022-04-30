require(this.path)

root_dir <- this.path::here(.. = 1) # establish directories using this.path


source(paste0(root_dir,"/Scripts/01_CPUE_BBS_Prep.r"))
source(paste0(root_dir,"/Scripts/02_CPUE_BBS_Wind.r"))
source(paste0(root_dir,"/Scripts/03_CPUE_BBS_PropTable.r"))
source(paste0(root_dir,"/Scripts/04_CATCH_BBS_Prep.r"))
source(paste0(root_dir,"/Scripts/05_CATCH_SBS_PropTable.r"))
source(paste0(root_dir,"/Scripts/06_CATCH_SBS_Prep.r"))
source(paste0(root_dir,"/Scripts/07_SIZE.r"))



