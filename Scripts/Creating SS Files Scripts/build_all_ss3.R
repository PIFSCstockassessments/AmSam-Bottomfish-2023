### Script to create input files for SS and run the model then create a report for basic diagnostics

require(r4ss)
require(tidyverse)
require(this.path)
require(openxlsx)
require(purrr)

### Initial Inputs ####
root_dir <- this.path::here(.. = 2)
Species.List <- list.files(file.path(root_dir, "SS3 models"))

species <- Species.List[2]
startyr <- 1967
endyr <- 2021
fleets <- 1
nfleets <- length(fleets)
M_option_sp <- "Option1"


# Catch data
catch <- readRDS(file.path(root_dir, "Outputs", "CATCH_final.rds"))
# Life history data
life.history <-
  read.xlsx(file.path(root_dir, "Data", "CTL_parameters.xlsx"), sheet = species)
# Length comp data
len.comp <- readRDS(file.path(root_dir, "Outputs", "SS3_Inputs", "SIZE_final.rds"))
# CPUE data
cpue_files <- list.files(path = paste0(root_dir,"/Outputs/SS3_Inputs/CPUE"),
                         pattern = species,
                         full.names = TRUE)

cpue.list <- lapply(cpue_files, function(i){read.csv(i)})
area <- unlist(str_extract_all(cpue_files, pattern = c("Manua|Tutuila")))

cpue <- map(cpue.list, set_names, c("year", "obs", "se_log")) %>% 
  mapply(cbind, ., "index"= area, SIMPLIFY=F)  %>% 
  rbindlist() %>% 
  mutate(seas = 7,
         index = as.numeric(factor(index, levels = c("Tutuila", "Manua")))) %>% 
  select(year, seas, index, obs, se_log) %>% 
  filter(index %in% fleets) %>% 
  as.data.frame()

## Control file inputs
## sheet will index scenarios 
ctl.inputs <- read.xlsx(file.path(root_dir, "Data", "CTL_inputs.xlsx"), sheet = "base")
#lambdas <- read.xlsx(file.path(root_dir, "Data"))

### NOTE: if you want to specify population length bins with min and max 
# values different to data bins (method = 2), then add 2 columns to 
# BIN.LIST pop_min and pop_max with the min and max values to use for 
# each species.
BIN.LIST <- data.table(
  SPECIES = c(
    "APRU",
    "APVI",
    "CALU",
    "ETCA",
    "ETCO",
    "LERU",
    "LUKA",
    "PRFI",
    "PRFL",
    "PRZO",
    "VALO"
  ),
  BINWIDTH = c(5, 5, 5, 5, 5, 3, 2, 5, 5, 5, 5) # in cm
) 
BIN.LIST <- len.comp %>%
  group_by(SPECIES) %>%
  summarise(
    min = min(LENGTH_BIN_START),
    max = max(LENGTH_BIN_START)
  ) %>%
  merge(BIN.LIST, by = "SPECIES") %>%
  as.data.table()

fleetinfo <- data.frame(
  type = c(1),
  surveytiming = c(-1),
  units = c(1),
  area = c(1),
  need_catch_mult = c(0),
  fleetname = c("FISHERY")
)

CPUEinfo <- data.frame(
  Fleet = c(1),
  Units = c(1),
  Errtype = c(0),
  SD_Report = c(0)
  
)

## create Q options, age, and length selectivity types dataframes based on the number of fleets including. 
## NOTE: not the best way but if all species have the same fleets this will work.
Q.options <- data.frame(fleet = c(1), link = c(1), link_info = c(0), extra_se = c(0), biasadj = c(0), float = c(0))
#using recommended double normal for both patterns
size_selex_types <- data.frame(Pattern = c(24), Discard = c(0), Male = c(0), Special = c(0))
age_selex_types <- data.frame(Pattern = c(0), Discard = c(0), Male = c(0), Special = c(0))  




### Call the functions to build the SS3 files ####
source(file.path(root_dir, "Scripts", "Creating SS Files Scripts", "SS_BUILD_DAT.R"))
source(file.path(root_dir, "Scripts", "Creating SS Files Scripts", "SS_BUILD_START.R"))
source(file.path(root_dir, "Scripts", "Creating SS Files Scripts", "SS_BUILD_FORE.R"))
source(file.path(root_dir, "Scripts", "Creating SS Files Scripts", "SS_BUILD_CTL.R"))


