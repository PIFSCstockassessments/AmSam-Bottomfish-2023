#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOTTOMFISH - INITIAL SS FILE CREATION
#	Use example model files (from https://github.com/nmfs-stock-synthesis/user-examples) as templates 
#   for adding in American Samoa data
#	Megumi Oshima megumi.oshima@noaa.gov
#  
#  --------------------------------------------------------------------------------------------------------------
## DAT file
#  --------------------------------------------------------------------------------------------------------------
build_dat <- function(species = NULL, scenario = "base", catch = NULL, initF = F, CPUEinfo = NULL, cpue = NULL, 
                      Nages = NULL, Narea = 1, Nsexes = NULL, lencomp = NULL, startyr = 1967, endyr = 2021, 
                      bin.list = NULL, fleets = 1, fleetinfo = NULL, lbin_method = 1, superyear = FALSE, 
                      superyear_blocks = NULL, N_samp = 40, file_dir = "base",
                      template_dir = file.path(root_dir, "SS3 models", "TEMPLATE_FILES"), 
                      out_dir = file.path(root_dir, "SS3 models")){
  
  nfleet <- length(fleets)
  
  ## STEP 2. Read in SS dat file
  DAT <- r4ss::SS_readdat_3.30(file = file.path(template_dir, "data.ss"))
  
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
           LOGSD.MT = ifelse(LOGSD.MT == 0, 0.001, LOGSD.MT)) %>% 
    dplyr::rename("year" = YEAR,
                  "catch" = MT,
                  "catch_se" = LOGSD.MT) %>% 
    dplyr::arrange(fleet, year) %>% 
    dplyr::select(-SPECIES) %>% 
    dplyr::select(year, seas, fleet, catch, catch_se)
  
  if(superyear == TRUE & is.null(superyear_blocks)){
    
    warning("No years were specified for super period. Please give a list of vectors containing start and end years.")
    
  }
  
  if(superyear == FALSE){
    
    lencomp.sp     <- lencomp %>% 
      dplyr::filter(str_detect(SPECIES, species)) %>% 
      dplyr::filter(YEAR >= startyr & YEAR <= endyr) %>% 
      dplyr::arrange(LENGTH_BIN_START) %>% 
      dplyr::mutate(Seas = 1,
                    FltSvy = as.numeric(factor(DATASET)), 
                    Sex = 0, 
                    Part = 0, 
                    LENGTH_BIN_START = paste0("l",LENGTH_BIN_START),
                    N = as.numeric(N)) %>% 
      dplyr::rename(Yr = YEAR,
                    Nsamp = EFFN) %>% 
      dplyr::select(Yr, Seas, FltSvy, Sex, Part, Nsamp, LENGTH_BIN_START, N) %>% 
      tidyr::pivot_wider(names_from = LENGTH_BIN_START, values_from = N) %>% 
      dplyr::arrange(Yr) %>% 
      dplyr::mutate(totN = rowSums(select(., starts_with("l")))) %>% 
      dplyr::filter(totN >= N_samp) %>% 
      dplyr::select(-totN)
    
  }else{
    
    n.superperiods <- length(superyear_blocks)
    
    lencomp.sp     <- lencomp %>% 
      dplyr::filter(str_detect(SPECIES, species)) %>% 
      dplyr::filter(YEAR >= startyr & YEAR <= endyr) %>% 
      dplyr::arrange(LENGTH_BIN_START) %>% 
      dplyr::mutate(Seas = 1,
                    FltSvy = as.numeric(factor(DATASET)), 
                    Sex = 0, 
                    Part = 0, 
                    LENGTH_BIN_START = paste0("l",LENGTH_BIN_START)) %>% 
      dplyr::rename(Yr = YEAR,
                    Nsamp = EFFN) %>% 
      dplyr::select(Yr, Seas, FltSvy, Sex, Part, Nsamp, LENGTH_BIN_START, N) %>% 
      dplyr::arrange(Yr)

    new.data <- list()
    for(i in 1:n.superperiods){
      new.data[[i]] <- lencomp.sp %>% 
        dplyr::filter(Yr >= superyear_blocks[[i]][1] & Yr <= superyear_blocks[[i]][2]) %>% 
        dplyr::group_by(LENGTH_BIN_START) %>% 
        dplyr::summarise(Nsamp = sum(Nsamp),
          N = sum(N)) 
    
      lencomp.sp[which(lencomp.sp$Yr >= superyear_blocks[[i]][1] & lencomp.sp$Yr <= superyear_blocks[[i]][2]), "SP"] <- i
      lencomp.sp[which(lencomp.sp$Yr == superyear_blocks[[i]][1]), "N"] <- new.data[[i]]$N
      lencomp.sp[which(lencomp.sp$Yr == superyear_blocks[[i]][1]), "Nsamp"] <- new.data[[i]]$Nsamp
      lencomp.sp[which(lencomp.sp$Yr > superyear_blocks[[i]][1] & lencomp.sp$Yr <= superyear_blocks[[i]][2]), "FltSvy"] <- -1
      lencomp.sp[which(lencomp.sp$Yr == superyear_blocks[[i]][1]), "Seas"] <- -1
      lencomp.sp[which(lencomp.sp$Yr == superyear_blocks[[i]][2]), "Seas"] <- -1
      
    }
    
    lencomp.sp <- lencomp.sp %>% 
      tidyr::pivot_wider(names_from = LENGTH_BIN_START, values_from = N) %>% 
      dplyr::mutate(totN = rowSums(select(., starts_with("l"))))
    
    lencomp.sp <- lencomp.sp[which(is.na(lencomp.sp$SP) & lencomp.sp$Nsamp > N_samp | !is.na(lencomp.sp$SP)), ]
      
    sp_to_remove <- lencomp.sp[which(lencomp.sp$Seas == -1 & lencomp.sp$FltSvy == 1 & lencomp.sp$totN < N_samp), "SP"]
    
    if(nrow(sp_to_remove) > 0){
      lencomp.sp <- lencomp.sp %>% 
        dplyr::filter(is.na(SP) | SP != sp_to_remove$SP) %>% 
        dplyr::select(-c(SP, totN))
    }else{
      lencomp.sp <- lencomp.sp %>% 
        dplyr::select(-c(SP, totN))
    }
    
  }
 
  
  if(Nsexes == 2){
    
    lencomp.sp <- lencomp.sp %>% 
      mutate(across(starts_with("l"), ~ ., .names = "{col}m")) %>% 
      mutate(Sex = 0)
  }
  
  ## STEP 4. Change inputs for dat file
  
  DAT$Comments        <- paste("#C data file for", species, sep = " ")
  DAT$styr            <- startyr
  DAT$endyr           <- endyr
  DAT$nseas           <- 1
  DAT$months_per_seas <- 12
  DAT$Nsubseasons     <- 2 #minimum number is 2
  DAT$spawn_month     <- 1
  DAT$Nsexes          <- Nsexes #1 ignore fraction female in ctl file, 2 use frac female in ctl file, -1 one sex and multiply spawning biomass by frac female
  DAT$Ngenders        <- NULL
  DAT$Nages           <- Nages
  DAT$N_areas         <- Narea #if want to explore fleets as areas, change this 
  DAT$Nfleets         <- nfleet  #include fishing fleets and surveys
  ## specify the fleet types, timing, area, units, any catch multiplier and fleet name in fleetinfo
  DAT$fleetinfo <- fleetinfo

  if(exists("catch.sp")){
    
    ## Add catch, column names: year, seas, fleet, catch, catch_se
    ## NOTE: will need to adjust if there are multiple fleets with catch
    if(initF == TRUE){
      init.catch <- data.frame(year = -999, 
                               seas = 1, fleet = 1, 
                               catch = catch.sp[catch.sp$year == startyr, "catch"], 
                               catch_se = catch.sp[catch.sp$year == startyr, "catch_se"])
    }else{
      init.catch <- data.frame(year = -999, 
                               seas = 1, fleet = 1, 
                               catch = 0, 
                               catch_se = 0.01)
    }

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
  
  if(exists("lencomp.sp")){
    
    ## Length Composition 
    DAT$len_info    <- data.frame(mintailcomp = rep(0, DAT$Nfleets),
                               addtocomp      = rep(0.0000001, DAT$Nfleets),
                               combine_M_F    = rep(0, DAT$Nfleets),
                               CompressBins   = rep(0, DAT$Nfleets),
                               CompError      = rep(0, DAT$Nfleets),
                               ParmSelect     = rep(0, DAT$Nfleets),
                               minsamplesize  = rep(1, DAT$Nfleets))
    
    DAT$N_lbins     <- length(select(lencomp.sp, starts_with("l")))
    if(Nsexes == 2){
      DAT$N_lbins = DAT$N_lbins/2
    }
    lbin_vector <- colnames(lencomp.sp[-c(1:6)])
    lbin_vector <- lbin_vector[!grepl("m", lbin_vector)]
    DAT$lbin_vector <- as.numeric(str_sub(lbin_vector, start = 2))
    
    ## Add length composition data, column names: Yr, Seas, FltSVy, Gender, Part, Nsamp, length_bin_values...
    DAT$lencomp     <- as.data.frame(lencomp.sp)
    
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
    
    DAT$binwidth     <- 1
    DAT$minimum_size <- 1 #lower size of first bin
    DAT$maximum_size <- bin.list %>% 
      filter(str_detect(SPECIES, species)) %>% 
      mutate(max = ceiling(max*1.1)) %>% 
      pull(max) #lower size of largest bin 
    
    
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
  r4ss::SS_writedat_3.30(DAT, outfile = file.path(out_dir, paste0(species), file_dir, "data.ss"), 
                         overwrite = TRUE, verbose = FALSE)
  
}

