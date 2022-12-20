# Check if all required packages are installed, and install if not. Note: You need r4ss v.1.44.0 and ss3diags obtained from github repos.
require(pacman)
pacman::p_load(boot,data.table,ggfortify,ggpubr,grid,gridExtra,directlabels,mgcv,ncdf4,httr,
               lubridate,lunar,purrr,googledrive,googlesheets4,tidyverse,tinytex,this.path,nFactors,openxlsx)

# Need these specializes packages: r4ss v1.46.1 and ss3diags v2.0.3.9000 (branch "ndd" for now) 
#remotes::install_github("r4ss/r4ss")
#remotes::install_github("PIFSCstockassessments/ss3diags",ref="ndd")


########## DOWNLOAD DATA FROM GOOGLE DRIVE ###############
# Check latest data from Google Drive but only download if its more recent than on local repo
a                  <- drive_reveal(drive_ls(path="https://drive.google.com/drive/u/1/folders/1pnH38cupmDU4O_KkKDhYWee_p4sTSD6u", pattern="Data"), what = "modified_time")
a                  <- arrange(a, by = desc(modified_time))[1,] # Select most recent "Data" zip file
if(dir.exists(file.path(here(..=1),"Data"))){
         Date.CurrentFolder <- as_datetime(file.info(paste0(file.path(here(..=1)),"/Data"))$mtime)
} else { Date.CurrentFolder <- "1900-01-01 01:01:01 UTC" }
  
Date.GoogleFolder <- as_datetime(map_chr(a$drive_resource, "modifiedTime"))
  if(Date.CurrentFolder<Date.GoogleFolder){
    drive_download(file=a$id, overwrite = TRUE, path = file.path(here(..=1),a$name) )
    unzip(file.path(here(..=1),a$name),exdir=here(..=1))  
    }          

########## PROCESS CATCH, CPUE, AND SIZE DATA ################
set.seed(123); source(paste0(here(..=1),"/Scripts/01_Data scripts/01_CPUE_BBS_InitPrep.r"));   rm(list=ls())
source(paste0(here(..=1),"/Scripts/01_Data scripts/02_CPUE_BBS_PropTable.r"));  rm(list=ls()) 
source(paste0(here(..=1),"/Scripts/01_Data scripts/03a_CPUE_BBS_Wind.r"));      rm(list=ls())
source(paste0(here(..=1),"/Scripts/01_Data scripts/03b_CPUE_BBS_PCA.r"));       rm(list=ls()) 
source(paste0(here(..=1),"/Scripts/01_Data scripts/04_CPUE_BBS_FinalPrep.r"));  rm(list=ls())
source(paste0(here(..=1),"/Scripts/01_Data scripts/06_CATCH_BBS_FinalPrep.r")); rm(list=ls()) 
set.seed(123); source(paste0(here(..=1),"/Scripts/01_Data scripts/07_CATCH_SBS_PropTable.r")); rm(list=ls()) 
source(paste0(here(..=1),"/Scripts/01_Data scripts/08_CATCH_SBS_FinalPrep.r")); rm(list=ls())
source(paste0(here(..=1),"/Scripts/01_Data scripts/09_CATCH_Final.r"));         rm(list=ls())
source(paste0(here(..=1),"/Scripts/01_Data scripts/10_SIZE.r"));                rm(list=ls()) 

################ RUN CPUE STANDARDIZATION############################
# Run CPUE standardization and export indices for input into SS
#source(paste0(here(..=1),"/Scripts/05_CPUE_BBS_Standardize_Function.r"))
source(paste0(here(..=1),"/Scripts/01_Data scripts/05_CPUE_BBS_Standardize_Function2.r"))
root_dir <- root_dir <- this.path::here(.. = 1) # establish directories using this.path

Species.List <- c("APRU","APVI","CALU","ETCO","LERU","LUKA","PRFL","PRZO","VALO")
Area.List    <- c("Tutuila","Manua")

# Run CPUE standardization for all species and areas in a loop
#for(i in 1:length(Species.List)){
#  for(j in 1:length(Area.List)){
#    Standardize_CPUE(Sp=Species.List[i],Ar=Area.List[j])
#  }
#}

# Run CPUE standardization for all species, areas combined in a loop
for(i in 1:length(Species.List)){
    Standardize_CPUE2(Sp=Species.List[i],Interaction=T,minYr=2016,maxYr=2021)
}


# Or run a single model
#Standardize_CPUE(Sp = "APRU" , Ar = c("Tutuila","Manua") [1])
Standardize_CPUE2(Sp = "VALO",Interaction=T,minYr=2016,maxYr=2021)
Standardize_CPUE2(Sp = "PRFL",Interaction=T,minYr=2016,maxYr=2021)
Sp<-"APRU"; Ar<-"Tutuila"; minYr=2016; maxYr=2021; Interaction<-T


