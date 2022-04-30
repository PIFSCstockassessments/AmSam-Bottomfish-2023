require(this.path)


# Necessary folders




source(paste0(this.path::here(.. = 1),"/Scripts/01_CPUE_BBS_Prep.r"));       rm(list=ls()) 
source(paste0(this.path::here(.. = 1),"/Scripts/02_CPUE_BBS_Wind.r"));       rm(list=ls()) 
source(paste0(this.path::here(.. = 1),"/Scripts/03_CPUE_BBS_PropTable.r"));  rm(list=ls()) 
source(paste0(this.path::here(.. = 1),"/Scripts/04_CATCH_BBS_Prep.r"));      rm(list=ls()) 
source(paste0(this.path::here(.. = 1),"/Scripts/05_CATCH_SBS_PropTable.r")); rm(list=ls()) 
source(paste0(this.path::here(.. = 1),"/Scripts/06_CATCH_SBS_Prep.r"));      rm(list=ls()) 
source(paste0(this.path::here(.. = 1),"/Scripts/07_SIZE.r"));                rm(list=ls()) 



