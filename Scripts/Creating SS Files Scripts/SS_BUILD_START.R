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
seed <- 0123
last_est_phs <- 10
init_values <- 0
N_boot <- 1

## Starter file
#  --------------------------------------------------------------------------------------------------------------
for(i in seq_along(Species.List$SPECIES)){
  
  species  <- Species.List$SPECIES[i]
  
  ## STEP 1. Read in template starter file
  START <- r4ss::SS_readstarter(file = file.path(root_dir, "SS3 models", "TEMPLATE_FILES", "starter.ss"))
  
  ## STEP 2. Make any changes necessary
  #  --------------------------------------------------------------------------------------------------------------
  ## most likely changes are listed below: 
  START$datfile <- "data.ss"
  START$ctlfile <- "control.ss"
  START$init_values_src <- init_values #switch 1 if want to use parameter values from par.ss
  #START$parmtrace <- 0 #can switch to 1 to turn on, helpful for debugging model
  START$N_bootstraps <- N_boot #change to 3 if you want to run bootstrap
  START$last_estimation_phase <- last_est_phs #turn to 0 if you don't want estimation
  START$seed <- seed
  
  ## STEP 3. Save updated starter file
  #  --------------------------------------------------------------------------------------------------------------
  r4ss::SS_writestarter(START, dir = file.path(root_dir, "SS3 models", species), overwrite = TRUE)
  
}

