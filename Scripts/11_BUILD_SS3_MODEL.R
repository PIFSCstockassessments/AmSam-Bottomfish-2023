## Wrapper function for building SS files and running the models
#' This function takes several arguments, for a specific species, and builds the 4 SS3 input files, and saves the files into the subdirectory of that species-scenario.
#' Note, you will need to set up Google Drive authentication with the `googlesheets4` package which will allow you to directly pull parameter input files from Google Drive into R session.
#' @param species the species to use
#' @param scenario a string to identify which scenario model is being developed under, needs to match name of sheet in CTL_inputs.xlsx file
#' @param startyr start year of the model
#' @param endyr end year of the model
#' @param fleets an integer or vector of integers of fleet id numbers (tutuila = 1, manua = 2), default is 1
#' @param M_option which option being used for natural mortality and Nages (found in CTL_parameters.xlsx), default is "Option1"
#' @param GROWTH_option see M_option (growth curve parameters: Lamin, Lamax, k, CV young & CV old)
#' @param LW_option see M_option (length-weight relationship)
#' @param MAT_option see M_option (maturity and fecundity: L50, L95,a,b,cohort growth, frac female)
#' @param SR_option see M_option (stock-recruitment, except R0)
#' @param Q_option see M_option (catchability)
#' @param EST_option see M_option (model estimated parameters: R0, Q, selectivity)
#' @param lambdas dataframe of lambda values, default is NULL 
#' @param includeCPUE default is true, if excluding CPUE, set to FALSE
#' @param init_values use ss.par file to run ss model (1), or no (0) (starter.ss input)
#' @param parmtrace can switch to 1 to turn on, helpful for debugging model (starter.ss input)
#' @param N_boot number of bootstrap files to produce (N >= 3 to run bootstrap) (starter.ss input)
#' @param last_est_phs last phase for estimation (starter.ss input)
#' @param seed value to set seed for run
#' @param benchmarks default set to 1, see forecast file for options (forecast.ss input)
#' @param MSY default set to 2, see forecast file for options (forecast.ss input)
#' @param SPR.target value to set target SPR at (forecast.ss input)
#' @param Btarget value to set B-ratio target at (forecast.ss input)
#' @param Bmark_years years for forecasting settings, see forecast file for options (forecast.ss input)
#' @param Bmark_relF_Basis how forecast catches are calculated and removed default = 1, use FSPR (forecast.ss input)
#' @param Nforeyears number of years to forecast for (forecast.ss input)
#' @param Fcast_years years for forecast settings, see forecast file for options (forecast.ss input)
#' @param ControlRule apply reductions to catch or F based on a control rule, see forecast file for options (forecast.ss input)
#' @param root_dir path to root directory
#' @param file_dir name of subdirectory to save files to, default is same as scenario
#' @param template_dir path to template SS files
#' @param out_dir first part of path to directory for saving files to, do not include species name or scenario
#' @param runmodels default TRUE, runs ss model
#' @param est_args extra arguments that can be added to ss call (i.e. -nohess)
#' @param do_retro TRUE or FALSE to run retrospective
#' @param retro_years years for retrospective peels, relative to end year, ie 0:-3 is 3 year peels
#' @param do_profile TRUE or FALSE to run likelihood profiling
#' @param profile string vector of parameter to profile, can be a vector of strings if changing multiple (ie "SR_LN(R0)")
#' @param profile.vec vector of values to profile over for the parameter of interest
#' @param do_jitter TRUE to run jitter analysis
#' @param Njitter number of jitters to run
#' @param jitterFraction increment of change for each jitter run
#' @param printreport default TRUE, produces summary diagnostics report
#' @param r4ssplots default is FALSE, will produce full r4ss output plots
#' 
#' 



