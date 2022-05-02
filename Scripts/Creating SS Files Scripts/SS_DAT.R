#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOTTOMFISH - INITIAL SS FILE CREATION
#	Use example model files (from https://github.com/nmfs-stock-synthesis/user-examples) as templates 
#   for adding in American Samoa data
#	Megumi Oshima megumi.oshima@noaa.gov
#  
#  --------------------------------------------------------------------------------------------------------------

library(r4ss)
library(tidyverse)
library(this.path)

root_dir <- this.path::here(.. = 2)
## specify species that you are creating files for. 
## If you want to do all at once can make into a loop (for i in 1:nrow(Species.List))
species  <- Species.List[1,1]

#DAT file 
#  --------------------------------------------------------------------------------------------------------------
## STEP 1. Read in all data to be added 
#TODO: change names of files to actual names once the data folder is updated
# Catch data
catch        <- read.csv(file.path(root_dir, "DATA", "catch.csv"), stringsAsFactors = FALSE)
# Life history data
life.history <- read.csv(file.path(root_dir, "Outputs", "LH.csv"), stringsAsFactors = FALSE)
# Length comp data
len.comp     <- read.csv(file.path(root_dir, "DATA", "length.comp.csv"), stringsAsFactors = FALSE)
# CPUE data
cpue         <- read.csv(file.path(root_dir, "DATA", "cpue.csv"), stringsAsFactors = FALSE)

## STEP 2. Read in SS dat file

DAT <- r4ss::SS_readdat_3.30(file = file.path(root_dir, "SS3 models", "TEMPLATE_FILES", "data.ss"))

## STEP 3. Change inputs for dat file

DAT$Comments        <- paste("#C data file for", species, sep = " ")
DAT$styr            <- min(catch$year)
DAT$endyr           <- max(catch$year)
DAT$nseas           <- 1
DAT$months_per_seas <- 12
DAT$Nsubseasons     <- 2 #minimum number is 2
DAT$spawn_month     <- 1
DAT$Nsexes          <- 1 #1 ignore fraction female in ctl file, 2 use frac female in ctl file, -1 one sex and multiply spawning biomass by frac female
DAT$Nages           <- max(life.history$age[species])
DAT$N_areas         <- 1 #if want to explore fleets as areas, change this 
DAT$Nfleets         <- 3 #include fishing fleets and surveys
## specify the fleet types, timing, area, units, any catch multiplier and fleet name in fleetinfo
DAT$fleetinfo

## Add catch, column names: year, seas, fleet, catch, catch_se
## NOTE: will need to adjust if there are multiple fleets with catch
init.catch <- data.frame(year = -999, seas = 1, fleet = 1, catch = 0, catch_se = 0.01)
DAT$catch  <- rbind(init.catch, catch) 

## Add CPUE info, column names: Fleet, Units, Errtype, SD_Report
DAT$CPUEinfo

## ADD CPUE data, column names: year, seas, index, obs, se_log
DAT$CPUE <- cpue

## Any discard fleets?
DAT$N_discard_fleets <- 0

## Composition data

DAT$use_meanbodywt   <- 0
## Population length bins
## method options include 
##      1: use data bins, no other input necessary
##      2: generate from bin width, min, and max, specify those values 
##      3: read values for length bins, specify number of length bins then lower edges of each bin
DAT$lbin_method <- 2 
if(DAT$lbin_method == 2){
  
  DAT$binwidth     <- 2
  DAT$minimum_size <- 5 #lower size of first bin
  DAT$maximum_size <- 100 #lower size of largest bin
  
}
if(DAT$lbin_method == 3){
  
  DAT$N_lbinspop      <- length(pop.length.bins)
  DAT$lbin_vector_pop <- pop.length.bins #seq(start_bin, end_bin, by = 2)
  
}

## Length Composition 
DAT$use_lencomp <- 1 #switch to 0 if not using length comp data
if(DAT$use_lencomp == 1){
  
  ## Dataframe with column names: mintailcomp, addtocomp, combine_M_F, CompressBins, CompError, ParmSelect, minsamplesize
  DAT$len_info
  DAT$N_lbins     <- length(len.comp.bins)
  DAT$lbin_vector <- len.comp.bins
  
  ## Add length composition data, column names: Yr, Seas, FltSVy, Gender, Part, Nsamp, length_bin_values...
  DAT$lencomp     <- len.comp
  
}

## Age Composition
DAT$N_agebins <- 0

if(DAT$N_agebins > 0){
  
  DAT$agebin_vector          <- agebin_vector
  DAT$N_ageerror_definitions <- 1
  DAT$ageerror               <- ageerror # vectors for each definition of mean age and sd associated with the mean age for each age
  ## Dataframe with column names: mintailcomp, addtocomp, combine_M_F, CompressBins, CompError, ParmSelect, minsamplesize
  DAT$age_info
  DAT$Lbin_method            <- 1 #Lbin_method_for_Age_Data, 1 = poplenbins, 2 = datalenbins, 3 = lengths
  DAT$agecomp                <- age.comp
  
}

## Mean size-at-age 

DAT$use_MeanSize_at_Age_obs <- 0
if(DAT$use_MeanSize_at_Age_obs > 0){
  
  DAT$MeanSize_at_Age_obs <- mean.size.at.age # dataframe with column names: Yr, Seas, FltSvy, Gender, Part, AgeErr, Ignore, age_bins..
  
}

## Environmental variables 
DAT$N_environ_variables    <- 0
## Generalized size comp data
DAT$N_sizefreq_methods     <- 0
## Tagging data
DAT$do_tags                <- 0 
## Morph composition data
DAT$morphcomp_data         <- 0
## Selectivity empirical data (future feature)
DAT$use_selectivity_priors <- 0

## STEP 4. Save new dat file
r4ss::SS_writedat_3.30(DAT, outfile = file.path(root_dir, "SS3 models", paste0(species), "data.ss"), 
                       overwrite = TRUE)