#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOTTOMFISH - INITIAL SS STARTER FILE CREATION
#	Use example model files (from https://github.com/nmfs-stock-synthesis/user-examples) as templates 
#   for starter file
#	Megumi Oshima megumi.oshima@noaa.gov
#  
#  --------------------------------------------------------------------------------------------------------------
## Starter file
#  --------------------------------------------------------------------------------------------------------------
build_starter <- function(species,
                          scenario = "base",
                          file_dir = "base",
                          template_dir = file.path(root_dir, "SS3 models", "TEMPLATE_FILES", "starter.ss"), 
                          out_dir = file.path(root_dir, "SS3 models"),
                          init_values = 0,
                          parmtrace = 0,
                          N_boot = 1,
                          last_est_phs = 10,
                          seed = 0123){
  ## STEP 1. Read in template starter file
  START <- r4ss::SS_readstarter(file = file.path(template_dir, "starter.ss"))
  
  ## STEP 2. Make any changes necessary
  #  --------------------------------------------------------------------------------------------------------------
  ## most likely changes are listed below: 
  START$datfile <- "data.ss"
  START$ctlfile <- "control.ss"
  START$init_values_src <- init_values #switch 1 if want to use parameter values from par.ss
  START$parmtrace <- parmtrace #can switch to 1 to turn on, helpful for debugging model
  START$N_bootstraps <- N_boot #change to 3 if you want to run bootstrap
  START$last_estimation_phase <- last_est_phs #turn to 0 if you don't want estimation
  START$maxyr_sdreport <- -2
  START$seed <- seed
  
  ## STEP 3. Save updated starter file
  #  --------------------------------------------------------------------------------------------------------------
  r4ss::SS_writestarter(START, dir = file.path(out_dir, species, file_dir), overwrite = TRUE)
  
}

