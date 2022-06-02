require(pacman)

# Check if all required packages are installed, and install if not.
pacman::p_load(boot,data.table,ggfortify,grid,gridExtra,directlabels,mgcv,ncdf4,httr,lubridate,lunar,purrr,googledrive,googlesheets4,RColorBrewer,tidyverse,this.path,viridis)

# Check latest data from Google Drive but only download if its more recent than on local repo
a                  <- drive_ls(path="https://drive.google.com/drive/u/1/folders/1pnH38cupmDU4O_KkKDhYWee_p4sTSD6u", pattern="Data", order_by="recency desc")
a                  <- a[1,] # Select most recent "Data" zip file
Date.CurrentFolder <- as_datetime(file.info(paste0(file.path(here(..=1)),"/Data"))$mtime)
Date.GoogleFolder  <- as_datetime(map_chr(a$drive_resource, "modifiedTime"))
if(Date.CurrentFolder<Date.GoogleFolder){
  drive_download(file=a$id, overwrite = TRUE, path = a$name )
  unzip(a$name)                         }

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

# Script for build_all_ss function
source(paste0(here(..=1),"/Scripts/11_BUILD_SS3_MODEL.R"))

# Build and run models for all species in a loop
Species.List <- c("APRU", "APVI", "CALU", "LERU", "LUKA", "ETCO", "PRFL", "PRZO", "VALO")
for(i in seq_along(Species.List)){
  
  species <- Species.List[i]
  
  build_all_ss(species,
               scenario = "base",
               fleets = 1,
               M_option = "Option1",
               SR_option = "Option1",
               Q_option = "Option1",
               LSEL_option = "Option1",
               ASEL_option = "Option1",
               includeCPUE = TRUE,
               init_values = 0, 
               parmtrace = 0,
               N_boot = 1,
               last_est_phs = 10,
               seed = 0123,
               benchmarks = 1,
               MSY = 2,
               SPR.target = 0.4,
               Btarget = 0.4,
               Bmark_years = c(0,0,0,0,0,0,0,0,0,0),
               Bmark_relF_Basis = 1,
               Forecast = 1,
               Nforeyrs = 10, 
               Fcast_years = c(0,0,-10,0,-999,0),
               ControlRule = 0,
               root_dir = this.path::here(.. = 1),
               file_dir = scenario,
               template_dir = file.path(root_dir, "SS3 models", "TEMPLATE_FILES"), 
               out_dir = file.path(root_dir, "SS3 models"),
               runmodels = TRUE,
               ext_args = "-stopph 3 -nohess",
               printreport = FALSE)
}


# Or run for a single species
build_all_ss(species = "APRU",
             scenario = "base",
             fleets = 1,
             M_option = "Option1",
             SR_option = "Option1",
             Q_option = "Option1",
             LSEL_option = "Option1",
             ASEL_option = "Option1",
             includeCPUE = TRUE,
             init_values = 0, 
             parmtrace = 0,
             N_boot = 1,
             last_est_phs = 10,
             seed = 0123,
             benchmarks = 1,
             MSY = 2,
             SPR.target = 0.4,
             Btarget = 0.4,
             Bmark_years = c(0,0,0,0,0,0,0,0,0,0),
             Bmark_relF_Basis = 1,
             Forecast = 1,
             Nforeyrs = 10, 
             Fcast_years = c(0,0,-10,0,-999,0),
             ControlRule = 0,
             root_dir = this.path::here(.. = 1),
             file_dir = "base",
             template_dir = file.path(root_dir, "SS3 models", "TEMPLATE_FILES"), 
             out_dir = file.path(root_dir, "SS3 models"),
             runmodels = TRUE,
             ext_args = "-stopph 3 -nohess",
             printreport = FALSE)
