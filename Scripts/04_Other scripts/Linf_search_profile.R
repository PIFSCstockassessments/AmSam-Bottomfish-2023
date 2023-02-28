library(r4ss)
library(tidyverse)

require(pacman); pacman::p_load(this.path, parallel); root_dir <- here(..=2)

Lt  <-vector("list",4) # Species options
              #Name, Run dir name, name of param, param min and max to profile
#Lt[[1]]<-list("APRU", "104_Linf_est", "L_at_Amax", c(80,84)) 
Lt[[1]]<-list("APVI", "104_Linf_est","L_at_Amax", c(70,90)) 
Lt[[2]]<-list("CALU", "104_Linf_est","L_at_Amax", c(60,85)) 
Lt[[3]]<-list("LUKA", "104_Linf_est", "L_at_Amax", c(19,27)) 
Lt[[4]]<-list("PRFL", "104_Linf_est", "L_at_Amax", c(37,55)) 


for(i in 1:length(Lt)){  Lt[[i]]        <- append(Lt[[i]], root_dir)
names(Lt[[i]]) <- c("N","dirname", "String", "Prof.vec", "root")}

cl    <- makeCluster (4)
for(i in 1:length(Lt)){
  lapply(list(Lt[[i]]),function(x)     { # Run a single model
    #parLapply(cl,Lt,function(x){ # Run all models
    
    if(x$N == "LUKA"){
      ProfRes <- 0.1
    }else{
      ProfRes <- 1
    }
      
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
Lt  <-vector("list",2) # Species options
#Name, Run dir name, name of param, param min and max to profile
#Lt[[1]]<-list("ETCO", "104_Linf_est", c("L_at_Amax_Fem","L_at_Amax_Mal"), c(87,91)) 
Lt[[1]]<-list("LERU", "104_Linf_est", c("L_at_Amax_Fem","L_at_Amax_Mal"), c(28,42))
#Lt[[2]]<-list("PRZO", "104_Linf_est", c("L_at_Amax_Fem"), c(33,50))
Lt[[2]]<-list("VALO", "104_Linf_est", c("L_at_Amax_Fem","L_at_Amax_Mal"), c(42,60)) 
for(i in 1:length(Lt)){  Lt[[i]]        <- append(Lt[[i]], root_dir)
names(Lt[[i]]) <- c("N","dirname", "String", "Prof.vec", "root")}


cl    <- makeCluster (3)
for(i in 1:length(Lt)){
  
  #parLapply(cl,Lt,function(x){ # Run all models
  lapply(list(Lt[[i]]),function(x)     {
    ProfRes <- 1
    
    require(pacman); pacman::p_load(r4ss)
    
    dir.profile <- file.path(x$root,"SS3 models",x$N,x$dirname)


if(x$N == "PRZO"){
  
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
  control$MG_parms$INIT[2] <- 12.7
  control$MG_parms$INIT[3] <- 36.9
  control$MG_parms$INIT[4] <- 0.29
  
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
  
  linf_vec <- seq(x$Prof.vec[1], x$Prof.vec[2], by = ProfRes)
  
  par_table <- data.frame("L_at_Amax_Fem" = linf_vec, 
                          "L_at_Amax_Mal" = linf_vec)
  
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
stopCluster (cl)
