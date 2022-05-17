require(this.path)


# Creates outputs folder structure, if necessary
root_dir <- this.path::here(..=1)
dir.create(file.path(root_dir, "Outputs"))
dir.create(file.path(root_dir, "Outputs/Graphs"))
dir.create(file.path(root_dir, "Outputs/Graphs/Size"))
dir.create(file.path(root_dir, "Outputs/LBSPR"))
dir.create(file.path(root_dir, "Outputs/LBSPR/Graphs"))
dir.create(file.path(root_dir, "Outputs/LBSPR/Temp size"))


source(paste0(this.path::here(.. = 1),"/Scripts/01_CPUE_BBS_InitPrep.r"));       rm(list=ls()) 
source(paste0(this.path::here(.. = 1),"/Scripts/02_CPUE_BBS_PropTable.r"));       rm(list=ls()) 
source(paste0(this.path::here(.. = 1),"/Scripts/03a_CPUE_BBS_Wind.r"));  rm(list=ls()) 
source(paste0(this.path::here(.. = 1),"/Scripts/03b_CPUE_BBS_PCA.r"));      rm(list=ls()) 
source(paste0(this.path::here(.. = 1),"/Scripts/04_CPUE_BBS_FinalPrep.r")); rm(list=ls()) 
source(paste0(this.path::here(.. = 1),"/Scripts/05a_CPUE_BBS_Standardize_Function.r"));      rm(list=ls()) 
source(paste0(this.path::here(.. = 1),"/Scripts/05b_Standardize.r"));         rm(list=ls()) 
source(paste0(this.path::here(.. = 1),"/Scripts/08_SIZE.r"));                rm(list=ls()) 



