## Request from reviewers
## This code runs profiles across a range of M values for each species to try and determine at what M will the stock be overfished. The code is divided into 2 sections, one for the species with single-sex growth curves, and the second section for species with 2-sex growth curves.

require(pacman); pacman::p_load(this.path, parallel, r4ss, tidyverse); root_dir <- here(..=2)
## Create a list of 5 objects for each single-sex growth curve species. Include the species ID code, the name of the directory to run the models in, the name of the parameter to be profiled across, and the range of values to be profiled across.
Lt  <-vector("list",5) # Species options
#Name, Run dir name, name of param, param min and max to profile
Lt[[1]]<-list("APRU", "105_M_est", "NatM", c(0.32,0.38)) 
Lt[[2]]<-list("APVI", "105_M_est","NatM", c(0.1,0.25)) 
Lt[[3]]<-list("CALU", "105_M_est","NatM", c(0.39, 0.53)) 
Lt[[4]]<-list("LUKA", "105_M_est", "NatM", c(0.58,0.74)) 
Lt[[5]]<-list("PRFL", "105_M_est", "NatM", c(0.05,0.25)) 

## Name each item in lists
for(i in 1:length(Lt)){  Lt[[i]]        <- append(Lt[[i]], root_dir)
names(Lt[[i]]) <- c("N","dirname", "String", "Prof.vec", "root")}

## For running in parallel, make sure you are using fewer than the max number of cores on your computer.
cl    <- makeCluster (5)
for(i in 1:length(Lt)){
  #lapply(list(Lt[[i]]),function(x)     { # Run a single model at a time, not in parallel
  parLapply(cl,Lt,function(x){ # Run all models in parallel
    
    ProfRes <- .01
    
    require(pacman); pacman::p_load(r4ss)
    
    
    dir.profile <- file.path(x$root,"SS3 models",x$N,x$dirname)
    r4ss::copy_SS_inputs(dir.old = file.path(x$root, "SS3 models", x$N, "65_Base"),
                         dir.new = dir.profile,
                         create.dir = TRUE,
                         overwrite = TRUE,
                         recursive = TRUE,
                         use_ss_new = TRUE,
                         copy_exe = TRUE,
                         copy_par = FALSE,
                         dir.exe = file.path(x$root, "SS3 models", x$N, "65_Base"),
                         verbose = TRUE)
    
    # Make changes to starter file
    starter <- r4ss::SS_readstarter(file.path(dir.profile, "starter.ss"))
    starter[["ctlfile"]] <- "control_modified.ss"
    # make sure the prior likelihood is calculated
    # for non-estimated quantities
    starter[["prior_like"]] <- 1
    r4ss::SS_writestarter(starter, dir = dir.profile, overwrite = TRUE)
    
    ## Do Profiling
    profile <- r4ss::profile(
      dir = dir.profile, 
      exe = "ss_opt_win",
      oldctlfile = "control.ss",
      newctlfile = "control_modified.ss",
      string = x$String,
      profilevec = seq(x$Prof.vec[1], x$Prof.vec[2], by = ProfRes),
      extras = "-nohess"
    )
    
    
  })
  
}

stopCluster (cl)



## Sex-specific cases
Lt  <-vector("list",4) # Species options
#Name, Run dir name, name of param, param min and max to profile
Lt[[1]]<-list("ETCO", "104_Linf_est", c("NatM"), c(.076,.12)) 
Lt[[2]]<-list("LERU", "105_M_est", c("NatM_uniform_Fem","NatM_uniform_Mal"), c(.3,.5))
Lt[[3]]<-list("PRZO", "105_M_est", c("NatM"), c(.1,.3))
Lt[[4]]<-list("VALO", "105_M_est", c("NatM_uniform_Fem","NatM_uniform_Mal"), c(.3,.5)) 
for(i in 1:length(Lt)){  Lt[[i]]        <- append(Lt[[i]], root_dir)
names(Lt[[i]]) <- c("N","dirname", "String", "Prof.vec", "root")}