build_all_ss <- function(species,
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
                         Nforeyrs = 10, 
                         Fcast_years = c(0,0,-10,0,-999,0),
                         ControlRule = 0,
                         root_dir = this.path::here(.. = 1),
                         file_dir = scenario,
                         template_dir = file.path(this.path::here(.. = 1), 
                                                  "SS3_models", "TEMPLATE_FILES"), 
                         out_dir = file.path(this.path::here(.. = 1), "SS3_models"),
                         runmodels = TRUE,
                         ext_args = "-stopph 3 -nohess",
                         do_retro = TRUE,
                         retro_years = 0:-5,
                         do_profile = TRUE,
                         profile = "SR_LN(R0)",
                         profile.vec = seq(8.2, 8.4, .1),
                         do_jitter = TRUE,
                         Njitter = 200,
                         jitterFraction = 0.1,
                         printreport = TRUE,
                         r4ssplots = TRUE
                         ){
  
  ## Step 1. Read in all data components ###-------------------------------------------
  
  # Catch data
  catch <- readRDS(file.path(root_dir, "Outputs", "CATCH_final.rds"))
  catch <- catch %>% mutate(MT = ifelse(MT == 0, 0.001, MT))
  # Length comp data
  lencomp <- readRDS(file.path(root_dir, "Outputs", "SS3_Inputs", "SIZE_final.rds"))
  # DAT inputs, single value parameters
  ctl.inputs <- read_sheet("11lPJV7Ub9eoGbYjoPNRpcpeWUM5RYl4W65rHHFcQ9fQ", sheet=scenario)
  # Control and data file inputs
  ctl.params <- read_sheet("1XvzGtPls8hnHHGk7nmVwhggom4Y1Zp-gOHNw4ncUs8E", 
                           sheet=species)
  
  
  ## Step 2. Source scripts with each function ###-------------------------------------
  ### Call the functions to build the SS3 files ####
  source(file.path(root_dir, "Scripts", "Creating SS Files Scripts", "SS_BUILD_DAT.R"))
  source(file.path(root_dir, "Scripts", "Creating SS Files Scripts", "SS_BUILD_START.R"))
  source(file.path(root_dir, "Scripts", "Creating SS Files Scripts", "SS_BUILD_FORE.R"))
  source(file.path(root_dir, "Scripts", "Creating SS Files Scripts", "SS_BUILD_CTL.R"))
  
  ## Step 3. Create other inputs ###---------------------------------------------------
  ### Create subdirectory
  if(!dir.exists(file.path(root_dir, "SS3_models", species, file_dir))){
    dir.create(file.path(root_dir, "SS3_models", species, file_dir))
  }
  
  ## Create text file with notes from CTL_params sheet for reference
  sink(file.path(root_dir, "SS3_models", species, file_dir,"model_options.txt"))
  
  cat(paste0("M: ", M_option, ", ", ctl.params$Notes[which(ctl.params$category == "MG" & 
                                                             ctl.params$OPTION == M_option &
                                                             ctl.params$X1 == "NatM_p_1_Fem_GP_1")] ,"\n"))
  
  cat(paste0("Growth: ", M_option, ", ", ctl.params$Notes[which(ctl.params$category == "MG" & 
                                                                  ctl.params$OPTION == M_option &
                                                                  ctl.params$X1 == "L_at_Amin_Fem_GP_2")] ,"\n"))
  
  cat(paste0("Stock-Recruit: ", SR_option, ", ", ctl.params$Notes[which(ctl.params$category == "SR" & 
                                                                  ctl.params$OPTION == SR_option &
                                                                  ctl.params$X1 == "SR_LN(R0)")] ,"\n"))
  
  sink()
  
  ## Remove notes column 
  ctl.params <- select(ctl.params, -Notes)
  
  Nfleets <- length(fleets)
  
  Nages <- ctl.params %>% 
       dplyr::filter(str_detect(OPTION, M_option)) %>% 
       dplyr::filter(str_detect(X1, "Nages")) %>% 
       pull(INIT) 
  
  Narea <- ctl.inputs %>% 
    select(Parameter, paste0(species)) %>% 
    filter(str_detect(Parameter, "N_areas")) %>% 
    pull()
  
  Nsexes <- ctl.inputs %>% 
    select(Parameter, paste0(species)) %>% 
    filter(str_detect(Parameter, "Nsexes")) %>% 
    pull()
  
  # CPUE data
  cpue_files <- list.files(path = paste0(root_dir,"/Outputs/SS3_Inputs/CPUE"),
                           pattern = species,
                           full.names = TRUE)
  
  cpue.list <- lapply(cpue_files, function(i){read.csv(i)})
  area <- unlist(str_extract_all(cpue_files, 
                                 pattern = c("Manua|Tutuila")))
  
  cpue <- map(cpue.list, set_names, c("year", "obs", "se_log")) %>% 
    mapply(cbind, ., "index"= area, SIMPLIFY=F)  %>% 
    rbindlist() %>% 
    mutate(seas = 7,
           index = as.numeric(factor(index, levels = c("Tutuila", "Manua")))) %>% 
    select(year, seas, index, obs, se_log) %>% 
    filter(index %in% fleets) %>% 
    filter(year >= startyr & year <= endyr) %>% 
    as.data.frame()
  
  # Length Bins
  Species.List <- unique(lencomp$SPECIES)
  BIN.LIST     <- data.table(SPECIES=Species.List,min=0,max=0,BINWIDTH=0)
  for(i in 1:length(Species.List)){
    BinWidth             <- diff(unique(lencomp[SPECIES==Species.List[i]]$LENGTH_BIN_START))
    BIN.LIST[i]$BINWIDTH <- as.integer(names(which.max(table(BinWidth))))
    BIN.LIST[i]$min      <- min(lencomp[SPECIES==Species.List[i]]$LENGTH_BIN_START)
    BIN.LIST[i]$max      <- max(lencomp[SPECIES==Species.List[i]]$LENGTH_BIN_START)
  }
  
 # Selectivity types
  size_selex_types <- ctl.inputs %>% 
    select(Parameter, contains(paste0(species))) %>% 
    filter(str_detect(Parameter, "size_selex")) %>% 
    mutate(Fleet = str_extract(Parameter, "[0-9]*$") %>% 
             as.numeric(),
           Fleet = str_replace_na(Fleet, replacement = "1"),
           Parameter = str_remove_all(Parameter, "_[0-9]*$")
           ) %>% 
    filter(Fleet %in% fleets) %>% 
    pivot_wider(names_from = Parameter, values_from = paste0(species)) %>% 
    mutate(Male = 0) %>% 
    select(size_selex_pattern, size_selex_discard, Male, size_selex_special) %>% 
    setNames(c("Pattern", "Discard", "Male", "Special")) %>% 
    as.data.frame() 
  
  # if(Nfleets > 1){
  #   
  # }
  
  age_selex_types <- ctl.inputs %>% 
    select(Parameter, contains(paste0(species))) %>% 
    filter(str_detect(Parameter, "age_selex")) %>% 
    pivot_wider(names_from = Parameter, values_from = paste0(species)) %>% 
    mutate(Male = 0,
           Special = 0) %>% 
    setNames(c("Pattern", "Discard", "Male", "Special")) %>% 
    as.data.frame() %>% 
    slice(rep(1:n(), each = Nfleets)) #assume same selectivity pattern for both areas
    
  # Catchability options
  Q.options <- ctl.inputs %>% 
    select(Parameter, contains(paste0(species))) %>% 
    filter(str_detect(Parameter, "Q.opt")) %>% 
    mutate(Fleet = str_extract(Parameter, "[0-9]*$") %>% 
             as.numeric(),
           Parameter = str_remove_all(Parameter, "_[0-9]*$")) %>% 
    filter(Fleet %in% fleets) %>% 
    pivot_wider(names_from = Parameter, values_from = paste0(species)) %>% 
    setNames(c("fleet", "link", "link_info", "extra_se", "biasadj", "float"))
  
  # Fleet and CPUE info
  cpueinfo <- as.data.frame(matrix(data = fleets, nrow = Nfleets, ncol = 4))
  colnames(cpueinfo) <- c("Fleet", "Units", "Errtype", "SD_Report")
  cpueinfo$Fleet <- fleets 
  cpueinfo$Units <- 1
  cpueinfo$Errtype <- 0 #lognormal
  cpueinfo$SD_Report <- 0
  
  
  need_catch_mult <- ctl.inputs %>% 
    select(Parameter, paste0(species)) %>% 
    filter(str_detect(Parameter, "catch_mult")) %>% 
    mutate(Fleet = str_extract(Parameter, "[0-9]*$") %>% 
             as.numeric()) %>% 
    filter(Fleet %in% fleets) %>% 
    pull(paste0(species))
  
  fleetid <- seq(1, Nfleets)
  fleetid[1] <- "FISHERY"
  fleetid[-1] <- paste0("SURVEY", fleetid[-1])
  fleetname <- fleetid
  
  fleetinfo <- data.frame(
    type = c(1,rep(3, Nfleets-1)), 
    surveytiming = c(-1, rep(1, Nfleets-1)), 
    units = rep(1, Nfleets),
    area = rep(1, Nfleets),
    need_catch_mult = need_catch_mult,
    fleetname = fleetname
  )
 
  
  ## Step 4. Create SS3 input files
  build_dat(
    species = species,
    scenario = scenario,
    startyr = startyr,
    endyr = endyr,
    catch = catch,
    CPUEinfo = cpueinfo,
    cpue = cpue,
    Nages = Nages,
    Nsexes = Nsexes,
    lencomp = lencomp,
    bin.list = BIN.LIST,
    fleets = fleets,
    fleetinfo = fleetinfo,
    lbin_method = 2,
    file_dir = file_dir,
    template_dir = template_dir,
    out_dir = out_dir
  )
  
  build_control(
    species = species,
    scenario = scenario,
    Nfleets = Nfleets,
    Nsexes = Nsexes, 
    ctl.inputs = ctl.inputs,
    ctl.params = ctl.params,
    includeCPUE = includeCPUE,
    Q.options = Q.options,
    M_option = M_option,
    GROWTH_option = GROWTH_option,
    LW_option = LW_option,
    MAT_option = MAT_option,
    SR_option = SR_option,
    EST_option = EST_option,
    size_selex_types = size_selex_types,
    age_selex_types = age_selex_types,
    lambdas = lambdas,
    file_dir = file_dir,
    template_dir = template_dir,
    out_dir = out_dir
  )
  
  build_starter(
    species = species,
    scenario = scenario,
    file_dir = file_dir,
    template_dir = template_dir, 
    out_dir = out_dir,
    init_values = init_values,
    parmtrace = parmtrace,
    N_boot = N_boot,
    last_est_phs = last_est_phs,
    seed = seed
  )
  
  build_forecast(
    species = species,
    scenario = scenario,
    file_dir = file_dir,
    template_dir = template_dir, 
    out_dir = out_dir,
    benchmarks = benchmarks,
    MSY = MSY,
    endyr = endyr,
    SPR.target = SPR.target,
    Btarget = Btarget,
    Bmark_years = Bmark_years,
    Bmark_relF_Basis = Bmark_relF_Basis,
    Forecast = Forecast,
    Nforeyrs = Nforeyrs, 
    Fcast_years = Fcast_years,
    ControlRule = ControlRule
  )
  
  if(runmodels){
    ### Run Stock Synthesis ####
    file.copy(file.path(root_dir, "SS3_models", "TEMPLATE_FILES", "ss_opt_win.exe"), 
              file.path(root_dir, "SS3_models", species, file_dir))
    r4ss::run_SS_models(dirvec = file.path(root_dir, "SS3_models", species, file_dir), 
                  model = "ss_opt_win", extras = ext_args,  skipfinished = FALSE)
  }
  
  if(r4ssplots){
    report <- r4ss::SS_output(file.path(root_dir, "SS3_models", species, file_dir), 
                              verbose = FALSE, printstats = FALSE)
    r4ss::SS_plots(report, dir = file.path(root_dir, "SS3_models", species, file_dir))
    r4ss::SS_plots(report, dir = file.path(root_dir, "SS3_models", species, file_dir), pdf=TRUE, png=FALSE)
    
  }
  
  source(file.path(root_dir, "Scripts", "12_RUN_DIAGS.R"))
  
  run_diags(root_dir = root_dir,
            species = species,
            file_dir = file_dir,
            do_retro = do_retro,
            retro_years = retro_years,
            do_profile = do_profile,
            profile = profile,
            profile.vec = profile.vec,
            do_jitter = do_jitter,
            Njitter = Njitter,
            jitterFraction = jitterFraction
  )
  
  if(printreport){
    ### Create Summary Report ####
    if(!file.exists(file.path(root_dir, "SS3_models", species, file_dir, paste0(species, "_", file_dir, "_model_diags_report.Rmd")))){
      file.copy(from = file.path(root_dir,"/Scripts/Creating SS Files Scripts/model_diags_report.Rmd"), 
                to = file.path(root_dir, "SS3_models", species, file_dir, paste0(species, "_", file_dir, "_model_diags_report.Rmd")))
    }
    
    
    rmarkdown::render(file.path(root_dir, "SS3_models", species, file_dir, paste0(species, "_", file_dir, "_model_diags_report.Rmd")), 
                      output_file = paste(species, file_dir, "SS3_Diags_Report", sep = "_"),
                      output_dir =  file.path(root_dir, "SS3_models", species, file_dir),
                      params = list(
                        species = paste0(species),
                        scenario = scenario,
                        profile = profile,
                        profile_vec = profile.vec,
                        Njitter = Njitter
                      ))
  }
  


  
} 
