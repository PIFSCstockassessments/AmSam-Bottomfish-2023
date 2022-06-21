require(pacman)
pacman::p_load(boot,data.table,ggfortify,grid,gridExtra,directlabels,mgcv,ncdf4,
               httr,lubridate,lunar,purrr,googledrive,googlesheets4,RColorBrewer,
               tidyverse,this.path,viridis,r4ss,nFactors,openxlsx)

# Script for build_all_ss function
source(paste0(here(..=1),"/Scripts/11_BUILD_SS3_MODEL.R"))

# Run for a single species
build_all_ss(species = "APVI",
             scenario = "base",
             startyr = 1967,
             endyr = 2021,
             fleets = 1,
             M_option = "Option1",
             GROWTH_option = "Option1",
             LW_option = "Option1",
             MAT_option = "Option1",
             SR_option = "Option1",
             EST_option = "Option1",
             lambdas = NULL,
             includeCPUE = TRUE,
             init_values = 0, 
             parmtrace = 0,
             N_boot = 1,
             last_est_phs = 10,
             seed = 0123,
             benchmarks = 1,
             MSY = 2,
             SPR.target = 0.4,
             Btarget = 0.4,
             Bmark_years = c(0,0,0,0,0,0,0,0,0,0),
             Bmark_relF_Basis = 1,
             Forecast = 1,
             Nforeyrs = 1, 
             Fcast_years = c(0,0,-10,0,-999,0),
             ControlRule = 0,
             root_dir = this.path::here(.. = 1),
             file_dir = "BASE_bio",
             template_dir = file.path(this.path::here(.. = 1), "SS3 models", "TEMPLATE_FILES"), 
             out_dir = file.path(this.path::here(.. = 1), "SS3 models"),
             runmodels = TRUE,
             ext_args = "-nohess",
             printreport = F,
             r4ssplots = F
)


source(paste0(here(..=1),"/Scripts/12_RUN_DIAGS.R"))

run_diags(root_dir = this.path::here(.. = 1),
          species = "APVI",
          file_dir = "test",
          do_retro = TRUE,
          retro_years = 0:-3,
          do_profile = FALSE,
          profile = "SR_LN(R0)",
          profile.vec = seq(8.2, 8.4, .1),
          do_jitter = FALSE,
          Njitter = 2,
          jitterFraction = 0.1
)

# Build and run models for all species in a loop
Species.List <- c("APRU", "APVI", "CALU", "LERU", "LUKA", "ETCO", "PRFL", "PRZO", "VALO")
for(i in seq_along(Species.List)){
  
  species <- Species.List[i]
  
  build_all_ss(species,
               scenario = "base",
               startyr = 1967,
               endyr = 2021,
               fleets = 1,
               M_option = "Option1",
               SR_option = "Option1",
               Q_option = "Option1",
               LSEL_option = "Option1",
               ASEL_option = "Option1",
               includeCPUE = TRUE,
               init_values = 0, 
               parmtrace = 0,
               N_boot = 1,
               last_est_phs = 10,
               seed = 0123,
               benchmarks = 1,
               MSY = 2,
               SPR.target = 0.4,
               Btarget = 0.4,
               Bmark_years = c(0,0,0,0,0,0,0,0,0,0),
               Bmark_relF_Basis = 1,
               Forecast = 1,
               Nforeyrs = 10, 
               Fcast_years = c(0,0,-10,0,-999,0),
               ControlRule = 0,
               root_dir = this.path::here(.. = 1),
               file_dir = scenario,
               template_dir = file.path(root_dir, "SS3 models", "TEMPLATE_FILES"), 
               out_dir = file.path(root_dir, "SS3 models"),
               runmodels = TRUE,
               ext_args = "-stopph 3 -nohess",
               printreport = FALSE)
}