## Running in parallel doesn't work well for 2 parameter profiling so suggested to run with lapply function instead
#cl    <- makeCluster (3)
for(i in 1:length(Lt)){
  
  #parLapply(cl,Lt,function(x){ # Run all models
  lapply(list(Lt[[i]]),function(x)     {
    
    if(x$N == "ETCO"){
      ProfRes <- 0.002
    }else{
      ProfRes <- 0.01
    }
    
    require(pacman); pacman::p_load(r4ss)
    
    dir.profile <- file.path(x$root,"SS3 models",x$N,x$dirname)
    
    ## If PRZO need to change growth curve values to pooled model values
    if(x$N == "PRZO|ETCO"){
      
      r4ss::copy_SS_inputs(dir.old = file.path(x$root, "SS3 final models", x$N, "08_AlternateLH"),
                           dir.new = dir.profile,
                           create.dir = TRUE,
                           overwrite = TRUE,
                           recursive = TRUE,
                           use_ss_new = TRUE,
                           copy_exe = TRUE,
                           copy_par = FALSE,
                           dir.exe = file.path(x$root, "SS3 final models", x$N, "08_AlternateLH"),
                           verbose = TRUE)
      control <- r4ss::SS_readctl_3.30(file = file.path(dir.profile, "control.ss"), use_datlist = T, 
                                       datlist = file.path(dir.profile, "data.ss"))
      
      if(x$N == "PRZO"){ #use pooled growth curve for PRZO
        control$MG_parms$INIT[2] <- 12.7
        control$MG_parms$INIT[3] <- 36.9
        control$MG_parms$INIT[4] <- 0.29
      }
  
      r4ss::SS_writectl_3.30(control, outfile = file.path(dir.profile, "control.ss"), overwrite = T)
      starter <- r4ss::SS_readstarter(file.path(dir.profile, "starter.ss"))
      starter[["ctlfile"]] <- "control_modified.ss"
      # make sure the prior likelihood is calculated
      # for non-estimated quantities
      starter[["prior_like"]] <- 1
      r4ss::SS_writestarter(starter, dir = dir.profile, overwrite = TRUE)
      
      ## Do Profiling
      profile <- r4ss::profile(
        dir = dir.profile, 
        exe = "ss_opt_win",
        oldctlfile = "control.ss",
        newctlfile = "control_modified.ss",
        string = x$String,
        profilevec = seq(x$Prof.vec[1], x$Prof.vec[2], by = ProfRes),
        extras = "-nohess"
      )
      
    }else{
      
      m_vec <- seq(x$Prof.vec[1], x$Prof.vec[2], by = ProfRes)
      
      par_table <- data.frame("NatM_p_1_Fem" = m_vec, 
                              "NatM_p_1_Male" = m_vec)
      
      r4ss::copy_SS_inputs(dir.old = file.path(x$root, "SS3 models", x$N, "65_Base"),
                           dir.new = dir.profile,
                           create.dir = TRUE,
                           overwrite = TRUE,
                           recursive = TRUE,
                           use_ss_new = TRUE,
                           copy_exe = TRUE,
                           copy_par = FALSE,
                           dir.exe = file.path(x$root, "SS3 models", x$N, "65_Base"),
                           verbose = TRUE)
      
      starter <- r4ss::SS_readstarter(file.path(dir.profile, "starter.ss"))
      starter[["ctlfile"]] <- "control_modified.ss"
      # make sure the prior likelihood is calculated
      # for non-estimated quantities
      starter[["prior_like"]] <- 1
      r4ss::SS_writestarter(starter, dir = dir.profile, overwrite = TRUE)
      
      profile <- r4ss::profile(
        dir = dir.profile,
        exe = "ss_opt_win",
        oldctlfile = "control.ss",
        newctlfile = "control_modified.ss",
        string = x$String,
        profilevec = par_table,
        extras = "-nohess")
      
    }
  })
}
#stopCluster (cl)
