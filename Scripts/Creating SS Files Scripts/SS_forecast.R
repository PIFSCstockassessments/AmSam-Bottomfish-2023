#' @param model_dir directory where bootstraps are run
#' @param N_boot number of bootstrap models to run (>= 3)
#' @param N_foreyrs number of forecast years
#' @param FixedCatchSeq Sequence of catch containing start, end, and steps of the Fixed Catch values to forecast (ex. start=0, end=1.7 mt, by=0.1)

SSForecast <- function(model_dir, N_boot, N_foreyrs, FixedCatchSeq, endyr){
  
  fore_dir <- file.path(model_dir,"forecast")
  
  FixedCatchVec <- seq(FixedCatchSeq[1],FixedCatchSeq[2],FixedCatchSeq[3])
  N_ForeCatch   <- length(FixedCatchVec)
  
  # Directory where forecasts will be run.
  if(!exists(fore_dir)){
    dir.create(fore_dir)
  }
  
  # Delete all files in that directory
  unlink(file.path(fore_dir,"*"))
  
  # Run model one time to generate the data bootrap files
  file.copy(list.files(model_dir, pattern = "data|control|starter|forecast|.exe", full.names = T),
            to = fore_dir)
  start <- r4ss::SS_readstarter(file = file.path(fore_dir, "starter.ss"))
  start$N_bootstraps <- N_boot + 2
  r4ss::SS_writestarter(start, dir = fore_dir, overwrite = T)
  r4ss::run(dir = fore_dir, 
            exe = "ss_opt_win", extras = "-nohess",  skipfinished = FALSE, show_in_console = TRUE)
  
  message(paste0("Creating forecast data files in ", fore_dir))
  
  starter <- SS_readstarter(file =  file.path(fore_dir, "starter.ss")) # read starter file
  file.copy(file.path(fore_dir, "starter.ss"), file.path(fore_dir, "starter_backup.ss")) # make backup
  dat <- SS_readdat_3.30(file = file.path(fore_dir, "data.ss"))
  
  #create the forecast data file numbers (pad with leading 0s)
  bootn <- stringr::str_pad(seq(1, N_boot, by = 1), 3, pad = "0")
  foren <- stringr::str_pad(seq(1, N_ForeCatch, by = 1), 3, pad = "0")
  
  # loop over bootstrap files
  for (iboot in 1:N_boot) {
    
    # replace only original catch data with bootstrapped catch
    dat_boot <- SS_readdat_3.30(file = file.path(fore_dir, paste0("data_boot_", bootn[iboot], ".ss")))
    dat$catch <- dat_boot$catch
    SS_writedat_3.30(dat, outfile = file.path(fore_dir, paste0("data_boot_", bootn[iboot], ".ss")), 
                     overwrite = T)
    
    # change data file name in starter file
    starter[["datfile"]] <- paste("data_boot_", bootn[iboot], ".ss", sep = "")
    starter[["N_bootstraps"]] <- 1
    
    # replace starter file with modified version
    SS_writestarter(starter, dir = fore_dir, overwrite = TRUE)
    
       for(icatch in 1:N_ForeCatch){
       
         cat("\n##### Running forecast number", icatch, " #########\n","of ","bootstrap model number", iboot, " #########\n")
         
        # Read original forecast file
        forecast.file <- SS_readforecast(file =  file.path(fore_dir, "forecast.ss")) # read forecast file
         
        # Modify the forecast to include a new Fixed Catch to use in the projections
        forecast.file$Nforecastyrs <- N_foreyrs
        forecast.file$ForeCatch <- data.frame(Year = seq(endyr+1, endyr + N_foreyrs, by = 1),
                                                                       Season = 1, 
                                                                       Fleet = 1,
                                                                       Catch = FixedCatchVec[icatch])
        
        # replace forecast file with modified version
        SS_writeforecast(forecast.file, dir = fore_dir, overwrite = TRUE)
        
        # delete any old output files
        file.remove(file.path(fore_dir, "Report.sso"))
        file.remove(file.path(fore_dir, "CompReport.sso"))
        file.remove(file.path(fore_dir, "covar.sso"))
        
        # run model
        r4ss::run(dir = fore_dir, exe = "ss_opt_win.exe", skipfinished = F)
    
        # copy output files (might be good to use "file.exists" command first to check if they exist
        file.copy(file.path(fore_dir, "Report.sso"), paste0(fore_dir, "/Report_B",iboot,"C",icatch,".sso"))
        file.copy(file.path(fore_dir, "CompReport.sso"), paste0(fore_dir, "/CompReport_B",iboot,"C",icatch,".sso"))
        file.copy(file.path(fore_dir, "covar.sso"), paste0(fore_dir, "/covar_B",iboot,"C",icatch,".sso"))
        # other .sso files could be copied as well

       }  # End of Fixed Catch loop
  } # End of Bootstrap loop
  
  # Generate model names
  boot.names  <- paste0("B",rep(1:N_boot, each=N_ForeCatch))
  catch.names <- paste0("C",rep(1:N_ForeCatch, times=N_boot))
  model.names <- paste0(boot.names,catch.names)
  
  # Read all model files and generate a list
  models <- SSgetoutput(keyvec = paste0("_",model.names), 
                      dirvec = file.path(fore_dir), verbose = F)
  
  mvlns <- list()
  for(i in 1:length(models)){
    
    print(i)
    
    #TS          <- data.table( models[[i]]$timeseries )
    #aFixedCatch <- max( TS[Era=="FORE"]$`dead(B):_1`)
    
    try(  mvlns[[i]] <- ss3diags::SSdeltaMVLN(models[[i]], mc = 1000, 
                                        weight = 1, 
                                        run = paste0("Model ",model.names[i]), 
                                        plot = F,
                                        addprj = T)$kb
      , silent=TRUE)
  }
  
  mv            <- data.table::rbindlist(mvlns)
  
  # Retrieve the fixed catch from the run name
  #Tp            <- str_split_fixed(mv$run, '_', 2)
  #mv$FixedCatch <- as.numeric( Tp[,1] )
  #saveRDS(mv, file = file.path(fore_dir, "mvln_draws.rds"))
  
 # mv_fore <- mv %>% filter(year > endyr) %>% mutate(SSB_SSBmsst = (SSB/stock)*0.9) %>% select(-c(type, iter, Recr))
  
  mv_fore             <- mv[year>endyr]
  mv_fore$SSBmsst     <- mv_fore$SSB/mv_fore$stock*0.9 
  mv_fore$SSB_SSBmsst <- mv_fore$SSB/mv_fore$SSBmsst
  mv_fore             <- select(mv_fore,-c(type,iter,Recr))
  
  # Delete all files and save final result
  unlink(file.path(fore_dir,"*"))
  
  saveRDS(mv_fore, file = file.path(fore_dir, "mv_projections.rds"))
  
  # Create projection table and figures
  require(ggplot2)
  
  mv_fore <- readRDS(file=file.path(fore_dir,"mv_projections.rds"))
    
  
}
