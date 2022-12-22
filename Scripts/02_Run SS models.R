require(pacman); pacman::p_load(this.path, parallel); root_dir <- here(..=1); set.seed(123)

Lt     <-vector("list",9) # Species options
#             Name    M                  Growth             LW             Mat           InitF? R0 prof.  Btarg. SupYer?   SuperYr blocks                        # Projections catch range
Lt[[1]]<-list("APRU", "SW_Then",         "SW_BBS_BIOS",     "Kamikawa",    "SW_BBS_BIOS", F, c(0.4,1.4), 0.29,    T, list(c(2019,2020)),                          c(1,4,0.2)) 
Lt[[2]]<-list("APVI", "OMalley_Then",    "OMalley2",        "Kamikawa",    "Everson",     F, c(0.6,1.6), 0.29,    T, list(c(2004,2006),c(2010,2012)),             c(1.4,3,0.1)) 
Lt[[3]]<-list("CALU", "Fry_Then",        "SW_BBS_BIOS",     "Kamikawa",    "SW_BBS_BIOS", F, c(0.8,1.8), 0.29,    T, list(c(2009,2011),c(2016,2017),c(2018,2020)),c(0.8,2.0,0.1)) 
Lt[[4]]<-list("ETCO", "Andrews_Then",    "Andrews_Sex",     "Kamikawa",    "Reed",        F, c(0.5,1.3), 0.29,    T, list(c(2018,2020)),                          c(1,2.5,0.1)) 
Lt[[5]]<-list("LERU", "Loubens_Then",    "Loubens",         "Kamikawa",    "Loubens",     T, c(2.6,3.6), 0.29,    F, NA,                                          c(3,5,0.1)) 
Lt[[6]]<-list("LUKA", "Loubens_Then",    "Loubens2",        "Kamikawa",    "SW_BBS_BIOS", T, c(5.4,7.0), 0.25,    F, NA,                                          c(1,8,1)) 
Lt[[7]]<-list("PRFL", "OMalley_Then",    "OMalley",         "Kamikawa",    "SW_BBS_BIOS", F, c(0.5,1.5), 0.29,    T, list(c(2004,2005),c(2011,2012),c(2018,2020)),c(0.5,1.5,0.1)) 
Lt[[8]]<-list("PRZO", "Schemmel_Then",   "Schemmel_Sex",    "Kamikawa",    "Schemmel",    F, c(0.5,1.3), 0.29,    T, list(c(2009,2011),c(2012,2014),c(2015,2016), c(2018,2020)),c(0.5,1.0,0.05)) 
Lt[[9]]<-list("VALO", "Grandcourt_Then", "SW_BBS_BIOS",     "Kamikawa",    "Schemmel",    F, c(1.0,2.4), 0.33,    F, list(c(2016,2020)),                          c(0.1,0.95,0.05)) 

for(i in 1:9){  Lt[[i]]        <- append(Lt[[i]], root_dir)
names(Lt[[i]]) <- c("N","M","G","LW","MT","IF","R0","Btarg","SY","SY_block","FixedCatchSeq","root")}

#cl    <- makeCluster (9)
lapply(list(Lt[[6]]),function(x)     { # Run a single model
#parLapply(cl,Lt,function(x){ # Run all models
  
  DirName    <- "50_Base"
  runmodels  <- F   # Turn off if you want to process results only
  printreport<- T   # Turn off to skip ss_diags report
  N_boot     <- 0   # Set to 0 to turn bootstrap off
  N_foreyrs  <- 0   # Set to 0 to turn forecast off
  RD         <- F   # Run Diagnostics (jitter, profile, retro)
  ProfRes    <- 0.1 # R0 profile resolution
  Begin      <- c(1967,1986)[1]
  DeleteForecastFiles <- T
  SavedCores <- 2
  Create_species_report_figs <- T
  
  require(pacman); pacman::p_load(boot,data.table,httr,lubridate,ggpubr,grid,parallel,purrr,googledrive,googlesheets4,gt,quarto,openxlsx,tidyverse,r4ss,officer,flextable)
  source(file.path(x$root,"Scripts","02_SS scripts","01_Build_All_SS.R")); source(file.path(x$root,"Scripts","02_SS scripts","06_Run_Diags.R"))
  model_dir <- file.path(x$root,"SS3 models",x$N,DirName)
  
  # Species options
  Build_All_SS(species       = x$N, EST_option = "Normal", scenario = "base",
               SR_option     = "FishLife", M_option = x$M, GROWTH_option = x$G,
               LW_option     = x$LW,MAT_option = x$MT, initF = x$IF,
               startyr       = Begin, endyr = 2021, fleets = 1, N_samp = 40,
               write_files   = T, runmodels = runmodels, ext_args = "",
               do_retro      = RD,retro_years = 0:-5,
               do_profile    = RD,profile = "SR_LN(R0)",
               profile.vec   = seq(x$R0[1], x$R0[2], ProfRes),
               do_jitter     = RD, Njitter = 2,jitterFraction = 0.1,
               printreport   = printreport, r4ssplots = runmodels,
               superyear     = x$SY,superyear_blocks = x$SY_block,
               F_report_basis = 0,lambdas = F,includeCPUE = T,init_values = 0,parmtrace = 0,last_est_phs = 10,
               seed = 123, SPR.target = 0.4, Btarget = x$Btarg, Bmark_relF_Basis = 1,
               file_dir = DirName, root_dir = x$root, 
               template_dir = file.path(x$root, "SS3 models", "TEMPLATE_FILES"), 
               out_dir = file.path(x$root, "SS3 models"), readGoogle = TRUE)
  
  if(N_boot!=0 & N_foreyrs==0){
    source(file.path(x$root, "Scripts","02_SS scripts","07_Run_Bootstraps.R"))
    source(file.path(x$root, "Scripts","03_Report scripts","Create_Boot_Tables.R"))
    source(file.path(x$root, "Scripts","03_Report scripts","Create_Boot_Figs.R"))
    Run_Bootstraps(model_dir, N_boot=N_boot, endyr=2021, seed = 123)
    Create_Boot_Tables(x$root,model_dir)
    Create_Boot_Figs(x$root,model_dir)
}
  
  if(N_foreyrs>0){  
    source(file.path(x$root, "Scripts", "02_SS scripts", "08_Run_Forecasts.R"))
    source(file.path(x$root,"Scripts","03_Report scripts","Create_Forecast_Figs_Tables.R"))
    Run_Forecasts(model_dir, N_foreyrs=N_foreyrs, FixedCatchSeq=x$FixedCatchSeq, endyr=2021,SavedCores,DeleteForecastFiles, seed = 123)
    Create_Forecast_Figs_Tables(x$root,model_dir)
  } 
  
  if(Create_species_report_figs){
    
    file.copy(from = file.path(x$root,"Scripts","03_Report scripts",
                               "Create_Figs_Tables_Formatted.qmd"), 
              to = file.path(model_dir, 
                             "Create_Figs_Tables_Formatted.qmd"),
              overwrite = TRUE)
    quarto::quarto_render(
      input = file.path(model_dir,
                        "Create_Figs_Tables_Formatted.qmd"),
      output_format = "docx",
      execute_params = list(
        species = paste0(x$N),
        scenario = DirName
      ),
      execute_dir = model_dir)
    
  }
  
})



#stopCluster (cl)









