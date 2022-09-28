require(pacman); pacman::p_load(this.path, parallel); root_dir <- here(..=1)

# Select species to run projections on using a number
aSp.Num <- 1

# Load all SS options for all species and store in a list
Lt     <-vector("list",9) # Species options
#             Name    M                  Growth             LW             Mat      InitF? R0 prof.  Btarg. SupYer?   SuperYr blocks
Lt[[1]]<- list("APRU", "SW_Then",         "SW_BBS",          "Kamikawa",   "SW_BBS",   F, c(0.4,1.4), 0.29,    T, list(c(2019,2020))) 
Lt[[2]]<-list("APVI", "OMalley_Then",    "OMalley2",        "Biosampling", "Everson",  F, c(0.6,1.6), 0.29,    T, list(c(2004,2006),c(2010,2012))) 
Lt[[3]]<-list("CALU", "Fry_Then",        "SW_DIV",          "Kamikawa",    "SW_DIV",   F, c(1.3,2.1), 0.29,    T, list(c(2009,2011),c(2016,2017),c(2018,2020))) 
Lt[[4]]<-list("ETCO", "Andrews_Then",    "OMalley_sexspec", "Kamikawa",    "Reed",     F, c(0.5,1.3), 0.29,    T, list(c(2018,2020))) 
Lt[[5]]<-list("LERU", "Loubens_Then",    "Loubens",         "Kamikawa",    "Loubens",  T, c(3.2,4.2), 0.29,    F, NA) 
Lt[[6]]<-list("LUKA", "Morales_Then",    "Loubens2",        "Kamikawa",    "SW_BBS",   T, c(5.4,7.0), 0.23,    F, list(c(2012,2013))) 
Lt[[7]]<-list("PRFL", "OMalley_Then",    "OMalley",         "Kamikawa",    "Brouard",  F, c(0.5,1.5), 0.29,    T, list(c(2004,2005),c(2011,2012),c(2018,2020))) 
Lt[[8]]<-list("PRZO", "Schemmel_Then",   "Schemmel_Sex",    "Kamikawa",    "Schemmel", F, c(0.5,1.3), 0.29,    T, list(c(2009,2011),c(2012,2014),c(2015,2016),c(2018,2020))) 
Lt[[9]]<-list("VALO", "Grandcourt_Then", "Schemmel",        "Kamikawa",    "Schemmel", F, c(1.0,2.4), 0.29,    T, list(c(2016,2020))) 

for(i in 1:9){  
  Lt[[i]] <- append(Lt[[i]], root_dir)
  names(Lt[[i]]) <- c("N","M","G","LW","MT","IF","R0","Btarg","SY","SY_block","root")
}

# Step 2: Load all Fixed Catch ranges for all species and store in a list

Ct      <- vector("list",9) # Fixed catch ranges for all species
Ct[[1]] <- as.list( seq(0,1.7,0.1) )
Ct[[2]] <- as.list( seq(0,1.7,0.1) )
Ct[[3]] <- as.list( seq(0,1.7,0.1) )
Ct[[4]] <- as.list( seq(0,1.7,0.1) )
Ct[[5]] <- as.list( seq(0,1.7,0.1) )
Ct[[6]] <- as.list( seq(0,1.7,0.1) )
Ct[[7]] <- as.list( seq(0,1.7,0.1) )
Ct[[8]] <- as.list( seq(0,1.7,0.1) )
Ct[[9]] <- as.list( seq(0,1.7,0.1) )

# Create an input list to feed into the parLapply function
Num.ProjCatch <- length(Ct[[aSp.Num]])
Inp.Lst       <- vector("list",Num.ProjCatch)
for(i in 1:Num.ProjCatch){
  Inp.Lst[[i]]            <- append(Lt[[aSp.Num]],Ct[[aSp.Num]][[i]])  
  names(Inp.Lst[[i]])[12] <- "FixedCatch"
}
  
#cl    <- makeCluster (5)
lapply(list(Inp.Lst[[1]]),function(x)     { # Run a single model for testing purposes
  #parLapply(cl,Lt,function(x){ # Run all models
  
  RD      <- F
  Begin   <- c(1967,1986)[1]
  DirName <- "30_TestBootFore"
  ProfRes <- 0.2
  
  require(pacman); pacman::p_load(boot,data.table,httr,lubridate,parallel,purrr,googledrive,googlesheets4,gt,quarto,tidyverse,r4ss)
  source(file.path(x$root,"Scripts","11_BUILD_SS3_MODEL.R")); source(file.path(x$root,"Scripts","12_RUN_DIAGS.R"))
  
  # Species options
  build_all_ss(species       = x$N, file_dir = DirName, EST_option = "Normal", scenario = "base",
               SR_option     = "FishLife", M_option = x$M, GROWTH_option = x$G,
               LW_option     = x$LW,MAT_option = x$MT, initF = x$IF,
               startyr       = Begin, endyr = 2021,fleets = 1, N_samp = 40,
               write_files   = T, runmodels = T, ext_args = "",
               do_retro      = RD,retro_years = 0:-3,
               do_profile    = RD,profile = "SR_LN(R0)",
               profile.vec   = seq(x$R0[1], x$R0[2], ProfRes),
               do_jitter     = RD, Njitter = 2,jitterFraction = 0.1,
               printreport   = RD, r4ssplots = T,
               superyear     = x$SY,superyear_blocks = x$SY_block,
               Fixed_forecatch = x$FixedCatch, Forecast = 2, Nforeyrs = 6,
               F_report_basis = 0,lambdas = F,includeCPUE = T,init_values = 0,parmtrace = 0,N_boot = 5,last_est_phs = 10,
               seed = 0123,benchmarks = 1,MSY = 2,SPR.target = 0.4,Btarget = x$Btarg,Bmark_years = c(0,0,0,0,0,0,0,0,0,0),
               Bmark_relF_Basis = 1,Fcast_years = c(0,0,0,0,-999,0),ControlRule = 0,
               root_dir = x$root, template_dir = file.path(x$root, "SS3 models", "TEMPLATE_FILES"), out_dir = file.path(x$root, "SS3 models"))  
})

stopCluster (cl)


