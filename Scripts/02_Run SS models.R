require(pacman); pacman::p_load(this.path, parallel); root_dir <- here(..=1)

Lt     <-vector("list",9) # Species options
#             Name    M                  Growth             LW             Mat      InitF? R0 prof.  Btarg. SupYer?   SuperYr blocks                        # Projections catch range
Lt[[1]]<-list("APRU", "SW_Then",         "SW_BBS",          "Kamikawa",    "SW_BBS",   F, c(0.4,1.4), 0.29,    T, list(c(2019,2020)),                           c(1,4,0.2)) 
Lt[[2]]<-list("APVI", "OMalley_Then",    "OMalley2",        "Biosampling", "Everson",  F, c(0.6,1.6), 0.29,    T, list(c(2004,2006),c(2010,2012)),              c(1,2,0.1)) 
Lt[[3]]<-list("CALU", "Fry_Then",        "SW_DIV",          "Kamikawa",    "SW_DIV",   F, c(1.3,2.1), 0.29,    T, list(c(2009,2011),c(2016,2017),c(2018,2020)), c(1,4,0.2)) 
Lt[[4]]<-list("ETCO", "Andrews_Then",    "Andrews_Sex",     "Kamikawa",    "Reed",     F, c(0.5,1.3), 0.29,    T, list(c(2018,2020)),                           c(1,4,0.2)) 
Lt[[5]]<-list("LERU", "Loubens_Then",    "Loubens",         "Kamikawa",    "Loubens",  T, c(3.2,4.2), 0.29,    F, NA,                                           c(1,4,0.2)) 
Lt[[6]]<-list("LUKA", "Morales_Then",    "Loubens2",        "Kamikawa",    "SW_BBS",   T, c(5.4,7.0), 0.23,    F, list(c(2012,2013)),                           c(1,4,0.2)) 
Lt[[7]]<-list("PRFL", "OMalley_Then",    "OMalley",         "Kamikawa",    "Brouard",  F, c(0.5,1.5), 0.29,    T, list(c(2004,2005),c(2011,2012),c(2018,2020)), c(1,4,0.2)) 
Lt[[8]]<-list("PRZO", "Schemmel_Then",   "Schemmel_Sex",    "Kamikawa",    "Schemmel", F, c(0.5,1.3), 0.29,    T, list(c(2009,2011),c(2012,2014),c(2015,2016),c(2018,2020)),c(1,4,0.2)) 
Lt[[9]]<-list("VALO", "Grandcourt_Then", "Schemmel",        "Kamikawa",    "Schemmel", F, c(1.0,2.4), 0.29,    T, list(c(2016,2020)),                           c(1,4,0.2)) 

for(i in 1:9){  Lt[[i]]        <- append(Lt[[i]], root_dir)
names(Lt[[i]]) <- c("N","M","G","LW","MT","IF","R0","Btarg","SY","SY_block","FixedCatchSeq","root")}

cl    <- makeCluster (5)
#lapply(list(Lt[[1]]),function(x)     { # Run a single model
parLapply(cl,Lt,function(x){ # Run all models
  
  DirName   <- "40_Base"
  runmodels <- F   # Turn off if youy want to process results only
  N_boot    <- 0   # Set to 0 to turn bootstrap off
  N_foreyrs <- 0   # Set to 0 to turn forecast off
  RD        <- F   # Run Diagnostics (jitter, profile, retro)
  ProfRes   <- 0.1 # R0 profile resolution
  Begin     <- c(1967,1986)[1]
  
  require(pacman); pacman::p_load(boot,data.table,httr,lubridate,ggpubr,parallel,purrr,googledrive,googlesheets4,gt,quarto,tidyverse,r4ss)
  source(file.path(x$root,"Scripts","02_SS scripts","01_Build_All_SS.R")); source(file.path(x$root,"Scripts","02_SS scripts","06_Run_Diags.R"))
  
  # Species options
  Build_All_SS(species       = x$N, EST_option = "Normal", scenario = "base",
               SR_option     = "FishLife", M_option = x$M, GROWTH_option = x$G,
               LW_option     = x$LW,MAT_option = x$MT, initF = x$IF,
               startyr       = Begin, endyr = 2021, fleets = 1, N_samp = 40,
               write_files   = T, runmodels = runmodels, ext_args = "",
               do_retro      = RD,retro_years = 0:-3,
               do_profile    = RD,profile = "SR_LN(R0)",
               profile.vec   = seq(x$R0[1], x$R0[2], ProfRes),
               do_jitter     = RD, Njitter = 2,jitterFraction = 0.1,
               printreport   = RD, r4ssplots = T,
               superyear     = x$SY,superyear_blocks = x$SY_block,
               F_report_basis = 0,lambdas = F,includeCPUE = T,init_values = 0,parmtrace = 0,last_est_phs = 10,
               seed = 0123, SPR.target = 0.4, Btarget = x$Btarg, Bmark_relF_Basis = 1,
               file_dir = DirName, root_dir = x$root, template_dir = file.path(x$root, "SS3 models", "TEMPLATE_FILES"), out_dir = file.path(x$root, "SS3 models"))
  
  if(N_boot!=0 & N_foreyrs==0){
    source(file.path(x$root, "Scripts", "02_SS scripts", "07_Run_Bootstraps.R"))
    Run_Bootstraps(model_dir=file.path(x$root,"SS3 models",x$N,DirName), N_boot=N_boot, endyr=2021)
  }
  
  if(N_foreyrs>0){  
    source(file.path(x$root, "Scripts", "02_SS scripts", "08_Run_Forecasts.R"))
    Run_Forecasts(model_dir=file.path(x$root,"SS3 models",x$N,DirName), N_boot=N_boot, N_foreyrs=N_foreyrs, FixedCatchSeq=x$FixedCatchSeq, endyr=2021)
  }    
})

stopCluster (cl)










