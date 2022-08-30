require(pacman); pacman::p_load(boot,data.table,ggfortify,grid,gridExtra,directlabels,mgcv,ncdf4,
                                httr,lubridate,lunar,parallel,purrr,googledrive,googlesheets4,gt,quarto,RColorBrewer,
                                tidyverse,this.path,viridis,r4ss,nFactors,openxlsx)

root_dir <- here(..=1)

# Species options
Lt     <-list(length=9)
Lt[[1]]<-list(N="APRU",M="SW_Then",        G="SW_BBS",         LW="Kamikawa",   MT="SW_BBS",  IF=F,R0=c(0.2,1.6),SY=list(c(2019,2020)),root=root_dir) 
Lt[[2]]<-list(N="APVI",M="OMalley_Then",   G="OMalley2",       LW="Biosampling",MT="Everson", IF=F,R0=c(0.4,1.6),SY=list(c(2004,2006),c(2010,2012)),root=root_dir) 
Lt[[3]]<-list(N="CALU",M="Fry_Then",       G="SW_DIV",         LW="Kamikawa",   MT="SW_DIV",  IF=F,R0=c(1.0,3.0),SY=list(c(2009,2011),c(2016,2017),c(2018,2020)),root=root_dir) 
Lt[[4]]<-list(N="ETCO",M="Andrews_Then",   G="Andrews_sexspec",LW="Kamikawa",   MT="Reed",    IF=F,R0=c(0.5,1.3),SY=list(c(2018,2020)),root=root_dir) 
Lt[[5]]<-list(N="LERU",M="Loubens_Then",   G="Loubens",        LW="Kamikawa",   MT="Loubens", IF=T,R0=c(3.2,4.2),SY=NULL,root=root_dir) 
Lt[[6]]<-list(N="LUKA",M="Morales_Then",   G="Loubens2",       LW="Kamikawa",   MT="SW_BBS",  IF=T,R0=c(5.0,7.5),SY=list(c(2012,2013)),root=root_dir) 
Lt[[7]]<-list(N="PRFL",M="OMalley_Then",   G="OMalley",        LW="Kamikawa",   MT="Brouard", IF=F,R0=c(0.5,1.5),SY=list(c(2004,2005),c(2011,2012),c(2018,2020)),root=root_dir) 
Lt[[8]]<-list(N="PRZO",M="Schemmel_Then",  G="Schemmel_Sex",   LW="Kamikawa",   MT="Schemmel",IF=F,R0=c(0.5,1.2),SY=list(c(2009,2011),c(2012,2014),c(2015,2016),c(2018,2020)),root=root_dir) 
Lt[[9]]<-list(N="VALO",M="Grandcourt_Then",G="Schemmel",       LW="Kamikawa",   MT="Schemmel",IF=F,R0=c(1.0,3.6),SY=list(c(2016,2020)),root=root_dir) 

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
  SuperYr <- T
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
               superyear     = SuperYr,
               superyear_blocks = x$SY,
               lambdas = F,includeCPUE = T,init_values = 0,parmtrace = 0,N_boot = 0,last_est_phs = 10,
               seed = 0123,benchmarks = 1,MSY = 2,SPR.target = 0.4,Btarget = 0.3,Bmark_years = c(0,0,0,0,0,0,0,0,0,0),
               Bmark_relF_Basis = 1,Forecast = 1,Nforeyrs = 1,Fcast_years = c(0,0,-10,0,-999,0),ControlRule = 0,
               root_dir = x$root,
               template_dir = file.path(x$root, "SS3 models", "TEMPLATE_FILES"), 
               out_dir = file.path(x$root, "SS3 models"))
})

stopCluster (cl)




