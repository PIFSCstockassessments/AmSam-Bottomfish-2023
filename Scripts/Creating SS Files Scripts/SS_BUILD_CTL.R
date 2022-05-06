#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOTTOMFISH - INITIAL SS CONTROL FILE CREATION
#	Use example model files (from https://github.com/nmfs-stock-synthesis/user-examples) as templates 
#   for adding in American Samoa model parameter information
#	Megumi Oshima megumi.oshima@noaa.gov
#  
#  --------------------------------------------------------------------------------------------------------------

require(r4ss)
require(tidyverse)
require(this.path)

root_dir         <- this.path::here(.. = 2)
Species.List     <- read.xlsx(file.path(root_dir, "Data", "METADATA.xlsx"), sheet = "BMUS")

#CTL file 
#  --------------------------------------------------------------------------------------------------------------
## STEP 1. Read in input information
ctl.inputs       <- read.xlsx(file.path(root_dir, "Data", "CTL_inputs.xlsx"), sheet = "inputs_1")
# lambdas <- read.xlsx(file.path(root_dir, "Data"))
# size_selex <- read.xlsx(file.path(root_dir, "Data"))
# age_selex <- read.xlsx(file.path(root_dir, "Data"))

## create Q options, age, and length selectivity types dataframes based on the number of fleets including. NOTE: not the best way but if all species have the same fleets this will work.
Q.options        <- data.frame(fleet = c(1), link = c(1), link_info = c(0), extra_se = c(0), biasadj = c(0), float = c(0))
size_selex_types <- data.frame(Pattern = c(24), Discard = c(0), Male = c(0), Special = c(0)) #using recommended double normal
age_selex_types  <- data.frame(Pattern = c(8), Discard = c(0), Male = c(0), Special = c(0))  #using recommended double normal
#  --------------------------------------------------------------------------------------------------------------

