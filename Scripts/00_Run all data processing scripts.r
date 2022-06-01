require(pacman)

# Check if all required packages are installed, and install if not.
pacman::p_load(boot,data.table,ggfortify,grid,gridExtra,directlabels,mgcv,ncdf4,httr,lunar,purrr,googledrive,googlesheets4,RColorBrewer,tidyverse,this.path,viridis)

# Download latest data from Google Drive
a <- drive_ls(path="https://drive.google.com/drive/u/1/folders/1pnH38cupmDU4O_KkKDhYWee_p4sTSD6u", pattern="Data",order_by = "recency desc")
a <- a[1,] # Select most recent "Data" zip file
drive_download(file=a$id, overwrite = TRUE, path = a$name )

# Only unzip the Data zip file if it's more recent (if not, this could replace more recent data!)
Date.CurrentFolder <- as_datetime(file.info(paste0(file.path(here(..=1)),"/Data"))$mtime)
Date.GoogleFolder  <- as_datetime(map_chr(a$drive_resource, "modifiedTime"))
if(Date.CurrentFolder<Date.GoogleFolder)  unzip(a$name)  

# Creates outputs folder structure, if necessary
dir.create(file.path(here(..=1), "Outputs"))
dir.create(file.path(here(..=1), "Outputs/LBSPR"))
dir.create(file.path(here(..=1), "Outputs/LBSPR/Graphs"))
dir.create(file.path(here(..=1), "Outputs/LBSPR/Temp size"))
dir.create(file.path(here(..=1), "Outputs/SS3_Inputs"))
dir.create(file.path(here(..=1), "Outputs/SS3_Inputs/CPUE"))
dir.create(file.path(here(..=1), "Outputs/Summary"))
dir.create(file.path(here(..=1), "Outputs/Summary/CPUE figures"))
dir.create(file.path(here(..=1), "Outputs/Summary/Size figures"))

# Run all CATCH and CPUE data processing scripts and export catch files for input into SS
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
Standardize_CPUE(Sp = "APVI" , Ar = c("Tutuila","Manua") [1])


#Sp<-"LERU"
#Ar<-"Tutuila" 
#minYr=1988
#maxYr=2021
