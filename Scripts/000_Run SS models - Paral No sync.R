require(pacman); pacman::p_load(boot,data.table,ggfortify,grid,gridExtra,directlabels,mgcv,ncdf4,
                                httr,lubridate,lunar,parallel,purrr,googledrive,googlesheets4,gt,quarto,RColorBrewer,
                                tidyverse,this.path,viridis,r4ss,nFactors,openxlsx)

root_dir <- here(..=1)

# Species options
Lt     <-vector("list",9)
#             Name    M                  Growth             LW             Mat      InitF? R0 prof. SupYer?   SuperYr blocks
Lt[[1]]<-list("APRU", "SW_Then",         "SW_BBS",          "Kamikawa",    "SW_BBS",   F, c(0.2,1.6), T, list(c(2019,2020))) 
Lt[[2]]<-list("APVI", "OMalley_Then",    "OMalley2",        "Biosampling", "Everson",  F, c(0.4,1.6), T, list(c(2004,2006),c(2010,2012))) 
Lt[[3]]<-list("CALU", "Fry_Then",        "SW_DIV",          "Kamikawa",    "SW_DIV",   F, c(1.0,3.0), T, list(c(2009,2011),c(2016,2017),c(2018,2020))) 
Lt[[4]]<-list("ETCO", "Andrews_Then",    "Andrews_sexspec", "Kamikawa",    "Reed",     F, c(0.5,1.3), T, list(c(2018,2020))) 
Lt[[5]]<-list("LERU", "Loubens_Then",    "Loubens",         "Kamikawa",    "Loubens",  T, c(3.2,4.2), F, NA) 
Lt[[6]]<-list("LUKA", "Morales_Then",    "Loubens2",        "Kamikawa",    "SW_BBS",   T, c(5.0,7.5), T, list(c(2012,2013))) 
Lt[[7]]<-list("PRFL", "OMalley_Then",    "OMalley",         "Kamikawa",    "Brouard",  F, c(0.5,1.5), T, list(c(2004,2005),c(2011,2012),c(2018,2020))) 
Lt[[8]]<-list("PRZO", "Schemmel_Then",   "Schemmel_Sex",    "Kamikawa",    "Schemmel", F, c(0.5,1.2), T, list(c(2009,2011),c(2012,2014),c(2015,2016),c(2018,2020))) 
Lt[[9]]<-list("VALO", "Grandcourt_Then", "Schemmel",        "Kamikawa",    "Schemmel", F, c(1.0,3.6), T, list(c(2016,2020))) 

for(i in 1:9){
  Lt[[i]]        <- append(Lt[[i]], root_dir)
  names(Lt[[i]]) <- c("N","M","G","LW","MT","IF","R0","SY","SY_block","root")
}

cl <- makeCluster (7)

parLapply(cl,Lt,function(x){
  
  require(pacman); pacman::p_load(boot,data.table,ggfortify,grid,gridExtra,directlabels,mgcv,ncdf4,
                                  httr,lubridate,lunar,parallel,purrr,googledrive,googlesheets4,gt,quarto,RColorBrewer,
                                  tidyverse,this.path,viridis,r4ss,nFactors,openxlsx)
  
  
  source(file.path(x$root,"Scripts","11_BUILD_SS3_MODEL.R"))
  source(file.path(x$root,"Scripts","12_RUN_DIAGS.R"))
  
  
  # General options
  RD      <- T
  Begin   <- c(1967,1986)[1]
  DirName <- "21_F3_Dirich"
  ProfRes <- 0.1
  
  # Species options
  build_all_ss(species       = x$N,
               file_dir      = DirName,
               EST_option    = "Normal",
               SR_option     = "FishLife",
               M_option      = x$M,
               GROWTH_option = x$G,
               LW_option     = x$LW,
               MAT_option    = x$MT,
               scenario      = "base",
               initF         = x$IF,
               startyr       = Begin,
               endyr         = 2021,
               fleets        = 1,
               write_files   = TRUE,
               runmodels     = TRUE,
               ext_args      = "",
               do_retro      = RD,
               retro_years   = 0:-3,
               do_profile    = RD,
               profile       = "SR_LN(R0)",
               profile.vec   = seq(x$R0[1], x$R0[2], ProfRes),
               do_jitter     = RD,
               Njitter       = 2,
               jitterFraction = 0.1,
               printreport   = RD,
               r4ssplots     = T,
               N_samp        = 40,
               superyear     = x$SY,
               superyear_blocks = x$SY_block,
               lambdas = F,includeCPUE = T,init_values = 0,parmtrace = 0,N_boot = 0,last_est_phs = 10,
               seed = 0123,benchmarks = 1,MSY = 2,SPR.target = 0.4,Btarget = 0.3,Bmark_years = c(0,0,0,0,0,0,0,0,0,0),
               Bmark_relF_Basis = 1,Forecast = 1,Nforeyrs = 1,Fcast_years = c(0,0,-10,0,-999,0),ControlRule = 0,
               root_dir = x$root,
               template_dir = file.path(x$root, "SS3 models", "TEMPLATE_FILES"), 
               out_dir = file.path(x$root, "SS3 models"))
})

stopCluster (cl)




