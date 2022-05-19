require(this.path); root_dir <- this.path::here(..=1)

# Creates outputs folder structure, if necessary
dir.create(file.path(root_dir, "Outputs"))

dir.create(file.path(root_dir, "Outputs/LBSPR"))
dir.create(file.path(root_dir, "Outputs/LBSPR/Graphs"))
dir.create(file.path(root_dir, "Outputs/LBSPR/Temp size"))

dir.create(file.path(root_dir, "Outputs/SS3_Inputs"))
dir.create(file.path(root_dir, "Outputs/SS3_Inputs/CPUE"))

dir.create(file.path(root_dir, "Outputs/Summary"))
dir.create(file.path(root_dir, "Outputs/Summary/CPUE figures"))
dir.create(file.path(root_dir, "Outputs/Summary/Size figures"))

# Run all CATCH and CPUE data processing scripts and export catch files for input into SS
source(paste0(root_dir,"/Scripts/01_CPUE_BBS_InitPrep.r"));       rm(list=setdiff(ls(), "root_dir"))
source(paste0(root_dir,"/Scripts/02_CPUE_BBS_PropTable.r"));      rm(list=setdiff(ls(), "root_dir")) 
source(paste0(root_dir,"/Scripts/03a_CPUE_BBS_Wind.r"));     rm(list=setdiff(ls(), "root_dir"))
source(paste0(root_dir,"/Scripts/03b_CPUE_BBS_PCA.r"));      rm(list=setdiff(ls(), "root_dir")) 
source(paste0(root_dir,"/Scripts/04_CPUE_BBS_FinalPrep.r")); rm(list=setdiff(ls(), "root_dir"))
source(paste0(root_dir,"/Scripts/05_CPUE_BBS_Standardize_Function.r"))
source(paste0(root_dir,"/Scripts/06_CATCH_BBS_FinalPrep.r")); rm(list=setdiff(ls(), "root_dir")) 
source(paste0(root_dir,"/Scripts/07_CATCH_SBS_PropTable.r")); rm(list=setdiff(ls(), "root_dir")) 
source(paste0(root_dir,"/Scripts/08_CATCH_SBS_FinalPrep.r")); rm(list=setdiff(ls(), "root_dir"))
source(paste0(root_dir,"/Scripts/09_CATCH_Final.r")); rm(list=setdiff(ls(), "root_dir"))
source(paste0(root_dir,"/Scripts/10_SIZE.r"));                rm(list=setdiff(ls(), "root_dir")) 


# Run CPUE standardization and export indices for input into SS
source(paste0(root_dir,"/Scripts/05_CPUE_BBS_Standardize_Function.r"))

Species.List <- c("APRU", "APVI", "CALU", "LERU", "LUKA", "ETCO", "PRFL", "PRZO", "VALO")
Area.List    <- c("Tutuila","Manua")

# Run CPUE standardization for all species and areas in a loop
for(i in 1:length(Species.List)){
  for(j in 1:length(Area.List)){
    Standardize_CPUE(Sp=Species.List[i],Ar=Area.List[j])
  }
}

# Run a single model
Standardize_CPUE(Sp = "APRU" , Ar = c("Tutuila","Manua") [2])


#Sp<-"APRU"
#Ar<-"Manua" 
#minYr=1988
#maxYr=2021