for(i in seq_along(Species.List$SPECIES)){
  
## STEP 2. Read in template file

CTL <- r4ss::SS_readctl_3.30(file = file.path(root_dir, "SS3 models", "TEMPLATE_FILES", "control.ss"), 
                             datlist = file.path(root_dir, "SS3 models", "TEMPLATE_FILES", "data.ss"))

## STEP 3. Identify which species you are using and subset inputs 
species <- Species.List$SPECIES[i]

ctl.sps <- ctl.inputs %>% 
  select(c(Parameter, contains(species))) %>% 
  pivot_wider(names_from = Parameter, 
              values_from = paste0(species))
ctl.params <- read.xlsx(file.path(root_dir, "Data", "CTL_parameters.xlsx"), sheet = paste0(species))
  

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
CTL$GrowthModel       <- ctl.sps$GrowthModel #von Bert with L1&L2
CTL$Growth_Age_for_L1 <- ctl.sps$Growth_Age_for_L1
CTL$Growth_Age_for_L2 <- ctl.sps$Growth_Age_for_L2 #can set to 999 to use as Linf
CTL$Exp_Decay         <- -999

CTL$SD_add_to_LAA <- 0
CTL$CV_Growth_Pattern <- 0 # 0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)

CTL$maturity_option           <- ctl.sps$maturity_option #length logistic
CTL$First_Mature_Age          <- ctl.sps$First_Mature_Age
CTL$fecundity_option          <- ctl.sps$fecundity_option #(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
CTL$hermaphroditism_option    <- ctl.sps$hermaphroditism_option
CTL$parameter_offset_approach <- 0 #no offset

## Growth Parameters
# Table of parameters with column names: LO, HI, INIT, PRIOR, PR_type, PHASE, env_var&link, dev_link, dev_minyr, dev_maxyr, dev_PH, Block, Block_Fxn
CTL$MG_parms <- ctl.params %>% 
  filter(str_detect(category, "MG")) %>% 
  select(-category) %>% 
  column_to_rownames("X1")

CTL$MGparm_seas_effects <- rep(0, 10)

## Spawner-Recruitment
CTL$SR_function         <- ctl.sps$SR_function #beverton holt
CTL$Use_steep_init_equi <- ctl.sps$Use_steep_init_equi #not using in initial equ recruitment calculation
# Table of parameters with column names: LO, HI, INIT, PRIOR, PR_SD, PR_type, PHASE, env_var&link, dev_link, dev_minyr, dev_maxyr, dev_PH, Block, Block_Fxn, PType
CTL$SR_parms <- ctl.params %>% 
  filter(str_detect(category, "SR")) %>% 
  select(-category) %>% 
  column_to_rownames("X1")

CTL$do_recdev <- 0
if(CTL$do_recdev == 1){
  
  CTL$MainRdevYrFirst            <- ctl.sps$MainRdevYrFirst
  CTL$MainRdevYrLast             <- ctl.sps$MainRdevYrLast
  CTL$recdev_phase               <- ctl.sps$recdev_phase
  CTL$recdev_early_start         <- ctl.sps$recdev_early_start
  CTL$recdev_early_phase         <- ctl.sps$recdev_early_phase
  CTL$Fcast_recr_phase           <- ctl.sps$Fcast_recr_phase
  CTL$lambda4Fcast_recr_like     <- ctl.sps$lambda4Fcast_recr_like
  CTL$last_early_yr_nobias_adj   <- ctl.sps$last_early_yr_nobias_adj
  CTL$first_yr_fullbias_adj      <- ctl.sps$first_yr_fullbias_adj
  CTL$last_yr_fullbias_adj       <- ctl.sps$last_yr_fullbias_adju
  CTL$first_recent_yr_nobias_adj <- ctl.sps$first_recent_yr_nobias_adj
  CTL$max_bias_adj               <- ctl.sps$max_bias_adj
  CTL$period_of_cycles_in_recr   <- ctl.sps$period_of_cycles_in_recr
  CTL$min_rec_dev                <- ctl.sps$min_rec_dev
  CTL$max_rec_dev                <- ctl.sps$max_rec_dev
  CTL$N_Read_recdevs             <- ctl.sps$N_Read_recdevs
  
}

## Fishing Mortality
CTL$F_ballpark      <- ctl.sps$F_ballpark
CTL$F_ballpark_year <- ctl.sps$F_ballpark_year #negative year disables this
CTL$F_Method        <- ctl.sps$F_Method #recommended
CTL$maxF            <- ctl.sps$maxF
CTL$F_iter          <- ctl.sps$F_iter #recommended between 3 and 5

## Catchability
# Table with nrow = nfleets and column names: fleet, link, link_info, extra_se, biasadj, and float
CTL$Q_options <- Q.options
# Table of parameters with column names: LO, HI, INIT, PRIOR, PR_SD, PR_type, PHASE, env_var&link, dev_link, dev_minyr, dev_maxyr, dev_PH, Block, Block_Fxn
CTL$Q_parms <- ctl.params %>% 
  filter(str_detect(category, "Q")) %>% 
  select(-category) %>% 
  column_to_rownames("X1")

## Selectivity
if(exists("size_selex")){
  
  CTL$size_selex_types <- size_selex_types
  CTL$size_selex_parms <- ctl.params %>% 
    filter(str_detect(category, "selex_size")) %>% 
    select(-category) %>% 
    column_to_rownames("X1")
  
}else{
  
  CTL$size_selex_types <- size_selex_types
  CTL$size_selex_parms <- NULL
  
}

if(exists("age_selex")){
  
  CTL$age_selex_types <- age_selex_types
  CTL$age_selex_parms <- ctl.params %>% 
    filter(str_detect(category, "selex_age")) %>% 
    select(-category) %>% 
    column_to_rownames("X1")
  
}else{
  
  CTL$age_selex_types <- age_selex_types
  CTL$age_selex_parms <- NULL
  
}

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
if(exists("lambdas")){
  CTL$lambdas <- lambdas
  CTL$N_lambdas <- nrow(lambdas)
}else{
  CTL$lambdas <- NULL
  CTL$N_lambdas <- 0
}

CTL$more_stddev_reporting  <- 0

#  --------------------------------------------------------------------------------------------------------------
## STEP 3. Save updated control file

r4ss::SS_writectl_3.30(CTL, outfile = file.path(root_dir, "SS3 models", species, "control.ss"), overwrite = TRUE)

}