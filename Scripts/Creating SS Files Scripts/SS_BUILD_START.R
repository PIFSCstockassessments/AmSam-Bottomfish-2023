#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOTTOMFISH - INITIAL SS STARTER FILE CREATION
#	Use example model files (from https://github.com/nmfs-stock-synthesis/user-examples) as templates 
#   for starter file
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

## Starter file
#  --------------------------------------------------------------------------------------------------------------
## STEP 1. Read in template starter file

START <- r4ss::SS_readstarter(file = file.path(root_dir, "SS3 models", "TEMPLATE_FILES", "starter.ss"))

## STEP 2. Make any changes necessary
#  --------------------------------------------------------------------------------------------------------------
## most likely changes are listed below: 
START$datfile <- "data.ss"
START$ctlfile <- "control.ss"
START$init_values_src <- 0 #switch 1 if want to use parameter values from par.ss
START$parmtrace <- 0 #can switch to 1 to turn on, helpful for debugging model
START$N_bootstraps <- 1 #change to 3 if you want to run bootstrap
START$last_estimation_phase <- 10 #turn to 0 if you don't want estimation
START$seed <- 0123

## STEP 3. Save updated starter file
#  --------------------------------------------------------------------------------------------------------------
r4ss::SS_writestarter(START, dir = file.path(root_dir, "SS3 models", species), overwrite = TRUE)
