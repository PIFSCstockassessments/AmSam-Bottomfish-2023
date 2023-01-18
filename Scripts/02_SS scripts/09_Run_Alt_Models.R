
library(pacman)
pacman::p_load(r4ss, dplyr, stringr, this.path)

root_dir <- this.path::here(..=2)

species_names <- c("APRU", "APVI", "CALU", "ETCO", "LERU", "LUKA", "PRFL", "PRZO", "VALO")
species <- species_names[5]

### Alternate model options 
run_M <- T
run_steep <- T
run_recdevs <- T
run_nohistcatch <- T
run_noherm <- T
## Get parameter values from online (T) or Excel file on local computer
readGoogle <- T

mods_dir <- file.path(root_dir, "SS3 final models", species)

if(run_M){
  
  if(!dir.exists(file.path(mods_dir, "02_M1"))){
    dir.create(file.path(mods_dir, "02_M1"))
  }
  
  copy_SS_inputs(dir.old = file.path(mods_dir, "01_Base"),
                 dir.new = file.path(mods_dir, "02_M1"),
                 overwrite = T, copy_exe = TRUE)
  
  ctl <- SS_readctl_3.30(file.path(mods_dir, "02_M1", "control.ss"),
                         datlist = file.path(mods_dir, "02_M1", "data.ss"))
  ## Natural mortality
  ctl$MG_parms[1,3] <- round(ctl$MG_parms[1,3] - ctl$MG_parms[1,3]*.1,2)
  SS_writectl_3.30(ctl, outfile = file.path(mods_dir, "02_M1", "control.ss"), overwrite = T)
  r4ss::run(
    dir = file.path(mods_dir, "02_M1"),
    exe = "ss_opt_win.exe",
    skipfinished = F
  )
  
  
  if(!dir.exists(file.path(mods_dir, "03_M2"))){
    dir.create(file.path(mods_dir, "03_M2"))
  }
  
  copy_SS_inputs(dir.old = file.path(mods_dir, "01_Base"),
                 dir.new = file.path(mods_dir, "03_M2"),
                 overwrite = T, copy_exe = TRUE)
  
  ctl <- SS_readctl_3.30(file.path(mods_dir, "03_M2", "control.ss"),
                         datlist = file.path(mods_dir, "02_M1", "data.ss"))
  ## Natural mortality
  ctl$MG_parms[1,3] <- round(ctl$MG_parms[1,3] + ctl$MG_parms[1,3]*.1, 2)
  SS_writectl_3.30(ctl, outfile = file.path(mods_dir, "03_M2", "control.ss"), overwrite = T)
  r4ss::run(
    dir = file.path(mods_dir, "03_M2"),
    exe = "ss_opt_win.exe",
    skipfinished = F
  )
  
  
}


if(run_steep){
  
  if(!dir.exists(file.path(mods_dir, "04_Steep1"))){
    dir.create(file.path(mods_dir, "04_Steep1"))
  }
  
  copy_SS_inputs(dir.old = file.path(mods_dir, "01_Base"),
                 dir.new = file.path(mods_dir, "04_Steep1"),
                 overwrite = T, copy_exe = TRUE)
  
  ctl <- SS_readctl_3.30(file.path(mods_dir, "04_Steep1", "control.ss"),
                         datlist = file.path(mods_dir, "04_Steep1", "data.ss"))
  ## Steepness
  ctl$SR_parms[2,3] <- round(ctl$SR_parms[2,3] - ctl$SR_parms[2,3]*.1,2)
  SS_writectl_3.30(ctl, outfile = file.path(mods_dir, "04_Steep1", "control.ss"), overwrite = T)
  r4ss::run(
    dir = file.path(mods_dir, "04_Steep1"),
    exe = "ss_opt_win.exe",
    skipfinished = F
  )
  
  
  if(!dir.exists(file.path(mods_dir, "05_Steep2"))){
    dir.create(file.path(mods_dir, "05_Steep2"))
  }
  
  copy_SS_inputs(dir.old = file.path(mods_dir, "01_Base"),
                 dir.new = file.path(mods_dir, "05_Steep2"),
                 overwrite = T, copy_exe = TRUE)
  
  ctl <- SS_readctl_3.30(file.path(mods_dir, "05_Steep2", "control.ss"),
                         datlist = file.path(mods_dir, "05_Steep2", "data.ss"))
  ## Steepness
  ctl$SR_parms[2,3] <- round(ctl$SR_parms[2,3] + ctl$SR_parms[2,3]*.1, 2)
  SS_writectl_3.30(ctl, outfile = file.path(mods_dir, "05_Steep2", "control.ss"), overwrite = T)
  r4ss::run(
    dir = file.path(mods_dir, "05_Steep2"),
    exe = "ss_opt_win.exe",
    skipfinished = F
  )
  
  
}

