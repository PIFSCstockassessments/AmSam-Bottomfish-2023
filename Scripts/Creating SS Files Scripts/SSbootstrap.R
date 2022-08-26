#' @param boot_dir directory where bootstraps are run
#' @param N_boot number of bootstrap models to run (>= 3)


SSbootstrap2 <- function(boot_dir, N_boot){
  
  # Directory where bootstrap will be run.
  
  starter <- SS_readstarter(file =  file.path(boot_dir, "starter.ss")) # read starter file
  file.copy(file.path(boot_dir, "starter.ss"), file.path(boot_dir, "starter_backup.ss")) # make backup
  
  #create the bootstrap data file numbers (pad with leading 0s)
  bootn <- stringr::str_pad(seq(1, N_boot, by = 1), 3, pad = "0")
  # loop over bootstrap files
  for (iboot in 1:N_boot) {
    # note what's happening
    cat("\n##### Running bootstrap model number", iboot, " #########\n")
    
    
    # change data file name in starter file
    starter[["datfile"]] <- paste("data_boot_", bootn[iboot], ".ss", sep = "")
    # replace starter file with modified version
    SS_writestarter(starter, dir = boot_dir, overwrite = TRUE)
    
    # delete any old output files
    file.remove(file.path(boot_dir, "Report.sso"))
    file.remove(file.path(boot_dir, "CompReport.sso"))
    file.remove(file.path(boot_dir, "covar.sso"))
    
    # run model
    run_SS_models(dirvec = boot_dir, model = "ss_opt_win.exe",
                  skipfinished = F)

    # copy output files (might be good to use "file.exists" command first to check if they exist
    file.copy(file.path(boot_dir, "Report.sso"), paste(boot_dir, "/Report_", iboot, ".sso", sep = ""))
    file.copy(file.path(boot_dir, "CompReport.sso"), paste(boot_dir, "/CompReport_", iboot, ".sso", sep = ""))
    file.copy(file.path(boot_dir, "covar.sso"), paste(boot_dir, "/covar_", iboot, ".sso", sep = ""))
    # other .sso files could be copied as well
  }
  
  
}
