#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOTTOMFISH - INITIAL SS FILE CREATION
#	Use example model files (from https://github.com/nmfs-stock-synthesis/user-examples) as templates 
#   for adding in American Samoa model parameter information
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

#CTL file 
#  --------------------------------------------------------------------------------------------------------------
## STEP 1. Read in template control file

CTL <- r4ss::SS_readctl_3.30(file = file.path(root_dir, "SS3 models", "TEMPLATE_FILES", "control.ss"), 
                             datlist = file.path(root_dir, "SS3 models", "TEMPLATE_FILES", "data.ss"))

#  --------------------------------------------------------------------------------------------------------------
## STEP 2. Update input values

CTL$EmpiricalWAA       <- 0 #if want to use wtatage.ss file change to 1
CTL$N_GP               <- 1
CTL$N_platoon          <- 1 #number of platoons within growth pattern
CTL$recr_dist_method   <- 2 #main effects for GP, area, settle timing
CTL$recr_dist_read     <- 1
CTL$recr_dist_pattern #dataframe with column names: GPattern, month, area, age. Just need to adjust month if assuming settlement doesn't happen in January. If settlement happens after age 0 need to adjust that too.
CTL$N_Block_Designs    <- 0 #setting to zero for base model, can add blocks if needed for parameter values
CTL$blocks_per_pattern <- 0
CTL$Block_Design       <- NULL

CTL$time_vary_auto_generation <- c(0,0,0,0,0) #don't know if this is needed if no time-varying parameters but with 0s it will automatically generate parameter values (or I assume will not if not specified)

CTL$natM_type         <- 0 #give one param value
CTL$GrowthModel       <- 1 #von Bert with L1&L2
CTL$Growth_Age_for_L1 <- 0
CTL$Growth_Age_for_L2 <- 25 #can set to 999 to use as Linf
CTL$Exp_Decay         <- -999

CTL$SD_add_to_LAA
CTL$CV_Growth_Pattern # 0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)

CTL$maturity_option           <- 1 #length logistic
CTL$First_Mature_Age          <- 1
CTL$fecundity_option          <- 1 #(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
CTL$hermaphroditism_option    <- 0
CTL$parameter_offset_approach <- 1 #no offset

## Growth Parameters
# Table of parameters with column names: LO, HI, INIT, PRIOR, PR_type, PHASE, env_var&link, dev_link, dev_minyr, dev_maxyr, dev_PH, Block, Block_Fxn, PType
CTL$MG_parms 
CTL$MGparm_seas_effects <- rep(0, 10)

## Spawner-Recruitment
CTL$SR_function         <- 3 #beverton holt
CTL$Use_steep_init_equi <- 0 #not using in initial equ recruitment calculation
# Table of parameters with column names: LO, HI, INIT, PRIOR, PR_SD, PR_type, PHASE, env_var&link, dev_link, dev_minyr, dev_maxyr, dev_PH, Block, Block_Fxn, PType
CTL$SR_parms
CTL$do_recdev <- 1
if(CTL$do_recdev == 1){
  
  CTL$MainRdevYrFirst
  CTL$MainRdevYrLast
  CTL$recdev_phase
  CTL$recdev_early_start
  CTL$recdev_early_phase
  CTL$Fcast_recr_phase
  CTL$lambda4Fcast_recr_like
  CTL$last_early_yr_nobias_adj
  CTL$first_yr_fullbias_adj
  CTL$last_yr_fullbias_adj
  CTL$first_recent_yr_nobias_adj
  CTL$max_bias_adj
  CTL$period_of_cycles_in_recr
  CTL$min_rec_dev
  CTL$max_rec_dev
  CTL$N_Read_recdevs
  
}

## Fishing Mortality
CTL$F_ballpark      <- 0.3
CTL$F_ballpark_year <- -2001 #negative year disables this
CTL$F_Method        <- 4 #recommended
CTL$maxF            <- 2
CTL$F_iter          <- 4 #recommended between 3 and 5

## Catchability
# Table with nrow = nfleets and column names: fleet, link, link_info, extra_se, biasadj, and float
CTL$Q_options 
# Table of parameters with column names: LO, HI, INIT, PRIOR, PR_SD, PR_type, PHASE, env_var&link, dev_link, dev_minyr, dev_maxyr, dev_PH, Block, Block_Fxn
CTL$Q_parms

## Selectivity
CTL$size_selex_types
CTL$size_selex_parms

CTL$age_selex_types
CTL$age_selex_parms

CTL$Use_2D_AR1_selectivity <- 0 #no 2D_AR1 offset

## Tagging data
CTL$TG_custom              <- 0

## Input variance adjustment
CTL$DoVar_adjust           <- 0
#if 1, need a table with column names: Factor, Fleet, and Value 

CTL$maxlambdaphase         <- 5 #max phase of estimation
CTL$sd_offset              <- 1 #must be 1 if any growthCV, sigmaR, or survey extraSD is an estimated parameter

## Likelihoods
# Table with column names: like_comp, fleet, phase, value, and sizefreq_method
# Only needed if values are different from 1
CTL$lambdas

CTL$more_stddev_reporting  <- 0

#  --------------------------------------------------------------------------------------------------------------
## STEP 3. Save updated control file

r4ss::SS_writectl_3.30(CTL, outfile = file.path(root_dir, "SS3 models", species, "control.ss"), overwrite = TRUE)