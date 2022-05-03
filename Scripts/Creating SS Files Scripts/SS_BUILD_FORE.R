#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOTTOMFISH - INITIAL SS FORECAST FILE CREATION
#	Use example model files (from https://github.com/nmfs-stock-synthesis/user-examples) as templates 
#   for forecast file
#	Megumi Oshima megumi.oshima@noaa.gov
#  
#  --------------------------------------------------------------------------------------------------------------

require(r4ss)
require(tidyverse)
require(this.path)

root_dir <- this.path::here(.. = 2)
## specify species that you are creating files for. 
## If you want to do all at once can make into a loop (for i in 1:nrow(Species.List))
species  <- Species.List[1,1]

## Forecast file
#  --------------------------------------------------------------------------------------------------------------
## STEP 1. Read in template forecast file
FORE <- r4ss::SS_readforecast(file = file.path(root_dir, "SS3 models", "TEMPLATE_FILES", "forecast.ss"))

## STEP 2. Make any necessary changes
#  --------------------------------------------------------------------------------------------------------------
## most common inputs to change:
FORE$benchmarks                         <- 1 #calculate F_spr
FORE$MSY                                <- 2 #calculate F(MSY)
FORE$SPRtarget                          <- 0.4
FORE$Btarget                            <- 0.4

#beg_bio, end_bio, beg_selex, end_selex, beg_relF, end_relF, beg_recr_dist, end_recr_dist, beg_SRparm, end_SRparm
FORE$Bmark_years                        <- c(0,0,0,0,0,0,0,0,0,0) #0 for end year, can change to actual years or relative (to end year)
FORE$Bmark_relF_Basis                   <- 1 #use year range
FORE$Forecast                           <- 1 #F(SPR)
FORE$Nforecastyrs                       <- 10

#beg_selex, end_selex, beg_relF, end_relF, beg_mean recruits, end_recruits
FORE$Fcast_years                        <- c(0,0,-10,0,-999,0)
FORE$ControlRuleMethod                  <- 0

FORE$FirstYear_for_caps_and_allocations <- endyr + 2

## STEP 3. Save updated file
#  --------------------------------------------------------------------------------------------------------------
r4ss::SS_writeforecast(FORE, dir = file.path(root_dir, "SS3 models", species),
                       writeAll = TRUE, overwrite = TRUE)