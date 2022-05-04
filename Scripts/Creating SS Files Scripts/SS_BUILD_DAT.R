#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOTTOMFISH - INITIAL SS FILE CREATION
#	Use example model files (from https://github.com/nmfs-stock-synthesis/user-examples) as templates 
#   for adding in American Samoa data
#	Megumi Oshima megumi.oshima@noaa.gov
#  
#  --------------------------------------------------------------------------------------------------------------

require(r4ss)
require(tidyverse)
require(this.path)
require(openxlsx)

root_dir <- this.path::here(.. = 2)
## specify species that you are creating files for. 
## If you want to do all at once can make into a loop (for i in 1:nrow(Species.List))
Species.List <- read.xlsx(file.path(root_dir, "Data", "METADATA.xlsx"), sheet = "BMUS")
species  <- Species.List$SPECIES[1]

#DAT file 
#  --------------------------------------------------------------------------------------------------------------
## STEP 1. Read in all data to be added 
# Catch data
catch        <- readRDS(file.path(root_dir, "Outputs", "CATCH_final.rds"))
# Life history data
life.history <- read.xlsx(file.path(root_dir, "Data", "LH parameters.xlsx"))
# Length comp data
#len.comp     <- readRDS(file.path(root_dir, "Outputs", "length.comp.rds"))
# CPUE data
#cpue         <- readRDS(file.path(root_dir, "Outputs", "cpue.rds"))

## STEP 2. Read in SS dat file

DAT <- r4ss::SS_readdat_3.30(file = file.path(root_dir, "SS3 models", "TEMPLATE_FILES", "data.ss"))

## STEP 3. Get data in correct format and subset
catch.sp <- catch %>% 
  filter(str_detect(SPECIES, species)) %>% 
  mutate(fleet = 1, 
         seas = 1, 
         catch_se = 0.05,
         catch = LBS/2205) %>% 
  rename("year" = YEAR) %>% 
  select(year, seas, fleet, catch, catch_se)

life.history.sp <- life.history %>% 
  filter(str_detect(SPECIES, species)) %>% 
  filter(str_detect(OPTION, "Option1"))

## STEP 4. Change inputs for dat file

DAT$Comments        <- paste("#C data file for", species, sep = " ")
DAT$styr            <- min(catch.sp$year)
DAT$endyr           <- max(catch.sp$year)
DAT$nseas           <- 1
DAT$months_per_seas <- 12
DAT$Nsubseasons     <- 2 #minimum number is 2
DAT$spawn_month     <- 1
DAT$Nsexes          <- 1 #1 ignore fraction female in ctl file, 2 use frac female in ctl file, -1 one sex and multiply spawning biomass by frac female
DAT$Nages           <- life.history.sp$AMAX
DAT$N_areas         <- 1 #if want to explore fleets as areas, change this 
DAT$Nfleets         <- 1  #include fishing fleets and surveys (only including fishery for now)
## specify the fleet types, timing, area, units, any catch multiplier and fleet name in fleetinfo
DAT$fleetinfo <- data.frame(type = c(1), surveytiming = c(-1),
                            units = c(1), need_catch_mult = c(0), 
                            fleetname = c("FISHERY"))

if(exists("catch.sp")){
  
  ## Add catch, column names: year, seas, fleet, catch, catch_se
  ## NOTE: will need to adjust if there are multiple fleets with catch
  init.catch <- data.frame(year = -999, seas = 1, fleet = 1, catch = 0, catch_se = 0.01)
  DAT$catch  <- rbind(init.catch, catch.sp) 
  
}

if(exists("cpue.sp")){
  
  ## Add CPUE info, column names: Fleet, Units, Errtype, SD_Report
  DAT$CPUEinfo
  
  ## ADD CPUE data, column names: year, seas, index, obs, se_log
  DAT$CPUE <- cpue
  
}else{
  DAT$CPUEinfo <- NULL
  DAT$CPUE <- NULL
}

if(exists("discards.sp")){
  DAT$N_discard_fleets <- unique(discards.sp$fleet)
  DAT$discard <- discards.sp
}else{
  
  ## Any discard fleets?
  DAT$N_discard_fleets <- 0
  DAT$discard <- NULL
  
}

## Composition data

if(exists("len.comp.sp")){

  ## Length Composition 
  DAT$use_lencomp              <- 1 #switch to 0 if not using length comp data 
  ## Dataframe with column names: mintailcomp, addtocomp, combine_M_F, CompressBins, CompError, ParmSelect, minsamplesize
  DAT$len_info
  DAT$N_lbins                <- length(len.comp.bins)
  DAT$lbin_vector            <- len.comp.bins
    
  ## Add length composition data, column names: Yr, Seas, FltSVy, Gender, Part, Nsamp, length_bin_values...
  DAT$lencomp                <- len.comp
    
}else{
  
  DAT$use_lencomp <- 0
  DAT$lencomp <- NULL
}

## Age Composition
if(exists("age.comp.sp")){
  
  DAT$N_agebins              <- length(agebin_vector)
  DAT$agebin_vector          <- agebin_vector
  DAT$N_ageerror_definitions <- 1
  DAT$ageerror               <- ageerror # vectors for each definition of mean age and sd associated with the mean age for each age
  ## Dataframe with column names: mintailcomp, addtocomp, combine_M_F, CompressBins, CompError, ParmSelect, minsamplesize
  DAT$age_info
  DAT$Lbin_method            <- 1 #Lbin_method_for_Age_Data, 1 = poplenbins, 2 = datalenbins, 3 = lengths
  DAT$agecomp                <- age.comp
  
}else{
  
  DAT$N_agebins              <- 0
  DAT$agecomp <- NULL
  
}

## Mean size-at-age 
if(exists("size.comp.sp")){
  
  DAT$use_MeanSize_at_Age_obs  <- 1
  DAT$MeanSize_at_Age_obs    <- mean.size.at.age # dataframe with column names: Yr, Seas, FltSvy, Gender, Part, AgeErr, Ignore, age_bins..
  
}else{
  
  DAT$use_MeanSize_at_Age_obs <- 0
  DAT$MeanSize_at_Age_obs <- NULL
  
}


DAT$use_meanbodywt           <- 0
## Population length bins
## method options include 
##      1: use data bins, no other input necessary
##      2: generate from bin width, min, and max, specify those values 
##      3: read values for length bins, specify number of length bins then lower edges of each bin
DAT$lbin_method <- 2 
if(DAT$lbin_method == 2){
  
  DAT$binwidth     <- 5
  DAT$minimum_size <- 5 #lower size of first bin
  DAT$maximum_size <- 85 #lower size of largest bin: ceiling(life.history.sp$LINF)
  
}
if(DAT$lbin_method == 3){
  
  DAT$N_lbinspop      <- length(pop.length.bins)
  DAT$lbin_vector_pop <- pop.length.bins #seq(start_bin, end_bin, by = 2)
  
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

## STEP 5. Save new dat file
r4ss::SS_writedat_3.30(DAT, outfile = file.path(root_dir, "SS3 models", paste0(species), "data.ss"), 
                       overwrite = TRUE)