if(run_recdevs){
  
  if(!dir.exists(file.path(mods_dir, "06_RecDev"))){
    dir.create(file.path(mods_dir, "06_RecDev"))
  }
  
  copy_SS_inputs(dir.old = file.path(mods_dir, "01_Base"),
                 dir.new = file.path(mods_dir, "06_RecDev"),
                 overwrite = T, copy_exe = TRUE)
  
  CTL <- SS_readctl_3.30(file.path(mods_dir, "06_RecDev", "control.ss"),
                         datlist = file.path(mods_dir, "06_RecDev", "data.ss"))
  

  if(readGoogle == T){
    ctl.inputs <- googlesheets4::read_sheet("11lPJV7Ub9eoGbYjoPNRpcpeWUM5RYl4W65rHHFcQ9fQ", sheet="base")
    
  }else{
    ctl.inputs <- readxl::read_excel(file.path(root_dir, "Data", "CTL_inputs.xlsx"), sheet="base")
  }
  
  
  ## Turn on rec devs
  ctl.sps    <- ctl.inputs %>% 
    select(c(Parameter, contains(species))) %>% 
    tidyr::pivot_wider(names_from = Parameter, 
                values_from = paste0(species))
  
  
  CTL$do_recdev <- 1
  if(CTL$do_recdev == 1){
    
    CTL$MainRdevYrFirst            <- ctl.sps$MainRdevYrFirst
    CTL$MainRdevYrLast             <- ctl.sps$MainRdevYrLast
    CTL$recdev_phase               <- ctl.sps$recdev_phase
    CTL$recdev_adv                 <- ctl.sps$recdev_adv
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
  
  SS_writectl_3.30(CTL, outfile = file.path(mods_dir, "06_RecDev", "control.ss"), overwrite = T)
  r4ss::run(
    dir = file.path(mods_dir, "06_RecDev"),
    exe = "ss_opt_win.exe",
    skipfinished = F
  )
  
}

if(run_nohistcatch){
  
  if(!dir.exists(file.path(mods_dir, "07_NoHistCatch"))){
    dir.create(file.path(mods_dir, "07_NoHistCatch"))
  }
  
  copy_SS_inputs(dir.old = file.path(mods_dir, "01_Base"),
                 dir.new = file.path(mods_dir, "07_NoHistCatch"),
                 overwrite = T, copy_exe = TRUE)
  
  CTL <- SS_readctl_3.30(file.path(mods_dir, "07_NoHistCatch", "control.ss"),
                         datlist = file.path(mods_dir, "07_NoHistCatch", "data.ss"))
  
  if(readGoogle == T){
    
    ctl.params <- googlesheets4::read_sheet("1XvzGtPls8hnHHGk7nmVwhggom4Y1Zp-gOHNw4ncUs8E", 
                             sheet=species)
    
  }else{
    
    ctl.params <- readxl::read_excel(file.path(root_dir, "Data", "CTL_parameters.xlsx"), 
                                     sheet=species)
  }
  
  CTL$init_F <- ctl.params %>% filter(str_detect(X1, "initial_F")) %>% 
    rename("LABEL" = "X1") %>% 
    select(c(LO, HI, INIT, PRIOR, PR_SD, PR_type, PHASE, LABEL)) %>% 
    data.table::as.data.table()
 
  SS_writectl_3.30(CTL, outfile = file.path(mods_dir, "07_NoHistCatch", "control.ss"), overwrite = T)
  
  DAT <- SS_readdat_3.30(file = file.path(mods_dir, "07_NoHistCatch", "data.ss"))
  ## Change start year
  DAT$styr <- 1986
  ## Filter catch to remove any catch before new startyear
  DAT$catch <- DAT$catch %>% 
    filter(year == -999 | year >= DAT$styr) 
  ## Set up for estimating initial F
  DAT$catch$catch[1] <- DAT$catch[DAT$catch$year == DAT$styr, "catch"]
  DAT$catch$catch_se[1] <- DAT$catch[DAT$catch$year == DAT$styr, "catch_se"]
  
  SS_writedat_3.30(DAT, outfile = file.path(mods_dir, "07_NoHistCatch", "data.ss"), overwrite = T)
  
  r4ss::run(
    dir = file.path(mods_dir, "07_NoHistCatch"),
    exe = "ss_opt_win.exe",
    skipfinished = F
  )
  
}

if(run_noherm){
  
  if(!dir.exists(file.path(mods_dir, "09_NoHermaphro"))){
    dir.create(file.path(mods_dir, "09_NoHermaphro"))
  }
  
  copy_SS_inputs(dir.old = file.path(mods_dir, "01_Base"),
                 dir.new = file.path(mods_dir, "09_NoHermaphro"),
                 overwrite = T, copy_exe = TRUE)
  
  CTL <- SS_readctl_3.30(file.path(mods_dir, "09_NoHermaphro", "control.ss"),
                         datlist = file.path(mods_dir, "09_NoHermaphro", "data.ss"))
  
  CTL$hermaphroditism_option <- 0
  CTL$Herm_MalesInSSB <- NULL
  CTL$Herm_season <- NULL

  CTL$MG_parms <- CTL$MG_parms %>% 
    filter(str_detect(rownames(.), "Herm", negate = T))
  ind <- which(str_detect(row.names(CTL$MG_parms), "FracFemale"))
  CTL$MG_parms[ind, 3] <- 0.5
  
  SS_writectl_3.30(CTL, outfile = file.path(mods_dir, "09_NoHermaphro", "control.ss"), overwrite = T)

  r4ss::run(
    dir = file.path(mods_dir, "09_NoHermaphro"),
    exe = "ss_opt_win.exe",
    skipfinished = F
  )
  
}



