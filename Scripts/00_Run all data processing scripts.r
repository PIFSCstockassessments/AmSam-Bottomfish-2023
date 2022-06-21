# Check if all required packages are installed, and install if not. Note: You need r4ss v.1.44.0 and ss3diags obtained from github repos.
require(pacman)
pacman::p_load(boot,data.table,ggfortify,grid,gridExtra,directlabels,mgcv,ncdf4,httr,lubridate,lunar,purrr,googledrive,googlesheets4,RColorBrewer,tidyverse,this.path,viridis,r4ss,nFactors,openxlsx)

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

########## PROCESS CATCH AND CPUE DATA ################
source(paste0(here(..=1),"/Scripts/01_CPUE_BBS_InitPrep.r"));   rm(list=ls())
source(paste0(here(..=1),"/Scripts/02_CPUE_BBS_PropTable.r"));  rm(list=ls()) 
source(paste0(here(..=1),"/Scripts/03a_CPUE_BBS_Wind.r"));      rm(list=ls())
source(paste0(here(..=1),"/Scripts/03b_CPUE_BBS_PCA.r"));       rm(list=ls()) 
source(paste0(here(..=1),"/Scripts/04_CPUE_BBS_FinalPrep.r"));  rm(list=ls())
source(paste0(here(..=1),"/Scripts/06_CATCH_BBS_FinalPrep.r")); rm(list=ls()) 
source(paste0(here(..=1),"/Scripts/07_CATCH_SBS_PropTable.r")); rm(list=ls()) 
source(paste0(here(..=1),"/Scripts/08_CATCH_SBS_FinalPrep.r")); rm(list=ls())
source(paste0(here(..=1),"/Scripts/09_CATCH_Final.r"));         rm(list=ls())
source(paste0(here(..=1),"/Scripts/10_SIZE.r"));                rm(list=ls()) 

################ RUN CPUE STANDARDIZATION############################
# Run CPUE standardization and export indices for input into SS
source(paste0(here(..=1),"/Scripts/05_CPUE_BBS_Standardize_Function.r"))

Species.List <- c("APRU", "APVI", "CALU", "LERU", "LUKA", "ETCO", "PRFL", "PRZO", "VALO")
Area.List    <- c("Tutuila","Manua")

# Run CPUE standardization for all species and areas in a loop
for(i in 1:length(Species.List)){
  for(j in 1:length(Area.List)){
    Standardize_CPUE(Sp=Species.List[i],Ar=Area.List[j])
  }
}

# Or run a single model
Standardize_CPUE(Sp = "APVI" , Ar = c("Tutuila","Manua") [2])
#Sp<-"LERU"; Ar<-"Tutuila"; minYr=1988; maxYr=2021


