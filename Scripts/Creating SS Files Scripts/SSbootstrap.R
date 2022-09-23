#' @param boot_dir directory where bootstraps are run
#' @param N_boot number of bootstrap models to run (>= 3)


SSbootstrap2 <- function(boot_dir, N_boot, endyr){
  
  # Directory where bootstrap will be run.
  
  starter <- SS_readstarter(file =  file.path(boot_dir, "starter.ss")) # read starter file
  file.copy(file.path(boot_dir, "starter.ss"), file.path(boot_dir, "starter_backup.ss")) # make backup
  dat <- SS_readdat_3.30(file = file.path(boot_dir, "data.ss"))
  
  #create the bootstrap data file numbers (pad with leading 0s)
  bootn <- stringr::str_pad(seq(1, N_boot, by = 1), 3, pad = "0")
  # loop over bootstrap files
  for (iboot in 1:N_boot) {
    # note what's happening
    cat("\n##### Running bootstrap model number", iboot, " #########\n")
    
    # replace only original catch data with bootstrapped catch
    dat_boot <- SS_readdat_3.30(file = file.path(boot_dir, paste0("data_boot_", bootn[iboot], ".ss")))
    dat$catch <- dat_boot$catch
    SS_writedat_3.30(dat, outfile = file.path(boot_dir, paste0("data_boot_", bootn[iboot], ".ss")), 
                     overwrite = T)
    # change data file name in starter file
    starter[["datfile"]] <- paste("data_boot_", bootn[iboot], ".ss", sep = "")
    starter[["N_bootstraps"]] <- 1
    # replace starter file with modified version
    SS_writestarter(starter, dir = boot_dir, overwrite = TRUE)
    
    # delete any old output files
    file.remove(file.path(boot_dir, "Report.sso"))
    file.remove(file.path(boot_dir, "CompReport.sso"))
    file.remove(file.path(boot_dir, "covar.sso"))
    
    # run model
    r4ss::run(dir = boot_dir, exe = "ss_opt_win.exe",
                  skipfinished = F)

    # copy output files (might be good to use "file.exists" command first to check if they exist
    file.copy(file.path(boot_dir, "Report.sso"), paste(boot_dir, "/Report_", iboot, ".sso", sep = ""))
    file.copy(file.path(boot_dir, "CompReport.sso"), paste(boot_dir, "/CompReport_", iboot, ".sso", sep = ""))
    file.copy(file.path(boot_dir, "covar.sso"), paste(boot_dir, "/covar_", iboot, ".sso", sep = ""))
    # other .sso files could be copied as well
  }
  
  mods <- SSgetoutput(keyvec = paste0("_", seq(1, N_boot)), 
                      dirvec = file.path(boot_dir), verbose = F)
  mvlns <- list()
  
  for(i in 1:length(mods)){
    
    mvlns[[i]] <- ss3diags::SSdeltaMVLN(mods[[i]], mc = 5000, 
                              weight = 1, 
                              run = paste0("boot", i), 
                              plot = F,
                              addprj = T)$kb
    
  }
  
  mv <- data.table::rbindlist(mvlns)
  save(mv, file = file.path(boot_dir, "mvln_draws.RData"))
  mv_fore <- mv %>% filter(year > endyr) %>% mutate(SSB.SSBmsst = (SSB/stock)*0.9) %>% select(-c(type, iter, Recr))
  save(mv_fore, file = file.path(boot_dir, "mv_projections.RData"))
  
}
