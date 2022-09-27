#' Function to run retrospective analysis, likelihood profiling, and jitter. 
#' 
#' @param root_dir root directory 
#' @param species species to run analyses for
#' @param file_dir name of subdirectory running tests in
#' @param do_retro TRUE run retrospective, FALSE doesn't
#' @param retro_years vector of years to peel back start with 0 and go to negative number of years
#' @param do_profile TRUE to run likelihood profile
#' @param profile string of the parameter to change (can be vector of strings if changing multiple)
#' @param profile.vec vector of values to profile over for the parameter of interest
#' @param do_jitter TRUE to run jitter analysis
#' @param Njitter number of jitters to run
#' @param jitterFraction increment of change for each jitter run




run_diags <- function(root_dir = this.path::here(.. = 1),
                      species = "APVI",
                      file_dir = "base",
                      do_retro = TRUE,
                      retro_years = 0:-5,
                      do_profile = TRUE,
                      profile = "SR_LN(R0)",
                      profile.vec = seq(8.2, 8.4, .1),
                      do_jitter = TRUE,
                      Njitter = 200,
                      jitterFraction = 0.1
                      ){
  
  if(do_retro == TRUE){
    
    ## Do Retrospectives
    r4ss::retro(masterdir=file.path(root_dir, "SS3 models", species, file_dir), 
               oldsubdir="", newsubdir="Retrospectives", years=retro_years)
    
    
  }
  
  if(do_profile == TRUE){
    ## Create directory and copy inputs
    dir.profile <- file.path(root_dir, "SS3 models", species, file_dir, paste0(profile, "_profile"))
    r4ss::copy_SS_inputs(dir.old = file.path(root_dir, "SS3 models", species, file_dir),
                   dir.new = dir.profile,
                   create.dir = TRUE,
                   overwrite = TRUE,
                   recursive = TRUE,
                   use_ss_new = TRUE,
                   copy_exe = TRUE,
                   copy_par = FALSE,
                   dir.exe = file.path(root_dir, "SS3 models", species, file_dir),
                   verbose = TRUE)
    
    # Make changes to starter file
    starter <- r4ss::SS_readstarter(file.path(dir.profile, "starter.ss"))
    starter[["ctlfile"]] <- "control_modified.ss"
    # make sure the prior likelihood is calculated
    # for non-estimated quantities
    starter[["prior_like"]] <- 1
    r4ss::SS_writestarter(starter, dir = dir.profile, overwrite = TRUE)
    
    # vector of values to profile over
    
    #Nprofile <- length(profile.vec)
    
    ## Do Profiling
    profile <- r4ss::SS_profile(
      dir = dir.profile, 
      model = "ss_opt_win",
      masterctlfile = "control.ss",
      newctlfile = "control_modified.ss",
      string = profile,
      profilevec = profile.vec
    )
    
  }
  
  if(do_jitter == TRUE){
    
    dir.jitter <- file.path(root_dir, "SS3 models", species, file_dir, "jitter")
    r4ss::copy_SS_inputs(dir.old = file.path(root_dir, "SS3 models", species, file_dir),
                         dir.new = dir.jitter,
                         create.dir = TRUE,
                         overwrite = TRUE,
                         recursive = TRUE,
                         use_ss_new = TRUE,
                         copy_exe = TRUE,
                         copy_par = TRUE,
                         dir.exe = file.path(root_dir, "SS3 models", species, file_dir),
                         verbose = TRUE)
    
    
    # Step 7. Run jitter using this function (deafult is nohess)
    jit.likes <- r4ss::SS_RunJitter(mydir=dir.jitter, 
                                    model = "ss_opt_win.exe",
                              Njitter=Njitter, 
                              jitter_fraction = jitterFraction, 
                              init_values_src = 1)
    
  }
}