### Build SS3 Files ####
build_dat(
  species = species,
  catch = catch,
  catch_se = 0.05,
  CPUEinfo = CPUEinfo,
  cpue = cpue,
  life.history = life.history,
  len.comp = len.comp,
  bin.list = BIN.LIST,
  fleets = 1,
  M_option_sp = "Option1",
  fleetinfo = fleetinfo,
  lbin_method = 1,
  template.dir = file.path(root_dir, "SS3 models", "TEMPLATE_FILES"),
  out.dir = file.path(root_dir, "SS3 models")
)

build_forecast(
  species = species,
  template.dir = file.path(root_dir, "SS3 models", "TEMPLATE_FILES", "forecast.ss"),
  out.dir = file.path(root_dir, "SS3 models"),
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
  ControlRule = 0
)

build_starter(
  species = species,
  template.dir = file.path(root_dir, "SS3 models", "TEMPLATE_FILES", "starter.ss"), 
  out.dir = file.path(root_dir, "SS3 models"),
  init_values = 0,
  parmtrace = 0,
  N_boot = 1,
  last_est_phs = 10,
  seed = 0123
)

build_control(
  species = species,
  ctl.inputs = ctl.inputs,
  includeCPUE = TRUE,
  Q.options = Q.options,
  M_option_sp = "Option1",
  size_selex_types = size_selex_types,
  age_selex_types = age_selex_types,
  template.dir = file.path(root_dir, "SS3 models", "TEMPLATE_FILES"),
  out.dir = file.path(root_dir, "SS3 models")
)


### Run Stock Synthesis ####
file.copy(file.path(root_dir, "SS3 models", "TEMPLATE_FILES", "ss_opt_win.exe"), 
          file.path(root_dir, "SS3 models", species))
run_SS_models(dirvec = file.path(root_dir, "SS3 models", species), 
              model = "ss_opt_win", extras = "-stopph 0 -nohess", skipfinished = FALSE)

report <- SS_output(file.path(root_dir, "SS3 models", species))
SS_plots(report, dir = file.path(root_dir, "SS3 models", species))
## Do Retrospectives
SS_doRetro(masterdir=file.path(root_dir, "SS3 models", "TEMPLATE_FILES"), 
           oldsubdir="", newsubdir="Retrospectives", years=0:-5)


## Do Profiling
## Create directory and copy inputs
dir.profile <- file.path(root_dir, "SS3 models", "TEMPLATE_FILES", "R0_Likelihood")
copy_SS_inputs(dir.old = file.path(root_dir, "SS3 models", "TEMPLATE_FILES"),
               dir.new = dir.profile,
               create.dir = TRUE,
               overwrite = TRUE,
               recursive = TRUE,
               use_ss_new = TRUE,
               copy_exe = TRUE,
               copy_par = FALSE,
               dir.exe = file.path(root_dir, "SS3 models", "TEMPLATE_FILES"),
               verbose = TRUE)

# Make changes to starter file
starter <- SS_readstarter(file.path(dir.profile, "starter.ss"))
starter[["ctlfile"]] <- "control_modified.ss"
# make sure the prior likelihood is calculated
# for non-estimated quantities
starter[["prior_like"]] <- 1
SS_writestarter(starter, dir = dir.profile, overwrite = TRUE)

# vector of values to profile over
r0.vec <- seq(8.2, 8.4, .1)
Nprofile <- length(r0.vec)

# run SS_profile command
profile <- SS_profile(
  dir = dir.profile, 
  model = "ss_opt_win",
  masterctlfile = "control.ss_new",
  newctlfile = "control_modified.ss",
  string = "SR_LN(R0)",
  profilevec = r0.vec
)


### Create Summary Report ####
rmarkdown::render("~/AmSam-Bottomfish-2023/Scripts/Creating SS Files Scripts/model_diags_report.Rmd", 
                  params = list(
                    species = "TEMPLATE_FILES",
                    scenario = "Base",
                    report = "../../SS3 models"
))
