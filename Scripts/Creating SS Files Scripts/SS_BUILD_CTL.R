#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOTTOMFISH - INITIAL SS CONTROL FILE CREATION
#	Use example model files (from https://github.com/nmfs-stock-synthesis/user-examples) as templates 
#   for adding in American Samoa model parameter information
#	Megumi Oshima megumi.oshima@noaa.gov
#  
#  --------------------------------------------------------------------------------------------------------------
#CTL file 
#  --------------------------------------------------------------------------------------------------------------
build_control <- function(species = species,
                          ctl.inputs = ctl.inputs,
                          M_option_sp = "Option1",
                          template.dir = file.path(root_dir, "SS3 models", "TEMPLATE_FILES"),
                          out.dir = file.path(root_dir, "SS3 models")){
  
  CTL        <- r4ss::SS_readctl_3.30(file = file.path(template.dir, "control.ss"), 
                                      datlist = file.path(template.dir, "data.ss"))

  
  ctl.sps    <- ctl.inputs %>% 
    select(c(Parameter, contains(species))) %>% 
    pivot_wider(names_from = Parameter, 
                values_from = paste0(species))
  
  ctl.params <- read.xlsx(file.path(root_dir, "Data", "CTL_parameters.xlsx"), sheet = paste0(species))
  
  
  #  --------------------------------------------------------------------------------------------------------------
  ## STEP 2. Update input values
  
  CTL$EmpiricalWAA       <- ctl.sps$EprircalWAA #if want to use wtatage.ss file change to 1
  CTL$N_GP               <- ctl.sps$N_GP
  CTL$N_platoon          <- ctl.sps$N_platoon #number of platoons within growth pattern
  CTL$recr_dist_method   <- ctl.sps$recr_dist_method #main effects for GP, area, settle timing
  CTL$recr_dist_read     <- ctl.sps$recr_dist_read
  CTL$recr_dist_pattern #dataframe with column names: GPattern, month, area, age. Just need to adjust month if assuming settlement doesn't happen in January. If settlement happens after age 0 need to adjust that too.
  CTL$N_Block_Designs    <- ctl.sps$N_Block_Designs #setting to zero for base model, can add blocks if needed for parameter values
  CTL$blocks_per_pattern <- ctl.sps$blocks_per_pattern
  CTL$Block_Design[[1]]  <- if(ctl.sps$Block_Design == -1000){
    NULL
  }else{
    c(ctl.sps$Block_Design_Start, ctl.sps$Block_Design_Finish)
  }
                                   
  
  CTL$time_vary_auto_generation <- c(ctl.sps$time_vary_auto_generation_1, 
                                     ctl.sps$time_vary_auto_generation_2,
                                     ctl.sps$time_vary_auto_generation_3, 
                                     ctl.sps$time_vary_auto_generation_4,
                                     ctl.sps$time_vary_auto_generation_5)
  
  CTL$natM_type         <- ctl.sps$natM_type #give one param value
  CTL$GrowthModel       <- ctl.sps$GrowthModel #von Bert with L1&L2
  CTL$Growth_Age_for_L1 <- ctl.sps$Growth_Age_for_L1
  CTL$Growth_Age_for_L2 <- ctl.sps$Growth_Age_for_L2 #can set to 999 to use as Linf
  CTL$Exp_Decay         <- ctl.sps$Exp_Decay
  
  CTL$SD_add_to_LAA <- ctl.sps$SD_add_to_LAA
  CTL$CV_Growth_Pattern <- ctl.sps$CV_Growth_Pattern # 0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)
  
  CTL$maturity_option           <- ctl.sps$maturity_option #length logistic
  CTL$First_Mature_Age          <- ctl.sps$First_Mature_Age
  CTL$fecundity_option          <- ctl.sps$fecundity_option #(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
  CTL$hermaphroditism_option    <- ctl.sps$hermaphroditism_option
  CTL$parameter_offset_approach <- ctl.sps$parameter_off_approach #no offset
  
  ## Growth Parameters
  # Table of parameters with column names: LO, HI, INIT, PRIOR, PR_type, PHASE, env_var&link, dev_link, dev_minyr, dev_maxyr, dev_PH, Block, Block_Fxn
  CTL$MG_parms <- ctl.params %>% 
    filter(str_detect(category, "MG")) %>% 
    filter(str_detect(OPTION, M_option_sp)) %>% 
    select(-c(category, OPTION)) %>% 
    column_to_rownames("X1")
  
  CTL$MGparm_seas_effects <- unlist(select(ctl.sps, contains("Mgparm_seas")))
  ## Spawner-Recruitment
  CTL$SR_function         <- ctl.sps$SR_function #beverton holt
  CTL$Use_steep_init_equi <- ctl.sps$Use_steep_init_equi #not using in initial equ recruitment calculation
  # Table of parameters with column names: LO, HI, INIT, PRIOR, PR_SD, PR_type, PHASE, env_var&link, dev_link, dev_minyr, dev_maxyr, dev_PH, Block, Block_Fxn, PType
  CTL$SR_parms <- ctl.params %>% 
    filter(str_detect(category, "SR")) %>% 
    filter(str_detect(OPTION, M_option_sp)) %>% 
    select(-c(category, OPTION)) %>% 
    column_to_rownames("X1")
  
  CTL$do_recdev <- ctl.sps$do_recdev
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
    filter(str_detect(OPTION, M_option_sp)) %>% 
    select(-c(category, OPTION)) %>% 
    column_to_rownames("X1")
   
  
  ## Selectivity
  if(exists("size_selex")){
    
    CTL$size_selex_types <- size_selex_types
    CTL$size_selex_parms <- ctl.params %>% 
      filter(str_detect(category, "selex_size")) %>% 
      filter(str_detect(OPTION, M_option_sp)) %>% 
      select(-c(category, OPTION)) %>% 
      column_to_rownames("X1")
    
  }else{
    
    CTL$size_selex_types <- size_selex_types
    CTL$size_selex_parms <- NULL
    
  }
  
  if(exists("age_selex")){
    
    CTL$age_selex_types <- age_selex_types
    CTL$age_selex_parms <- ctl.params %>% 
      filter(str_detect(category, "selex_age")) %>% 
      filter(str_detect(OPTION, M_option_sp)) %>% 
      select(-c(category, OPTION)) %>% 
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
  
  CTL$maxlambdaphase         <- ctl.sps$maxlambdaphase #max phase of estimation
  #CTL$sd_offset              <- ctl.sps$sd_offset #must be 1 if any growthCV, sigmaR, or survey extraSD is an estimated parameter
  
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
  
  CTL$more_stddev_reporting  <- ctl.sps$more_stddev_reporting
  
  #  --------------------------------------------------------------------------------------------------------------
  ## STEP 3. Save updated control file
  
  r4ss::SS_writectl_3.30(CTL, outfile = file.path(out.dir, species, "control.ss"), overwrite = TRUE)
  
}
  

