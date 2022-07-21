#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOTTOMFISH - INITIAL SS FORECAST FILE CREATION
#	Use example model files (from https://github.com/nmfs-stock-synthesis/user-examples) as templates 
#   for forecast file
#	Megumi Oshima megumi.oshima@noaa.gov
#  
#  --------------------------------------------------------------------------------------------------------------
## Forecast file
#  --------------------------------------------------------------------------------------------------------------
build_forecast <- function(species, 
                           scenario = "base",
                           file_dir = "base",
                           template_dir = file.path(root_dir, "SS3_models", "TEMPLATE_FILES", "forecast.ss"),
                           out_dir = file.path(root_dir, "SS3_models"),
                           benchmarks = 1,
                           MSY = 2,
                           endyr = 2021,
                           SPR.target = 0.4,
                           Btarget = 0.4,
                           Bmark_years = c(0,0,0,0,0,0,0,0,0,0),
                           Bmark_relF_Basis = 1,
                           Forecast = 1,
                           Nforeyrs = 10, 
                           Fcast_years = c(0,0,-10,0,-999,0),
                           ControlRule = 0){
  ## STEP 1. Read in template forecast file
  FORE <- r4ss::SS_readforecast(file = file.path(template_dir, "forecast.ss"))
  
  ## STEP 2. Make any necessary changes
  #  --------------------------------------------------------------------------------------------------------------
  ## most common inputs to change:
  FORE$benchmarks                         <- benchmarks #calculate F_spr
  FORE$MSY                                <- MSY #calculate F(MSY)
  FORE$SPRtarget                          <- SPR.target
  FORE$Btarget                            <- Btarget
  
  FORE$Bmark_years                        <- Bmark_years 
  FORE$Bmark_relF_Basis                   <- Bmark_relF_Basis #use year range
  FORE$Forecast                           <- Forecast #F(SPR)
  FORE$Nforecastyrs                       <- Nforeyrs
  
  #beg_selex, end_selex, beg_relF, end_relF, beg_mean recruits, end_recruits
  FORE$Fcast_years                        <- Fcast_years
  FORE$ControlRuleMethod                  <- ControlRule
  
  FORE$FirstYear_for_caps_and_allocations <- endyr + 2
  
  ## STEP 3. Save updated file
  #  --------------------------------------------------------------------------------------------------------------
  r4ss::SS_writeforecast(FORE, dir = file.path(out_dir, species, file_dir),
                         writeAll = TRUE, overwrite = TRUE)
  
}
