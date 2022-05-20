#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOTTOMFISH - INITIAL SS FILE CREATION
#	Use example model files (from https://github.com/nmfs-stock-synthesis/user-examples) as templates 
#   for adding in American Samoa data
#	Megumi Oshima megumi.oshima@noaa.gov
#  
#  --------------------------------------------------------------------------------------------------------------
## DAT file
#  --------------------------------------------------------------------------------------------------------------
build_dat <- function(species = NULL, catch = NULL, catch_se = 0.05, CPUEinfo = NULL, cpue = NULL, 
                      life.history = NULL, len.comp = NULL, startyr = 1967, endyr = 2021, 
                      bin.list = NULL, fleets = 1, M_option_sp = NULL, fleetinfo = NULL, lbin_method = 1, 
                      template.dir = file.path(root_dir, "SS3 models", "TEMPLATE_FILES"), 
                      out.dir = file.path(root_dir, "SS3 models")){
  
  nfleet <- length(fleets)
  
  ## STEP 2. Read in SS dat file
  DAT <- r4ss::SS_readdat_3.30(file = file.path(template.dir, "data.ss"))
  
  ## STEP 3. Get data in correct format and subset
  if(is.null(catch)) stop("Timeseries of catch is missing")
  
  catch <- catch
  catch$fleet <- 1
  
  catch.sp <- catch %>% 
    as.data.frame() %>% 
    dplyr::filter(str_detect(SPECIES, species)) %>% 
    dplyr::filter(YEAR >= startyr & YEAR <= endyr) %>% 
    dplyr::mutate(seas = 1, 
           fleet = 1,
           catch_se = catch_se,
           catch = LBS/2205) %>% 
    dplyr::rename("year" = YEAR) %>% 
    dplyr::arrange(fleet, year) %>% 
    dplyr::select(-SPECIES) %>% 
    dplyr::select(year, seas, fleet, catch, catch_se)
  
  Nages <- life.history %>% 
    dplyr::filter(str_detect(OPTION, M_option_sp)) %>% 
    dplyr::filter(str_detect(X1, "Nages")) %>% 
    pull(INIT)
  
  len.comp.sp     <- len.comp %>% 
    dplyr::filter(str_detect(SPECIES, species)) %>% 
    dplyr::arrange(LENGTH_BIN_START) %>% 
    dplyr::mutate(Seas = 1,
           FltSvy = as.numeric(factor(DATASET)), 
           Sex = 0, 
           Part = 0, 
           LENGTH_BIN_START = paste0("l",LENGTH_BIN_START)) %>% 
    dplyr::rename(Yr = YEAR,
           Nsamp = EFFN) %>% 
    dplyr::select(Yr, Seas, FltSvy, Sex, Part, Nsamp, LENGTH_BIN_START, N) %>% 
    tidyr::pivot_wider(names_from = LENGTH_BIN_START, values_from = N) %>% 
    dplyr::arrange(Yr)
  
  ## STEP 4. Change inputs for dat file
  
  DAT$Comments        <- paste("#C data file for", species, sep = " ")
  DAT$styr            <- min(catch.sp$year)
  DAT$endyr           <- max(catch.sp$year)
  DAT$nseas           <- 1
  DAT$months_per_seas <- 12
  DAT$Nsubseasons     <- 2 #minimum number is 2
  DAT$spawn_month     <- 1
  DAT$Nsexes          <- 1 #1 ignore fraction female in ctl file, 2 use frac female in ctl file, -1 one sex and multiply spawning biomass by frac female
  DAT$Ngenders        <- NULL
  DAT$Nages           <- Nages
  DAT$N_areas         <- 1 #if want to explore fleets as areas, change this 
  DAT$Nfleets         <- nfleet  #include fishing fleets and surveys
  ## specify the fleet types, timing, area, units, any catch multiplier and fleet name in fleetinfo
  DAT$fleetinfo <- fleetinfo

  if(exists("catch.sp")){
    
    ## Add catch, column names: year, seas, fleet, catch, catch_se
    ## NOTE: will need to adjust if there are multiple fleets with catch
    init.catch <- data.frame(year = -999, seas = 1, fleet = 1, catch = 0, catch_se = 0.01)
    DAT$catch  <- rbind(init.catch, catch.sp) 
    print(DAT$catch)
    
  }else{
    message("No catch to input")
    DAT$catch <- NULL
  }
  
  ## Add CPUE info, column names: Fleet, Units, Errtype, SD_Report
  DAT$CPUEinfo <- CPUEinfo
  
  if(exists("cpue")){

    ## ADD CPUE data, column names: year, seas, index, obs, se_log
    DAT$CPUE <- cpue
    
  }else{
    message("No CPUE to input")
    DAT$CPUE <- NULL
  }
  
  if(exists("discards.sp")){
    DAT$N_discard_fleets <- unique(discards.sp$fleet)
    DAT$discard <- discards.sp
  }else{
    message("No discards to input")
    ## Any discard fleets?
    DAT$N_discard_fleets <- 0
    DAT$discard <- NULL
    
  }
  
  ## Composition data
  
  if(exists("len.comp.sp")){
    
    ## Length Composition 
    DAT$use_lencomp <- 1 #switch to 0 if not using length comp data 
    
    DAT$len_info    <- data.frame(mintailcomp = rep(0, DAT$Nfleets),
                               addtocomp      = rep(0.0000001, DAT$Nfleets),
                               combine_M_F    = rep(0, DAT$Nfleets),
                               CompressBins   = rep(0, DAT$Nfleets),
                               CompError      = rep(0, DAT$Nfleets),
                               ParmSelect     = rep(0, DAT$Nfleets),
                               minsamplesize  = rep(1, DAT$Nfleets))
    DAT$N_lbins     <- length(select(len.comp.sp, starts_with("l")))
    lbin_vector <- colnames(len.comp.sp[-c(1:6)])
    DAT$lbin_vector <- as.numeric(str_sub(lbin_vector, 2))
    
    ## Add length composition data, column names: Yr, Seas, FltSVy, Gender, Part, Nsamp, length_bin_values...
    DAT$lencomp     <- as.data.frame(len.comp.sp)
    
  }else{
    
    message("No length composition to input")
    DAT$use_lencomp <- 0
    DAT$lencomp <- NULL
  }
  
  ## Age Composition
  if(exists("age.comp.sp")){
    
    DAT$N_agebins              <- length(agebin_vector)
    DAT$agebin_vector          <- agebin_vector
    DAT$N_ageerror_definitions <- 1
    DAT$ageerror               <- ageerror # vectors for each definition of mean age and sd associated with the mean age for each age
    ## Dataframe with column names: mintailcomp, addtocomp, combine_M_F, CompressBins, CompError, ParmSelect, minsamplesize
    DAT$age_info
    DAT$Lbin_method            <- 1 #Lbin_method_for_Age_Data, 1 = poplenbins, 2 = datalenbins, 3 = lengths
    DAT$agecomp                <- age.comp
    
  }else{
    
    message("No age composition to input")
    DAT$N_agebins              <- 0
    DAT$agecomp <- NULL
    
  }
  
  ## Mean size-at-age 
  if(exists("size.comp.sp")){
    
    DAT$use_MeanSize_at_Age_obs  <- 1
    DAT$MeanSize_at_Age_obs    <- mean.size.at.age # dataframe with column names: Yr, Seas, FltSvy, Gender, Part, AgeErr, Ignore, age_bins..
    
  }else{
    
    message("No size composition to input")
    DAT$use_MeanSize_at_Age_obs <- 0
    DAT$MeanSize_at_Age_obs <- NULL
    
  }
  
  
  DAT$use_meanbodywt           <- 0
  ## Population length bins
  ## method options include 
  ##      1: use data bins, no other input necessary
  ##      2: generate from bin width, min, and max, specify those values 
  ##      3: read values for length bins, specify number of length bins then lower edges of each bin
  DAT$lbin_method <- lbin_method 
  if(DAT$lbin_method == 2){
    
    DAT$binwidth     <- as.numeric(BIN.LIST[which(BIN.LIST$SPECIES == species), "BINWIDTH"])
    DAT$minimum_size <- as.numeric(BIN.LIST[which(BIN.LIST$SPECIES == species), "pop_min"]) #lower size of first bin
    DAT$maximum_size <- as.numeric(BIN.LIST[which(BIN.LIST$SPECIES == species), "pop_max"]) #lower size of largest bin 
    
  }
  if(DAT$lbin_method == 3){
    
    DAT$N_lbinspop      <- length(pop.length.bins)
    DAT$lbin_vector_pop <- pop.length.bins #seq(start_bin, end_bin, by = 2)
    
  }
  
  
  ## Environmental variables 
  DAT$N_environ_variables    <- 0
  ## Generalized size comp data
  DAT$N_sizefreq_methods     <- 0
  ## Tagging data
  DAT$do_tags                <- 0 
  ## Morph composition data
  DAT$morphcomp_data         <- 0
  ## Selectivity empirical data (future feature)
  DAT$use_selectivity_priors <- 0
  
  ## STEP 5. Save new dat file
  r4ss::SS_writedat_3.30(DAT, outfile = file.path(out.dir, paste0(species), "data.ss"), 
                         overwrite = TRUE, verbose = FALSE)
  
}

